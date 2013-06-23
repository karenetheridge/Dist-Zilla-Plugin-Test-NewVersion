use strict;
use warnings;
package Dist::Zilla::Plugin::Test::NewVersion;
# ABSTRACT: ...

use Moose;
with
    'Dist::Zilla::Role::FileGatherer',
    'Dist::Zilla::Role::TextTemplate',
    'Dist::Zilla::Role::FileFinderUser' => {
        default_finders => [ ':InstallModules' ],
    },
;
use Data::Section -setup;

sub gather_files
{
    my $self = shift;

    my $filename = 'xt/release/new-version.t';

    # generate $filename with $content...

    require Module::Metadata;
    require Dist::Zilla::File::FromCode;

    my @files = @{ $self->found_files };
    my @packages = map {
        Module::Metadata->new_from_file($_->name)->name
    } @files;

    my $file  = Dist::Zilla::File::FromCode->new({
        name => $filename,
        code => sub {
            my $content = $self->fill_in_string(
                ${$self->section_data($filename)},
                {
                    dist => \($self->zilla),
                    packages => \@packages,
                },
            );
            $content;
        },
    });

    $self->add_file($file);
    return;
}

__DATA__
___[ xt/release/new-version.t ]___
use strict;
use warnings FATAL => 'all';

use Encode;
use LWP::UserAgent;
use JSON;
use Module::Runtime 'use_module';

# returns bool, detailed message
sub version_is_bumped
{
    my $pkg = shift;

    my $ua = LWP::UserAgent->new(keep_alive => 1);
    $ua->env_proxy;

    my $res = $ua->get("http://cpanidx.org/cpanidx/json/mod/$pkg");
    unless ($res->is_success) {
        return (1, $pkg . ' not found in index - first release, perhaps?');
    }

    # JSON wants UTF-8 bytestreams, so we need to re-encode no matter what
    # encoding we got. -- rjbs, 2011-08-18 (in Dist::Zilla)
    my $json_octets = Encode::encode_utf8($res->decoded_content);
    my $payload = JSON::->new->decode($json_octets);

    unless (\@$payload) {
        return (0, 'no valid JSON returned');
    }

    my $current_version = use_module($pkg)->VERSION;
    return (0, $pkg . ' version is not set') if not defined $current_version;

    my $indexed_version = version->parse($payload->[0]{mod_vers});
    return (1) if $indexed_version < $current_version;

    return (0, $pkg . ' is indexed at: ' . $indexed_version . '; local version is ' . $current_version);
}

foreach my $pkg (
{{ join(",\n", map { '    q{' . $_ . '}' } @packages) }}
)
{
    my ($bumped, $message) = version_is_bumped($pkg);
    ok($bumped, $pkg . ' version is greater than version in index');
    note $message if $message;
}
__END__

=pod

=head1 SYNOPSIS

    use Dist::Zilla::Plugin::Test::NewVersion;

    ...

=head1 DESCRIPTION

...

=head1 FUNCTIONS/METHODS

=over 4

=item * C<foo>

...

=back

=head1 SUPPORT

=for stopwords irc

Bugs may be submitted through L<the RT bug tracker|https://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-Test-NewVersion>
(or L<bug-Dist-Zilla-Plugin-Test-NewVersion@rt.cpan.org|mailto:bug-Dist-Zilla-Plugin-Test-NewVersion@rt.cpan.org>).
I am also usually active on irc, as 'ether' at C<irc.perl.org>.

=head1 ACKNOWLEDGEMENTS

...

=head1 SEE ALSO

=begin :list

* L<foo>

=end :list

=cut

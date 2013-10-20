# NAME

Dist::Zilla::Plugin::Test::NewVersion - Generate a test that checks a new version has been assigned

# VERSION

version 0.009

# SYNOPSIS

    # in dist.ini:
    [Test::NewVersion]

# DESCRIPTION

This [Dist::Zilla](http://search.cpan.org/perldoc?Dist::Zilla) plugin generates a release test `new-version.t`, which
checks the PAUSE index for latest version of each module, to confirm that
the version number(s) has been/have been incremented.

This is mostly useful only for distributions that do not automatically
increment their version from an external source, e.g.
[Dist::Zilla::Plugin::Git::NextVersion](http://search.cpan.org/perldoc?Dist::Zilla::Plugin::Git::NextVersion).

It is permitted for a module to have no version number at all, but if it is
set, it must have been incremented from the previous value, as otherwise this case
would be indistinguishable from developer error (forgetting to increment the
version), which is what we're testing for.  You can, however, explicitly
exclude some files from being checked, by passing your own
[FileFinder](http://search.cpan.org/perldoc?Dist::Zilla::Role::FileFinderUser#default\_finders).

# CONFIGURATION

This plugin takes as an optional setting:

- `finders` - list the finder(s), one per line, that are to be used for

    finding the modules to test.  Defaults to `:InstallModules`; other
    pre-defined options are listed in [FileFinder](http://search.cpan.org/perldoc?Dist::Zilla::Role::FileFinderUser#default\_finders).
    You can define your own with the
    [Dist::Zilla::Plugin::FileFinder::ByName](http://search.cpan.org/perldoc?\[FileFinder::ByName\]) plugin.

# SUPPORT

Bugs may be submitted through [the RT bug tracker](https://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-Test-NewVersion)
(or [bug-Dist-Zilla-Plugin-Test-NewVersion@rt.cpan.org](mailto:bug-Dist-Zilla-Plugin-Test-NewVersion@rt.cpan.org)).
I am also usually active on irc, as 'ether' at `irc.perl.org`.

# SEE ALSO

- [Dist::Zilla::Plugin::CheckVersionIncrement](http://search.cpan.org/perldoc?Dist::Zilla::Plugin::CheckVersionIncrement)

# AUTHOR

Karen Etheridge <ether@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Karen Etheridge.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

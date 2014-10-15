## The LIRC remote configurations project.

The LIRC project is about managing IR remotes. For each remote used, there
should be a configuration file. This project manages these files.

The configurations here should be usable in current LIRC versions and also in
winLIRC. However, the real purpose of this project is to provide a better
foundation for configuration tools. These tools are in (in the time of writing
upcoming) 0.9.2 version.

### Changes compared to previous version.

The "old" definitions lived partly in the lirc sources (in the remotes/
directory) and partly (mostly) in the [remotes database]
(http://sourceforge.net/p/lirc/remotes-table.html). Compared to these this project
has:

  - Merged all definitions in one place
  - Since we are using git, here is a history.
  - Cleaned-up some non-parsable definition.
  - Renamed files to more uniform naming conventions.
  - Nightly scripts running which indexes the database.


### LIRC configuration file tools.

There are some new tools in LIRC for configuration files:

  - lirc-config-tool can be used to scan for old key symbols not in
    the namespace, and can also update in many cases.

  - lirc-lsremotes can parse configuration files and report errors.

### Remote configuration guidelines.

There is a [new document](remotes-checklist.html) describing how to check
new configurations before they are added to the database.

!SLIDE subsection

# ~~~SECTION:MAJOR~~~ Resources


!SLIDE smbullets small
# Resources

* Puppet includes in its installation some core resource types, for example:
 * user
 * group
 * file
 * package
 * service
* Additional ones can be provided by modules, for example:
 * file_line
 * ini_setting
 * mysql_database
 * vcsrepo
* A list can be generated with the puppet describe command

~~~SECTION:handouts~~~

****

Puppet includes in its installation some core resource types. Most of those are realy basic
types like user, group, file, package or service, but some are very specific like the Nagios
objects or Solaris zones, zfs and zpool.

Additional ones can be provided by modules like file_line from puppetlabs/stdlib, ini_setting
from puppetlabs/inifile, mysql_database from puppetlabs/mysql and vcsrepo from puppetlabs/vcsrepo.

A list of all known resource types can be generated with the `puppet describe` command:

     # puppet describe --list

Documentation of a resource type can be displayed with this command, too. Append the parameter `-s`
to only get a summarized version.

     # puppet describe <type> [-s]
     # puppet describe user -s

To render the documentation in some other format use the `puppet doc` command like:

     # puppet doc -r type

~~~ENDSECTION~~~

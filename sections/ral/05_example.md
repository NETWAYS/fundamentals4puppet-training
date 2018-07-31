!SLIDE smbullets small
# Example managing user

* Managing a user without Puppet means managing:
 * Existence of user and attributes
 * Group membership
 * Home directory 
* Requires knowledge of:
 * Installed tool (*useradd* or *adduser*)
 * Options of those tools (*-g* or *-G*)
 * Creating, changing, deleting requires different tools (*useradd*, *usermod*, *userdel*)
* Challenges for automation:
 * Scripting
 * Error handling and logging
 * Multiple platforms

~~~SECTION:handouts~~~

****

Managing a user without Puppet means managing the existence of the user and its attributes,
managing groups required for group membership and existence and permissions of the home directory.

~~~PAGEBREAK~~~

This task is quite simple but requires to know which tools you will reliable find on your systems.
Some distributions install *useradd*, others *adduser* for creating a user. Then you have to know
the options to provide, e.g. what was the difference of *-g* and *-G*, which can get more complicated
if using multiple systems, e.g. modifying additional group membership *-a -G newgroup* works on RHEL,
*-A newgroup* on SLES and on AIX you have to provide a list of all groups to *-G*. Also managing a
user between different states will require different tools like *useradd* for creation, *usermod* for
changes on existing users and *userder* for deletion.

This will all increase the challenge of automation of user management. It has to be scripted in a
readable and maintainable way including error handling and logging. If your goal is the support of
multiple platforms it increases complexity and limits options.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Example managing user

* The same task with Puppet
 * Describe the user
 * Enforce with Puppet

   <pre>
   user { 'icinga':
     ensure     => present,
     gid        => 'icinga',
     groups     => ['icingacmd'],
     home       => '/var/spool/icinga',
     shell      => '/sbin/nologin',
     managehome => true,
   }
   </pre>

~~~SECTION:handouts~~~

****

The same task is very easy with Puppet. You only have to describe the user in Puppet Domain Specific Language
and the run Puppet to enforce it. Puppet will create the user if it does not exist and make adjustments if the
user exists like attributes which do not match the desired state.

~~~ENDSECTION~~~

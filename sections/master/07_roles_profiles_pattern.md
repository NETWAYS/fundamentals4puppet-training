!SLIDE smbullets small
# Roles-Profile-Pattern

* Puppet is all about abstraction
* Wants to simplify things
* Good module design
 * compose system configuration
 * interchangeable
* Roles-Profile-Pattern takes this to the next level
 * Component Modules - technical implementation
 * Profile - site specific implementation
 * Role - business logic


~~~SECTION:handouts~~~

****

The Roles-Profile-Pattern is a design pattern that takes the Puppet approach to the next level.

It was designed by Craig Dunn to simplifiy node declaration by abstracting modules even more.
It requires a good module design so you can compose a system's configuration from interchangeable
parts. In this design a component module abstracts the technical implementation and tries to parameterize
in a way a module is useable for every possible scenario. How this module is used in a specfic enviroment
is then declared on the next level the so called profiles. The role of a system then builds the business
logic on top of this profiles.

The inital idea is explained on http://www.craigdunn.org/2012/05/239/ and the next slides will give you
an example.

~~~ENDSECTION~~~


!SLIDE smbullets small noprint
# Roles-Profiles-Pattern - Component Modules

<img src="./_images/rolesprofilespattern_component.png" style="float: center; margin-left: 50px; width: 800px; height: 192px;" alt="Roles-Profiles-Pattern - Component Modules">

<pre>
    class apache (
      $apache_name            = $::apache::params::apache_name,
      $service_name           = $::apache::params::service_name,
      $default_mods           = true,
      $default_vhost          = true,
      ...

    define apache::vhost(
      $docroot,
      $manage_docroot              = true,
      $virtual_docroot             = false,
      $port                        = undef,
      ...
</pre>


!SLIDE smbullets small printonly
# Roles-Profiles-Pattern - Component Modules

<img src="./_images/rolesprofilespattern_component.png" style="width: 480px; height: 115px;" alt="Roles-Profiles-Pattern - Component Modules">

~~~SECTION:handouts~~~

****

The picture above show some typical component modules which should have a parameterized default class,
subclasses and defined resources to use on the next level.

~~~PAGEBREAK~~~

For example: *Apache*

    # head -5 modules/apache/manifests/init.pp
    class apache (
      $apache_name            = $::apache::params::apache_name,
      $service_name           = $::apache::params::service_name,
      $default_mods           = true,
      $default_vhost          = true,
    # head -5 modules/apache/manifests/vhost.pp
    define apache::vhost(
      $docroot,
      $manage_docroot              = true,
      $virtual_docroot             = false,
      $port                        = undef,

    # head -5 modules/apache/manifests/mods/php.pp
    class apache::mod::php (
      $package_name   = undef,
      $package_ensure = 'present',
      $path           = undef,
      $extensions     = ['.php'],

~~~ENDSECTION~~~

!SLIDE smbullets small noprint
# Roles-Profiles-Pattern - Profiles

<img src="./_images/rolesprofilespattern_profiles.png" style="float: center; margin-left: 50px; width: 800px; height: 282px;" alt="Roles-Profiles-Pattern - Profiles">

<pre>
     class profiles::base {
       include ssh
       include postfix::mta

       class { 'motd':
         template => 'profiles/motd_base.erb'
       }
</pre>

!SLIDE smbullets small printonly
# Roles-Profiles-Pattern - Profiles

<img src="./_images/rolesprofilespattern_profiles.png" style="width: 480px; height: 169px;" alt="Roles-Profiles-Pattern - Profiles">


~~~SECTION:handouts~~~

****

Above you can see profiles that will build upon the component modules. They define and retrieve application data, declare classes
with parameters and little to no logic or resources.

~~~PAGEBREAK~~~

For example: *Base Profiles*

     # vi modules/profiles/manifests/base.pp
     class profiles::base {
       include ssh
       include postfix::mta

       class { 'motd':
         template => 'profiles/motd_base.erb'
       }

       class { 'icinga':
       ... 
     }

     # vi modules/profiles/manifests/base/hardening.pp
     class profiles::base::hardening {
       class { 'ssh':
         permit_root => false
       }

       include postfix::mta

       class { 'motd':
         template => 'profiles/motd_hardening.erb'
       }

       class { 'icinga':
       ... 
     }

~~~ENDSECTION~~~


!SLIDE smbullets small noprint
# Roles-Profiles-Pattern - Roles

<img src="./_images/rolesprofilespattern_roles.png" style="float: center; margin-left: 50px; width: 800px; height: 371px;" alt="Roles-Profiles-Pattern - Roles">

<pre>
     class roles::webserver::external {
       include profiles::base::hardening
       include profiles::webserver::typo3
     }
</pre>

!SLIDE smbullets small printonly
# Roles-Profiles-Pattern - Roles

<img src="./_images/rolesprofilespattern_roles.png" style="width: 480px; height: 223px;" alt="Roles-Profiles-Pattern - Roles">

~~~SECTION:handouts~~~

****

Above you can see one typically role consisting of profiles without any logic to be declared on a node.

~~~PAGEBREAK~~~

For Example: 

     # vi modules/roles/manifests/webserver/external.pp
     class roles::webserver::external {
       include profiles::base::hardening
       include profiles::webserver::typo3
     }

     # vi manifests/site.pp
     node 'www.example.com' {
       include roles::webserver::external
     }

~~~ENDSECTION~~~


!SLIDE smbullets small noprint
# Roles-Profiles-Pattern - Stack

Best combined with an External Node Classifier and Hiera for even more simplification

<img src="./_images/rolesprofilespattern_stack.png" style="float: center; margin-left: 50px; width: 800px; height: 257px;" alt="Roles-Profiles-Pattern - Stack">

* Node Assignment without deeper knowledge
* Profile creation requires more internal know-how than about application
* Component modules require application know-how not internal

!SLIDE smbullets small printonly
# Roles-Profiles-Pattern - Stack

<img src="./_images/rolesprofilespattern_stack.png" style="width: 480px; height: 223px;" alt="Roles-Profiles-Pattern - Stack">

~~~SECTION:handouts~~~

****

The Roles-Profiles-Pattern is best combined with an External Node Classifier and Hiera for even more simplification.
So assigning a role to a node can be done in a webinterface or some other external tool by anyone without any deeper
knowledge in Puppet or the required tools. Profiles can be created and parameterized with minimal knowledge of Puppet
and the tools to be configured and require more knowlegde of interal proccesse.

~~~PAGEBREAK~~~

In-depth knowledge is only required by the developers of the component modules, but near to no know-how about internal processes.

~~~ENDSECTION~~~

!SLIDE smbullets small
# Inheritance

* Classes can inherit from other classes
* Inheritance allows for special-case classes extending a base class
 * Inherits parameters, variables and resources
 * Allows to extend the class, override and append existing values
 * **But** can also be handled with include and parameters

   <pre>
   class base::freebsd inherits base::unix {
     File['/etc/passwd'] {
       group => 'wheel',
     }
     File['/etc/shadow'] {
       group => 'wheel',
     }
   }<br>
   class apache::ssl inherits apache {
     Service['apache'] {
       require +> [ File['apache.pem'], File['httpd local.conf'] ],
     }
   }
   </pre>

~~~PAGEBREAK~~~

~~~SECTION:handouts~~~

****

In Puppet inheritance between classes is possible which allows to build special-case classes
extending a base class. This child classes inherit parameters, variables and resources and
can extend the class, override and append existing values.

This example show a class "base::freebsd" inheriting from "base::unix" and overwriting the
group attribute for some file resources using the reference on the already declared ones.

    class base::freebsd inherits base::unix {
      File['/etc/passwd'] {
        group => 'wheel',
      }
      File['/etc/shadow'] {
        group => 'wheel',
      }
    }

Overwriting with `undef` can also be used to remove an attribute from inheritance. Puppet will
not manage this attribute if declaring the child class.

    class base::content inherits base {
      File['/path/to/some/file'] {
        source  => undef,
        content => template('base/file.erb'),
      }
    }

~~~PAGEBREAK~~~

Extending an attributes value list works for arrays and hashes and can be quite useful for
extended depenencies. It uses a special `+>` instead of `->`.

    class apache::ssl inherits apache {
      Service['apache'] {
        require +> [ File['apache.pem'], File['httpd local.conf'] ],
      }
    }

Internally inheritance works by declaring the parent class first and allowing the child class
to override values. This can get complicated especially with the scope of variables, also
with the static scope in Puppet 4 it gets more predictable. But you can avoid inheritance in
the most cases by using `include` or `contain` and some class parameters.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Params.pp Pattern

* Seperate calculating default parameter from code
 * params.pp handles parameter calculation
 * main class inherits params
 * all parameters are set to default provided by params
* Only style guide conform use of inheritance

   <pre>
   class apache::params {
     case $::osfamily {
       'RedHat': {
          $hhtpd_user    = 'apache'
       }
       'Debian': {
          $hhtpd_user    = 'www-data'
       }
     }
   }<br>
   class apache (
     $http_user = $apache::params::user,
   ) inherits apache::params {
     ...
   }
   </pre>

~~~SECTION:handouts~~~

****

~~~PAGEBREAK~~~

The params.pp pattern is the only style guide conform use of inheritance.

Its purpose is to seperate calculating default parameter from the actual code for configuration.
In a subclass params of the module is all the parameter calculation handled and the main class
inherits this class to access this parameters. This also requires that every parameter is set to
the default provided by params class.

An extended version of the example above:

    class apache::params {
      case $::osfamily {
        'RedHat': {
           $httpd_user    = 'apache'
           $httpd_group   = 'apache'
           $httpd_pkg     = 'httpd'
           $httpd_svc     = 'httpd'
           $httpd_conf    = 'httpd.conf'
           $httpd_confdir = '/etc/httpd/conf'
           $httpd_docroot = '/var/www/html'
        }
        'Debian': {
           $httpd_user    = 'www-data'
           $httpd_group   = 'www-data'
           $httpd_pkg     = 'apache2'
           $httpd_svc     = 'apache2'
           $httpd_conf    = 'apache2.conf'
           $httpd_confdir = '/etc/apache2'
           $httpd_docroot = '/var/www'
        }
        default: {
          fail("Module ${module_name} is not supported on ${::osfamily}")
        }
      }
    }

~~~PAGEBREAK~~~

    class apache (
      $httpd_user    = $apache::params::httpd_user,
      $httpd_group   = $apache::params::httpd_group,
      $httpd_pkg     = $apache::params::httpd_pkg,
      $httpd_svc     = $apache::params::httpd_svc,
      $httpd_conf    = $apache::params::httpd_conf,
      $httpd_confdir = $apache::params::httpd_confdir,
      $httpd_docroot = $apache::params::httpd_docroot,
    ) inherits apache::params {

      file { $httpd_docroot:
        ensure => directory,
      }

      file { "${httpd_docroot}/index.html":
        ensure  => file,
        content => template('apache/index.html.erb'),
      }

      apache::vhost { $::fqdn:
        docroot => $httpd_docroot,
      }
      ...
    }

With Puppet 4 a new functionality named "Data in Modules" is available which can possibly replace
this widely adopted pattern. One of the possible ways to do so we will see later.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Params.pp Pattern

* Objective:
 * Move the default parameters of your apache class to a seperate class
* Steps:
 * Create a params class providing your default parameters
 * Remove the parameter calculation based on "$::osfamily" from your main class
 * Inherit your params class and use its values as default


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Params.pp Pattern

## Objective:

****

* Move the default parameters of your apache class to a seperate class

## Steps:

****

* Create a params class providing your default parameters

Provide all parameters of the calculation based on "$::osfamily" and also the "$ssl"
parameter which should be default "true" for all operating system families support is implemented.

* Remove the parameter calculation based on "$::osfamily" from your main class

You have to keep the calculation for "$ensure" in the main class because of being
based on a parameter provided to this class.

* Inherit your params class and use its values as default

You need to add all the variables to your main class's parameter list.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Params.pp Pattern

****

## Create a params class providing your default parameters

****

### Create a params class providing your default parameters

    $ vim ~/puppet/modules/apache/manifests/params.pp
    class apache::params {
      case $::osfamily {
        'RedHat': {
          $packagename = 'httpd'
          $configdir   = '/etc/httpd'
          $confd       = "${configdir}/conf.d"
          $servicename = 'httpd'
          $ssl         =  true
        }
        'Debian': {
          $packagename = 'apache2'
          $configdir   = '/etc/apache2'
          $confd       = "${configdir}/conf.d"
          $servicename = 'apache2'
          $ssl         =  false
        }
        default: {
          fail('Your platform is not supported.')
        }
      }
    }

### Remove the parameter calculation based on "$::osfamily" from your main class

    $ vim ~/puppet/modules/apache/manifests/init.pp
    class apache (
      ...
    ) {
      #case $::osfamily {
      #  ...
      #}
      ...
    }

### Inherit your params class and use its values as default

    $ vim ~/puppet/modules/apache/manifests/init.pp
    class apache (
      Enum['running','stopped'] $ensure = 'running',
      Boolean			$enable = true,
      Boolean                   $ssl    = $apache::params::ssl,
    ) inherits apache::params {
      ...
    }

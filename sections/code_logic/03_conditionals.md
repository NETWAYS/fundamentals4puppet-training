!SLIDE smbullets small
# Conditionals

* Puppet supports four types of conditionals
 * selectors
 * `case` statements
 * `if` statements
 * `unless` statements
* Can be used to
 * return values
 * alter logic

~~~SECTION:handouts~~~

****

Puppet supports four types of conditionals.

**Selectors** can be used to return values and **case**, **if** or **unless** statements to alter the
logic flow of your manifest.

~~~ENDSECTION~~~

!SLIDE smbullets small
# Selectors

* Good for assigning conditional values to variables

   <pre>
   $apache_package = $::osfamily ? {
     'RedHat' => 'httpd',
     default  => 'apache2',
   }<br>
   package { 'apache':
     ensure => installed,
     name   => $apache_package,
   }
   </pre>

~~~SECTION:handouts~~~

****

Selectors are good for assigning conditional values to variables like the example above.

You can use it also in other constructs most time at the expense of readability. One of such cases is
the use as resource attribute.

    package { 'apache':
      ensure => installed,
      name   => $::osfamily ? {
        'RedHat' => 'httpd',
        default  => 'apache2',
      }
    }

The syntax is the conditional expression followed by the question mark and curly brackets containing
any number of matches. The matches consists of a case, the arrow and a value. It should always include
a default match if you do not explicitly want Puppet to fail in the case no match is found.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Case statement

* Ideal for:
 * setting multiple variables at once
 * choosing different branches of code

   <pre>
   case $::osfamily {
     'RedHat': {
       $apache_package = 'httpd'
       $apache_confdir = '/etc/httpd'
     }
     default: {
       $apache_package = 'apache2'
       $apache_confdir = '/etc/apache2'
     }
   }
   </pre>

~~~SECTION:handouts~~~

****

The ideal use of case statements is to set multiple variables at once or to choose different branches
of code. In most cases it is more readable then multiple selectors and a complex if or unless statement.

The general form of a case statement starts with the keyword case followed by the control expression and
curly brackets containing matches. The match consists of a case or comma separated list of cases followed
by a colon and some puppet code in curly brackets. The match on strings is case insensitive, so use regular
expressions for case sensitive matches like */^(Debian|Ubuntu)$/*. Furthermore it is best practice to provide
a valid default if possible, if not use the function `fail` to fail catalog compilation or include an empty
default for clarity’s sake.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Case Statement

* Objective:
 * Add Debian support to your apache manifest by using a case statement
* Steps:
 * Move your package, config file and service name to variables
 * Add the variables as value for the namevar of your resources
 * Add a case statement setting the variables depending on the "osfamily"


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Case Statement

## Objective:

****

* Add Debian support to your apache manifest by using a case statement

## Steps:

****

* Move your package, config file and service name to variables
* Add the variables as value for the namevar of your resources
* Add a case statement setting the variables depending on the "osfamily"

#### Expected Result:

Your manifest still works as before and is capable of handling Debian


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Case Statement

****

## Add Debian support to your apache manifest by using a case statement

****

### Move your package, config file and service name to variables

    $ vim ~/puppet/manifests/apache.pp
    class apache {
      $packagename = 'httpd'
      $configdir   = '/etc/httpd'
      $localconfig  = "${configdir}/conf.d/local.conf"
      $servicename = 'httpd'
      ...
    }

### Add the variables as value for the namevar of your resources

    $ vim ~/puppet/manifests/apache.pp
    package { 'httpd':
      ...
      name => $packagename,
    }

    file { 'httpd local.conf':
      ...
      path => $localconfig,
    }

    service { 'httpd':
      ...
      name => $servicename,
    }

### Add a case statement setting the variables depending on the "osfamily"

    $ vim ~/puppet/manifests/apache.pp
    class apache {
      case $::osfamily {
        'RedHat': {
          $packagename = 'httpd'
          $configdir   = '/etc/httpd'
          $servicename = 'httpd'
        }
        'Debian': {
          $packagename = 'apache2'
          $configdir   = '/etc/apache2'
          $servicename = 'apache2'
        }
        default: {
          fail('Your platform is not supported')
        }
      }

      $confd  = "${configdir}/conf.d"
      $localconfig  = "${confd}/local.conf"
      ...
    }


!SLIDE smbullets small
# If statement

* Used to make a choice based on a truth value
* Can use:
 * boolean value
 * conditional expressions
 * regular expressions
 * chain of expressions

   <pre>
   if $ensure == 'present' or $ensure == 'installed' {
     package { 'telnet':
       ensure => present,
     }
   } elsif $ensure =~ /^(absent|purged)$/ {
     package { 'telnet':
       ensure => purged,
     }
   } else {
     fail("${ensure} is not valid")
   }
   </pre>

~~~SECTION:handouts~~~

****

The if statement allows to make a choice in your code based on a truth value.
This can be a simple boolean value (only `undef` and `false` evaluate as false),
a conditional expression or regular expression (doing a comparison) or a chain
of expressions (connected by `and` or `or` or negating an expression with `not`.

It can use additional expressions in an `elsif` and an `else` for false expressions.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Unless statement

* Reversed if statement
* No elsif clause possible

   <pre>
   unless $ensure =~ /\^\(absent|purged\)$/ {
     package { 'telnet':
       ensure => present,
     }
   } else {
     package { 'telnet':
       ensure => purged,
     }
   }
   </pre>

~~~SECTION:handouts~~~

****

The unless statement is like a reversed if statement, but does not allow elsif clauses.
The style guide does not mention unless statements but typically a if statement is much more
readable.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: If Statement

* Objective:
 * Allow to purge the Apache webserver
* Steps:
 * Create a if statement based on a variable "$ensure" to set the state of your resources
 * Use this variables in your resource declarations
 * Adjust the dependency chain based on "$ensure" to bring also purging in correct order


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: If Statement

## Objective:

****

* Allow to purge the Apache webserver

## Steps:

****

* Create a if statement based on a variable "$ensure" to set the state of your resources
* Use this variables in your resource declarations
* Adjust the dependency chain based on "$ensure" to bring also purging in correct order


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: If Statement

****

## Allow to purge the Apache webserver

****

### Create a if statement based on a variable "$ensure" to set the state of your resources

Add a variable "$ensure" to the top of your manifest and then set values corresponding
to the resource types. Explicitly requiring absent ensures the default is the more common
use case.

    $ vim ~/puppet/manifests/apache.pp
    class apache {
      $ensure = 'present'

      if $ensure == 'absent' {
        $ensure_package = 'purged'
        $ensure_file    = 'absent'
        $ensure_service = 'stopped'
        $enable_service = false
      } else {
        $ensure_package = 'present'
        $ensure_file    = 'file'
        $ensure_service = 'running'
        $enable_service = true
      }
      ...
    }

### Use this variables in your resource declarations

    $ vim ~/puppet/manifests/apache.pp
    package { 'httpd':
      ensure => $ensure_package,
      ...
    }

    file { 'httpd local.conf':
      ensure => $ensure_file,
      ...
    }

    service { 'httpd':
      ensure => $ensure_service,
      enable => $enable_service,
      ...
    }

### Adjust the dependency chain based on "ensure" to bring also purging in correct order

Adjusting the dependency chain based on the value of "ensure" is required that purge it completely
works fine. This is a very good example for the usage of the arrow syntax for declaring dependencies,
but not a typical example for common use in modules. In most public modules only small parts like
features will also have a deactivation routine.

    $ vim ~/puppet/manifests/apache.pp
    file { 'httpd local.conf':
      ...
      #require => Package['httpd'],
    }

    if $ensure == "absent" {
      Service['httpd'] -> File['httpd local.conf'] -> Package['httpd']
    } else {
      Package['httpd'] -> File['httpd local.conf'] ~> Service['httpd']
    }

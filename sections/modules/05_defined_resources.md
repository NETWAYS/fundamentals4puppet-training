!SLIDE smbullets small
# Defined Resources

* Very similar to parameterized classes
* But can be used multiple times

<pre>
define apache::vhost (
    $docroot,
    $port       = '80',
    $priority   = '10',
    $options    = 'Indexes MultiViews',
    $vhost_name = $title,
    $servername = $title,
 ) {
  file { "/etc/httpd/conf.d/${title}.conf":
    ensure  => file,
    owner   => 'apache',
    group   => 'apache',
    mode    => '0644',
    content => template('apache/vhost.conf.erb'),
    notify  => Service['httpd'],
  }
}
</pre>

~~~SECTION:handouts~~~

****

Defined Resources are very similar to parameterized classes but it is used
to define your own resource which can be declared multiple times. This helps
to save time and lines of code, abstract complexity and reduce errors and
inconsistency.

~~~PAGEBREAK~~~

It is very important two keep in mind that all resources declared in defined
resources still have to be unique. For this Puppet provides an internal
variable $title providing the title of a resource which should be used on every
resource title declared inside the defined resource.

Also for autoloading defined resources are placed in the same way like classes.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Declaring Defined Resources

* Declared like every other resource
* Using hash to declare multiple defined resources
 * create_resources function
 <pre>
 create_resources(type, $resources_hash, $defaults_hash)
 </pre>
 * iteration
 <pre>
 each($resources_hash) |$name, $resource| { 
 &nbsp;&nbsp;type{
 &nbsp;&nbsp;&nbsp;&nbsp;default:
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#42;&nbsp;=&gt;&nbsp;$defaults;&nbsp;
 &nbsp;
 &nbsp;&nbsp;&nbsp;&nbsp;$name:
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&#42;&nbsp;=&gt;&nbsp;$resource
 &nbsp;&nbsp;}
 }
 </pre>

~~~SECTION:handouts~~~

****

~~~PAGEBREAK~~~

You can simply declare a defined resource using the same syntax like for all other
resources. One common use case is providing a hash of resources and perhaps an additional
hash with defaults. In Puppet 3 you only could do this with the create_resources function,
this was a nice feature when released but because it works a bit too magical internally
some people tried to avoid it. Iteration in Puppet 4 now provides a native way to do the
same combined with the alternative default syntax if setting defaults is required.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Defined Resources

* Objective:
 * Create a defined resource apache::vhost from your manifest
* Steps:
 * Create a defined resource apache::vhost
 * Change the path of the templates from absolute to relative
 * Add a smoke test to apply multiple vhosts
* Optional:
 * Expand your defined resource to notify the service


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Defined Resources

## Objective:

****

* Create a defined resource apache::vhost from your manifest

## Steps:

****

* Create a defined resource apache::vhost
* Change the path of the templates from absolute to relative
* Add a smoke test to apply multiple vhosts

#### Optional:

Expand your defined resource to notify the service.

#### Expected Result:

Vhost configuration will be created.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Defined Resources

****

## Create a defined resource apache::vhost from your manifest

****

### Create a defined resource apache::vhost

Create a defined resource apache::vhost based on your manifest. Use the
title for the shortname of your vhost.

    $ vim ~/puppet/modules/apache/manifests/vhost.pp
    define apache::vhost (
      String $ip,
      String $shortname    = $title,
      String $fullname     = "${shortname}.localdomain",
      String $confdir      = '/etc/httpd',
      String $documentroot = "/var/www/${fullname}",
    ) {
      ...
    }

The ip address will be mandatory with this definition, all other have default
values and are optional because of this.

### Change the path of the templates from absolute to relative

Copy the template files to the templates directory and change the path so the templates
are found through autoloading.

    $ cp -r ~/puppet/templates/ ~/puppet/modules/apache/
    $ vim ~/puppet/modules/apache/manifests/vhost.pp
    ...
    #content => template('/home/training/puppet/templates/vhost.conf.erb'),
    content => template('apache/vhost.conf.erb'),
    ...
    #content  => epp('/home/training/puppet/templates/index.html.epp', { 'from' => "${fullname}" }),
    content  => epp('apache/index.html.epp', { 'from' => "${fullname}" }),
    ...

### Add a smoke test to apply multiple vhosts

For testing defined resources always create a test declaring multiple
resources with different parameters to ensure included resources are
unique.

This example uses an iteration, but simply declaring multiple resources or
using create_resources would be fine.

     $ vim ~/puppet/modules/apache/examples/vhost.pp
     $vhosts = {
       'vhost' => { ip => '127.0.0.1'},
       'foo'   => { ip => '127.0.0.2'},
       'bar'   => { ip => '127.0.0.3', fullname => 'bar.example.com' },
       'baz'   => { ip => '127.0.0.4', documentroot => '/var/www/bazinga'},
     }
     
     $vhosts.each | String $name, Hash $vhost | {
       apache::vhost { $name :
         * => $vhost,
       }
     }

### Optional: Expand your defined resource to notify the service.

Add a notify to your defined resource vhost to restart the service on changes to the vhost configuration.
This requires the smoke test to also include the main class.

    $ vim ~/puppet/modules/apache/manifests/vhost.pp
    file { "${confdir}/conf.d/$shortname.conf":
      ...
      notify => Service['httpd'],
    }

    $ vim ~/puppet/modules/apache/examples/vhost.pp
    include apache
    ...

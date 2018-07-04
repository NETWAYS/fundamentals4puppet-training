!SLIDE smbullets small
# Iteration

* Puppet 4 introduced some iteration functions
 * **each** - repeat a code block for each object
 * **slice** - repeat a code block a given number of times
 * **filter** - remove non-matching elements
 * **map** - transform values to some data structure
 * **reduce** - combine values to a new data structure
 * **with** - create a private code block (no real iteration)

<pre>
$binaries = ['facter', 'hiera', 'mco', 'puppet', 'puppetserver']

$binaries.each |String $binary| {
  file {"/usr/bin/${binary}":
    ensure => link,
    target => "/opt/puppetlabs/bin/${binary}",
  }
}
</pre>

~~~SECTION:handouts~~~

****

Puppet 4 introduced some iteration functions. Unlike most programming languages where an iteration is
a special keyword for a looping construct, Puppet has implemented it as functions that accept a block
of code.

The example above shows the `each` function taking every element of the "binaries" array as String and
creating a symlink for them.

~~~PAGEBREAK~~~

Other examples you can find on the iteration page in the docs: https://docs.puppet.com/puppet/latest/reference/lang_iteration.html

or on the function reference for a specific function: https://docs.puppet.com/puppet/latest/reference/function.html

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Iteration

* Objective:
 * Add multiple vhosts with an iteration
* Steps:
 * Add a hash containing shortnames and ip addresses to the top of your manifest
 * Add an each loop around your resources


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Iteration

## Objective:

****

* Add multiple vhosts with an iteration

## Steps:

****

* Add a hash containing shortnames and ip addresses to the top of your manifest
* Add an each loop based on this hash around your resources

#### Expected Result:

Vhost configuration will be created.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Iteration

****

## Add multiple vhosts with an iteration

****

### Add a hash containing shortnames and ip addresses to the top of your manifest

Add at least another vhost to this hash, simply use local ip addresses for this example.

    $ vim ~/puppet/manifests/vhost.pp
    $vhosts = {
      'vhost' => '127.0.0.1',
      'foo'   => '127.0.0.2',
      'bar'   => '127.0.0.3',
    }

### Add an each loop based on this hash around your resources

Iterate over the vhost hash with the each function to create your resources. Make sure
to not include your resource defaults in this loop.

    $ vim ~/puppet/manifests/vhost.pp
    #$shortname = 'vhost'
    #$fullname = "${shortname}.localdomain"
    #$ip = '127.0.0.1'

    #$confdir = '/etc/httpd'
    #$documentroot = "/var/www/${fullname}"

    $vhosts.each | $shortname, $ip | {
      $fullname = "${shortname}.localdomain"
      $confdir = '/etc/httpd'
      $documentroot = "/var/www/${fullname}"
    ...
    }

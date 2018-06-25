!SLIDE smbullets small
# Puppet Explorer

* Explore data from PuppetDB
 * Facts
 * Resources from Catalog
 * Reports
* Enables:
 * Filtering
 * Drilldown
* Uses:
 * AngularJS and CoffeeScript
 * PuppetDB and Webserver

~~~SECTION:handouts~~~

****

The Puppet Explorer is a web application for PuppetDB that lets you explore your Puppet data.
It uses the same query language like puppetdbquery which could be used in also as function in
your modules for filtering and its charts allow to do a drilldown simply by clicking.

~~~ENDSECTION~~~

!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Puppet Explorer

* Objective:
 * Install Puppet Explorer using the Puppet module
* Steps:
 * Install the Puppet Explorer module
 * Assign it to your master
 * Run the puppet agent to install it


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Puppet Explorer

## Objective:

****

* Install Puppet Explorer using the Puppet module

## Steps:

****

* Install the Puppet Explorer and Apache module

The agent on the master runs in a separate environment "master"

* Assign it to your master

It requires the address of your PuppetDB and also some Rewrite rules for PuppetDB 4.x compatibility

* Run the puppet agent to install it

#### Expected Result:

You can access the webinterface, pointing your browser to https://192.168.56.101.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Puppet Explorer

****

## Install Puppet Explorer using the Puppet module

****

### Install the Puppet Explorer module

On the puppet master use the puppet module tool to install "spotify-puppetexplorer" and "puppetlabs-apache" into environment "master".
The apache module is only an optional dependency so not automatically installed.

    $ sudo puppet module install spotify-puppetexplorer -i /etc/puppetlabs/code/modules
    $ sudo puppet module install puppetlabs-apache -i /etc/puppetlabs/code/modules

### Assign it to your master

Puppet Explorer simply proxies the query issued to the PuppetDB using Apache. PuppetDB 4.x also introduced a breaking change by moving some query location,
compatibilty for this change can be restored by a rewrite rule (https://github.com/spotify/puppetexplorer/issues/49).

    $ sudo vim /etc/puppetlabs/code/environments/master/manifests/site.pp
    node 'puppet.localdomain' {
      ...
      class { 'puppetexplorer':
        proxy_pass => [
          { 'path' => '/api/pdb/query', 'url' => 'http://192.168.56.101:8080/pdb/query' },
          { 'path' => '/api/pdb/meta', 'url' => 'http://192.168.56.101:8080/pdb/meta' },
          { 'path' => '/api/metrics', 'url' => 'http://192.168.56.101:8080/metrics' }
        ],
        vhost_options => {
          rewrites  => [ { rewrite_rule => ['^/api/metrics/v1/mbeans/puppetlabs.puppetdb.query.population:type=default,name=(.*)$  https://%{HTTP_HOST}/api/metrics/v1/mbeans/puppetlabs.puppetdb.population:name=$1 [R=301,L]'] } ], 
        },
      }
    }

Instead of typing all the configuration use the documentation of the module and the provided issue to copy most of it.

### Run the puppet agent to install it

    $ sudo puppet agent -t


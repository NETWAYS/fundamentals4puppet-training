!SLIDE smbullets small
# Resource Defaults

* Puppet allows you to declare resource defaults

<pre>
Type {
  attribute => 'value',
}
</pre>

<pre>
File {
  owner => 'root',
  group => 'root',
  mode  => '0644',
}
</pre>

* For directories Puppet promotes a mode default of "0644" to "0755"

~~~SECTION:handouts~~~

****

Puppet allows you to declare resource defaults to shorten the code and make it more readable.
A resource default is declared like a resource only the resource type is uppercase and there
is no title given.

The example sets default for owner, group and mode of every file resource in the scope it is
declared. Because of being scope wide a resource default should only be declared on the highest
or lowest scope. More on scope when we take about variables.

There is one special case for the file resource. If the type is set to directory Puppet will
automatically promotes a mode default of "0644" to "0755".

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Resource Defaults

* Objective:
 * Add a vhost definition to your webserver
* Steps:
 * Set the resource defaults for file resources to provide owner, group and mode
 * Add a host entry for your vhost on your server
 * Add a configuration file for your vhost
 * Create the document root and an index file
 * Apply the manifest and restart the service
* Optional:
 * Add an additional vhost for your default servername

~~~SECTION:handouts~~~

****

The optional task is necessary because if one vhost exists in Apache's configuration everything has to managed
as vhost, the default configuration will not be used any longer.

~~~ENDSECTION~~~


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Resource Defaults

## Objective:

****

* You will add a vhost definition to your webserver in this lab

## Steps:

****

* Set the resource defaults for file resources to provide owner "root", group "root" and mode "0644"
* Add a host entry "vhost.localdomain" for your vhost on your server
* Add a configuration file for your vhost creating a name based vhost
* Create the document root "/var/www/vhost.localdomain" and an index file saying "Hello World"
* Apply the manifest and restart the service

#### Optional:

Add an additional vhost for your default servername to provide different content based on the servername

#### Expected result:

Pointing your browser to http://vhost.localdomain shows "Hello World".


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Resource Defaults

****

## Add a vhost definition to your webserver

****

### Set the resource defaults for file resources to provide owner "root", group "root" and mode "0644"

    $ vim ~/puppet/manifests/vhost.pp
    File {
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }

### Add a host entry "vhost.localdomain" for your vhost on your server

    $ vim ~/puppet/manifests/vhost.pp
    host { 'vhost.localdomain':
      ensure       => present,
      ip           => '127.0.0.1',
      host_aliases => ['vhost'],
    }

### Add a configuration file for your vhost creating a name based vhost

    $ vim ~/puppet/manifests/vhost.pp
    file { '/etc/httpd/conf.d/vhost.conf':
      ensure => file,
      source => '/home/training/puppet/files/vhost.conf',
    }
    $ vim ~/puppet/files/vhost.conf
    <VirtualHost *:80>
        DocumentRoot "/var/www/vhost.localdomain"
        ServerName vhost.localdomain
    </VirtualHost>

### Create the document root "/var/www/vhost.localdomain" and an index file saying "Hello World"

    $ vim ~/puppet/manifests/vhost.pp
    file { '/var/www/vhost.localdomain/':
      ensure => directory,
    }

    file { '/var/www/vhost.localdomain/index.html':
      ensure => file,
      content => '<h1>Hello World</h1>',
    }

### Apply the manifest and restart the service

    $ sudo puppet apply ~/puppet/manifests/vhost.pp
    $ sudo service httpd reload

~~~PAGEBREAK~~~

### Optional: Add an additional vhost for your default servername to provide different content based on the servername

    $ vim ~/puppet/manifests/apache.pp
    file { '/etc/httpd/conf.d/default.conf':
      ensure => file,
      source => '/home/training/puppet/files/default.conf',
      notify => Service['httpd'],
    }

    $ vim ~/puppet/files/default.conf
    <VirtualHost *:80>
        DocumentRoot "/var/www"
        ServerName agent-centos.localdomain
    </VirtualHost>

    $ sudo puppet apply ~/puppet/manifests/apache.pp


!SLIDE smbullets small
# Block based Resource Defaults

* Puppet 4 introduced an alternative block based version

<pre>
file {
  default:
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
    ensure => file,
  ;
  '/etc/ssh_host_key':
  ;
  '/etc/ssh_host_dsa_key.pub':
    mode => '0644',
  ;
}
</pre>

~~~SECTION:handouts~~~

****

Puppet 4 introduced an alternative block based version allowing to set defaults
in a fine granular manor.

~~~ENDSECTION~~~

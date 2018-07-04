!SLIDE smbullets small
# Repository - RHEL / Centos / Fedora

* Puppet 5
 * All-in-one package for ease of usage - provided by Puppet
* Puppet 4
 * Puppet Collection - all-in-one package for ease of usage - provided by Puppet
 * Default Repository - packages according packaging guidelines - Fedora only
* Puppet 3
 * Puppetlabs Repository - latest packages - provided by Puppet
 * EPEL Repository - more stable version - provided by Fedora
 * Separate RHEL Channel - for use with Satellite 6 - provided by Red Hat
* Puppet Enterprise similar to Puppet Collection


!SLIDE smbullets small
# Repository - Debian / Ubuntu

* Puppet 5
 * All-in-one package for ease of usage - provided by Puppet
* Puppet 4
 * Puppet Collection - all-in-one package for ease of usage - provided by Puppet
* Puppet 3
 * Puppetlabs Repository - latest packages - provided by Puppet
 * Default Repository - more stable version - provided by distribution
* Puppet Enterprise similar to Puppet Collection

~~~SECTION:handouts~~~

****

As you can see there are many different ways to get Puppet installed on your system.

With Version 5 Puppet dropped the naming and numbering schema of Puppet Collection, but keep the all-in-one packaging to
provide tested and complementary versions of all the tools required for running Puppet in one entire package provided by
the vendor. But this also includes an additional version of openssl for example which has to be considered individually
from the one included in your operating system when dealing with the system security in mind.

The same goes for Puppet Collection for Puppet 4 and Puppet Enterprise which is very similar but requires a subscription
and in exchange provides support the vendor.

~~~PAGEBREAK~~~

Puppet 4 is only included in the default repository by Fedora for now, all other distributions still include Puppet 3.

If the version of Puppet 3 included in your preferred distribution is older than the one you are required to run you
can also switch to the repository provided by Puppet for Puppet 3 which will included the latest version. These packages
are not all-in-one packages instead they depend on the operating system libraries and tools.

In this training we will use the Puppet Collection because we want to demonstrate the new features. This is no recommendation
for the all-in-one packaging format! For your environment decide on your own which package maintainer to trust and which version
is required for your tool stack and which best suits your needs.

~~~ENDSECTION~~~

!SLIDE smbullets small
# Puppet Enterprise

* Packaging for additional platforms including additional components
* Puppet Enterprise Console as Webinterface
* Additional Components
 * Puppet Node Manager - group nodes on facts
 * Puppet Code Manager - combines r10k, Jenkins and beaker for testing and deploying code
 * Puppet Configuration Manager - helps troubleshoot dependencies
 * Task Management - combines bolt with Puppet Enterprise Console and Orchestration API
* Supported Modules
* Automated Provisioning for some platforms
* Vendor support and service

~~~SECTION:handouts~~~

****

Puppet itself is completly Open Source, but the Enterprise version adds to this Open Source tool.

Open Source Packages are widely available, but some platforms have a limited community so getting packages for example
on AIX is difficult where Puppet Enterprise provides their complete toolstack for all platforms they support in the same
fashion. Also Puppet Enterprise Console adds an Webinterface for assigning configuration and view reports, but there are
alternate frontend like Puppet Explorer or Foreman. 

~~~PAGEBREAK~~~

For the additional components not always is an alternative available but some
can be build from the same components used in Puppet Enterprise and none of it is required. Puppet Support also includes
support for specific modules but is also limited to those and does not cover your own code. Also they cooporate with other
vendors to create solutions for automated provisioning on their platform, but Foreman is more powerfull and supports more
platforms. So vendor support is only available for the Enterprise version, while Open Source support is available from
different sources covering sometimes more or at least other components.

At the end it is your choice if you want to use Puppet Enterprise and can take some benefit of the commercial version or
if you use the Open Source version and add components you require and perhaps buy a support contract from a third party.

~~~ENDSECTION~~~

!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Installation

* Objective:
 * Install package `puppet-agent` in the same version as the master runs.
* Steps:
 * Make Puppet Collection available.
 * Inspect what version is installed on your master.
 * Install puppet-agent in the inspected version.
 * Extend the secure path variable to include the puppet command.


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Installation

## Objective:

****

* In this lab you install the Puppet agent provided by Puppet

## Steps:

****

* Make Puppet Collection available by installing the release repository

URL: http://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm

* Inspect what version is installed on your master

* Install puppet-agent using yum
* Extend the secure path variable to include the puppet command

Path: /opt/puppetlabs/bin/

#### Expected result:

You can successfully execute "puppet --version" and "facter --version".


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Installation

****

## Install the Puppet agent provided by Puppet

****

### Make Puppet Collection available by installing the release repository

    $ sudo yum install http://yum.puppet.com/puppet5/puppet5-release-el-7.noarch.rpm -y

### Inspect what version is installed on your master

    $ sudo rpm -aq |grep puppet-agent
    puppet-agent-x.y.z-n.el7.x86_64

### Install puppet-agent using yum

    $ sudo yum install puppet-agent-x.y.z-n.el7.x86_64 -y

### Extend the secure path variable to include the puppet command

    $ sudo visudo
    Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/opt/puppetlabs/bin

    $ exec bash

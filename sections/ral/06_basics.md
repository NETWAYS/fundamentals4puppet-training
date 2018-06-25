!SLIDE smbullets small
# Resource Abstraction Layer

* Puppet uses a Resource Abstraction Layer
 * Groups similar resources into resource types
 * Resource types have multiple providers
* Resources can be declared always in the same fashion
* A resource will be managed by the best matching provider on the platform


!SLIDE smbullets small noprint
# Resource Abstraction Layer

<center><img src="./_images/resource_abstraction_layer.png" style="width:702px;height:460px;" alt="Resource Abstraction Layer"></center>


!SLIDE smbullets small printonly
# Resource Abstraction Layer

<center><img src="./_images/resource_abstraction_layer.png" style="width:480px;height:315px;" alt="Resource Abstraction Layer"></center>

~~~SECTION:handouts~~~

****

The Resource Abstraction Layer allows Puppet to handle completely different resources in a similar fashion.
Similar resources are grouped into resource types which than have different providers to realize them.

So the type is the interface that is used to describe how a resource is configured. For example which
mode a file should have.

~~~PAGEBREAK~~~

The provider is the implementation layer which translates the specified resource into actual implementation.
They are typically operating system and tool specific. In addition to adjust the configuration they also
report back the current state so changes can only be done if required. Which provider to use is automatically
determinated by Puppet or could explicitly be set by the user to use the best matching one.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Providers

* Availability of a provider is determinated by testing for availability of required binaries
* Can be marked as default for specific facts (typically operatingsystem)
* Can support all or only a subset of features a resource type requires
* Example for resource **package**
 * Providers:
    <pre>
    aix appdmg apple apt aptitude aptrpm blastwave dnf dpkg fink freebsd
    gem hpux macports nim openbsd opkg pacman pip3 pip pkg pkgdmg pkgin
    pkgng pkgutil portage ports portupgrade puppet_gem rpm rug sun
    sunfreeware up2date urpmi windows yum zypper
    </pre>
 * Features:
    <pre>
    holdable install_options installable package_settings purgeable reinstallable
    uninstall_options uninstallable upgradeable versionable virtual_packages
    </pre>

~~~SECTION:handouts~~~

****

~~~PAGEBREAK~~~

Puppet decides which provider is available by testing for required binaries. Afterwards it will lookup if
the providers support all the features required for the desired configuration. If still multiple providers
fit it will use the one marked as default for a specific set of facts which is typically the operatingsystem
or osfamily, sometimes in relation to the release version.

So for example to manage a package resource on CentOS it will find _rpm_ and _yum_ and perhaps some like _gem_
for ruby or _pip_ for python. If now a operating system package should be installed _rpm_ and _yum_ can solve
this task, but _yum_ will be used because it is default for _osfamily redhat_. If a package should be purged
only _yum_ would match because _rpm_ does not provide this feature.

For more details have a look at the resource type reference in the documentation: 
https://docs.puppet.com/puppet/latest/reference/type.html 

~~~ENDSECTION~~~

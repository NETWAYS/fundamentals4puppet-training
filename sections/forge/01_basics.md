!SLIDE smbullets small
# Forge

http://forge.puppet.com

* Community platform for modules
 * Thousands of modules by many different authors
 * Searchable
 * Supported, Partner supported and Approved Modules
 * Number of Downloads and Scoring system
* Command Line Interface `puppet module`
 * Search
 * Install
 * List installed modules

~~~SECTION:notes~~~

* Supported Module: Support included with PE, tested and compatibility matrix available
* Partner Module: Support included with PE, tested and compatibility matrix available offered by a Partner
* Approved Module: Pass specific quality and usability requirements, recommended but not supported

~~~ENDSECTION~~~


~~~SECTION:handouts~~~

****

With the Puppet Forge provides the vendor a community platform for modules with a still growing number
of modules by many different authors, projects and companies. The website is searchable to easly find a
module managing a specific software or solving a common problem. For quality indicators look for modules
markes as supported which are included in support offered with Puppet Enterprise, tested and a compatibility
matrix is given, partner to indicate the same level of quality but support provided by a partner or approved
which pass specific quality and usability requirements and are recommended but not supported. Other indicators
are the number of downloads, the scoring system combining user scores and automatic tests and if provided the
number of open issues.

The Forge is also usable through a Command Line Interface which allows to search, install (including dependencies)
and also list all installed modules, but of course requires internet access.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Forge

* Objective:
 * Install the stdlib module provided by puppetlabs
* Steps:
 * Search the Forge
 * Install the module
 * List all installed modules


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Forge

## Objective:

****

* Install the stdlib module provided by puppetlabs

## Steps:

****

* Search the Forge

It will search title, description and tags.

* Install the module

Installation requires the fullname of the module consisting of author-modulename and by default
it will install into the module path of your agents enviroment. If there are dependencies not
already installed, the cli will also install them.

* List all installed modules

If not using the default modulepath, you have to provide it as it only list modules from one enviroment
or modulepath.

#### Expected Result:

The module is installed in your local module path.

!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Forge

****

## Install the stdlib module provided by puppetlabs

****

### Search the Forge

    $ puppet module search stdlib

### Install the module

    $ puppet module install --modulepath ~/puppet/modules/ puppetlabs-stdlib

### List all installed modules

    $ puppet module list --modulepath ~/puppet/modules/


!SLIDE smbullets small
# Working with the Forge

* Use as there are
 * Documentation
 * Parameterized
 * Push changes upstream
 * Wrap around them
* Use as inspiration
 * Keep it simple

~~~SECTION:handouts~~~

****

There are two ways to use the Forge for its best.

Easiest way is to use the modules as they are. Read the documentation and have a look at the code
to see if a module can solve your problem. Most modules are parameterized in a way to solve most
problems and support different platforms. If you require changes try to incorporate them without
breaking and push them upstream like adding another platform. If you can not or do not want to
bring changes upstream try to only wrap aroung the module with a custom module. Both ways you keep
the module upgradable so you do not have to maintain it on your own after installation.

Most forge modules support multiple platforms and many different scenarios, many are over-engineered
for one specific environment or in a style you do not like but can still be used as inspiration.
So in some cases creating your own simple module solving your problem in a way you can understand and
maintain is more usefull than simply taking a module from the forge and work around it.

~~~ENDSECTION~~~

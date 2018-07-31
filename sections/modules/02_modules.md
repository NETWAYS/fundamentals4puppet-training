!SLIDE smbullets small
# Modules

* Modules are a pre-defined structure for encapsulating related configuration
* This enables:
 * auto-loading of classes
 * file-serving for templates and files
 * auto-delivery of custom Puppet extensions
 * easy sharing with others

~~~SECTION:handouts~~~

****

Modules are a pre-defined structure for encapsulating related configuration which
enables the auto-loading of classes, file-serving for templates and files and
auto-delivery of custom Puppet extensions. Furthermore it allows for easy sharing
with others. for this going to work a modules should be self-contained and should
have well defined integration points for other modules to use. It should manage
everything required but --more important-- not manage things out of it scope.

For example a web application module should not also manage the database or the
webserver because a module doing so would only allow the use of this single web
application with one specific database and webserver.

Defining the scope of modules is one of the hardest things to do with Puppet but
with some experience it gets easier.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Structure of Modules

<pre>
modulename
|-- facts.d        &lt;- external facts
|-- files          &lt;- static files
|-- lib
|   |-- facter     &lt;- facts written in Ruby
|   `-- puppet     &lt;- custom functions, types and providers
|-- manifests      &lt;- Puppet classes
|-- metadata.json  &lt;- Module description
|-- spec           &lt;- unit tests
|-- templates      &lt;- dynamic files in erb or epp syntax
`-- examples       &lt;- smoke tests
</pre>

~~~SECTION:handouts~~~

****

The example above shows the structure of a module. The outermost directory is named like
the module itself and contains a directory for every type of files. If a module does not
provide a specific type of files it does not require the corresponding directory. The file
'metadata.json' is optional and contains the description of the module in a machine readable
format. Some of the descriptions are used by tools, like the dependencies used by the `puppet
module` command.


In this training we will not cover custom functions and facts and we will only cover smoke
tests, no unit tests. Writing such things is covered in "Advanced Puppet".

~~~ENDSECTION~~~


!SLIDE smbullets small
# Autoloading

Classes in `manifests`

* Default class named like the module found in `init.pp`
* Classes in files matching there names
 * `module::example` in `example.pp`
 * `module::example::complex` in `example/complex.pp`

Files in `files`

* Served by Puppet fileserver as 'puppet:///modules/*modulename*/*filename*'

Templates in `templates`

* Lookup by Puppet template functions like
 * Embedded Ruby: 'template(*modulename*/*filename.erb*)'
 * Embedded Puppet: 'epp(*modulename*/*filename.epp*)'


~~~PAGEBREAK~~~

~~~SECTION:handouts~~~

****

Autoloading of classes is based on the namespace of the classes. The namespace always
starts with the modulename and the module's default class has to be named as the module.
This default class is located in the modules's init.pp in the manifests directory. Other
classes of the module must be named like the file providing them.

    # grep ^class apache/manifests/init.pp
    class apache (
    # grep ^class apache/manifests/package.pp
    class apache::package (
    # grep ^class apache/manifests/mod/status.pp
    class apache::mod::status (

Autoloading also works for static files served by the Puppet Master. Puppet uses its own
URL schema you can use as source attribute for files 'puppet:///modules/*modulename*/*filename*'.

Furthermore template lookup can use relative pathes for templates provided by a module
like 'template(*modulename*/*filename.erb*)' or 'epp(*modulename*/*filename.epp*)'.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Module

* Objective:
 * Build a module to handle your apache class
* Steps:
 * Create the structure for your apache module
 * Move your manifest and all required files to this structure
 * Adjust the source of your file resource
 * Create a smoke test including your apache class


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Module

## Objective:

****

* Build a module to handle your apache class

## Steps:

****

* Create the structure for your apache module in ~/puppet/modules
* Move your manifest and all required files to this structure
* Adjust the source of your file resource
* Create a smoke test including your apache class

#### Expected Result:

Applying the smoke test manages all declared resources.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Module

****

## Build a module to handle your apache class

****

### Create the structure for your apache module in ~/puppet/modules

It requires a directory apache with subdirectories manifests, files, templates and examples.
Make sure to use the plural, the most common mistake is using the singular which will prevent
autoloading from working.

    $ mkdir -p ~/puppet/modules/apache/{manifests,files,templates,examples}

### Move your manifest and all required files to this structure

Move your class manifest to be your modules default class and your configuration file
to the location for static files.

    $ mv ~/puppet/manifests/apache.pp ~/puppet/modules/apache/manifests/init.pp
    $ mv ~/puppet/files/local.conf ~/puppet/modules/apache/files/

### Adjust the source of your file resource

Use the URL puppet:// to serve the configuration file. Note the URL starting with puppet:///
because of the omitted server. If no server is given the agent will load the file from the
server it contacted for requesting a catalog.

    $ vim ~/puppet/modules/apache/manifests/init.pp
    file {'httpd local.conf':
      ...
      source  => 'puppet:///modules/apache/local.conf',
    }

### Create a smoke test including your apache class

Simple create a manifest using the include function on your apache class named like the
manifest defining it in the modules examples directory.

    $ vim ~/puppet/modules/apache/examples/init.pp
    include apache

Now you can use apply on this file but you have to provide the modulepath.

    $ sudo puppet apply --debug --modulepath=~/puppet/modules/ ~/puppet/modules/apache/examples/init.pp
    Debug: /Stage[main]/Apache/Package[httpd]/before: requires File[httpd local.conf]
    Debug: /Stage[main]/Apache/File[httpd local.conf]/notify: subscribes to Service[httpd]

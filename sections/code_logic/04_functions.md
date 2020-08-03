!SLIDE smbullets small
# Functions

* Always executed on the Master during Catalog Compilation
* Two types:
 * **statement** - executes an action
 * **rvalue** - returns a value
* Basic functions included in Puppet, e.g.:
 * *fail* - statement to fail catalog compilation with the provided message
 * *template* - rvalue returning an erb template as string
 * *versioncmp* - rvalue returning a number indicating if a version is higher or lower
* Additional functions can be provided by modules

~~~SECTION:handouts~~~

****

Puppet allows to integrate functions into your manifests which will be executed on the Master during Catalog Compilation. 

Statements can execute an action like *fail* which will fail catalog compilation with the provided message which is
useful as default in case statements for better failing than providing wrong parameters for an unsupported case.

Rvalue functions return a value like the *template* function which takes an erb template and returns a string or
*versioncmp* which takes two version and returns "-1" if the first one is less, "0" if both are equal or "1" if
the first one is greater.

As with facts modules can include there own functions, for example the module puppetlabs/stdlib mainly exists to
provide additional functions.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Template Functions

* *template*
 * uses Embedded Ruby in templates
 * all variables in the scope are passed to the template
 * can handle multiple templates

`template('file.erb')`

* *epp*
 * uses Embedded Puppet in templates
 * a hash with parameter has to be passed to the template
 * only available since Puppet 4

`epp('file.epp', { 'parameter' => 'value' })`

* an inline version of both functions exists

~~~SECTION:handouts~~~

****

Puppet can not only handle static files, with the use of the *template* or *epp* function you can handle a file
containing dynamic content.

The *template* function exists in all versions of Puppet and uses Embedded Ruby (erb) for the dynamic parts.
Using the erb syntax you can access all variables available in the scope. The *template* function also can handle
multiple templates which will be concatenated.

The *epp* function is only available in Puppet 4 (or with the future parser in some older versions) and uses
Embedded Puppet (epp) instead of Embedded Ruby. Furthermore it does only use the parameters which are passed to it
which are required if no default value is set and Puppet will fail then.

Furthermore an inline version of both functions exists which uses a string in heredoc format instead of a template
file. But for readability you should avoid this at least for bigger templates.

~~~ENDSECTION~~~


!SLIDE smbullets small
# ERB Syntax

* Simple textfile including some Ruby code

   <pre>
   &lt;%# Comment not printed in file -%&gt;<br>
   &lt;% if @variable == true -%&gt;
   Print this &lt;%= @variable %&gt;
   &lt;% end -%&gt;<br>
   &lt;% @values.each do |value| -%&gt;
   Value is &lt;%= value %&gt;
   &lt;% end -%&gt;
   </pre>


~~~SECTION:handouts~~~

****

An erb template consists simply of text and Ruby code embedded with &lt;% and %&gt;. In these lines of code
you can access variables from Puppet (prefixed with @ or accessed with the scope function) or local variables
(a simple string). Furthermore you can add conditions and iterations like the if and each in the example above.
You can also call out to Puppet functions using the scope function. Also note the -%&gt; in some lines which
will result in a non printed line.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: ERB Template

* Objective:
 * Move your vhost configuration to an erb template
* Steps:
 * Create an erb template for your vhost
 * Change the resource to use the template instead of a static file


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: ERB Template

## Objective:

****

* Move your vhost configuration to an erb template

## Steps:

****

* Create an erb template for your vhost by copying your static file and replace the values with erb

For syntax checking on erb templates you can use `erb -P -x -T '-' template.erb | ruby -c`.

* Change the resource to use the template function for content instead of a static file as source

#### Expected Result:

Your manifest still works the same ways but can handle multiple vhost with just one template.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: ERB Template

****

## Move your vhost configuration to an erb template

****

### Create an erb template for your vhost by copying your static file and replace the values with erb

The file extension .erb is not required but it enables syntax checking on templates based on it.

    $ cp ~/puppet/files/vhost.conf ~/puppet/templates/vhost.conf.erb

    $ vim ~/puppet/templates/vhost.conf.erb
    <VirtualHost *:80>
      DocumentRoot "<%= @documentroot %>"
      ServerName <%= @fullname %>
    </VirtualHost>

### Change the resource to use the template function for content instead of a static file as source

Make sure to comment the source attribute because it is mutually exclusive with content.

    $ vim ~/puppet/manifests/vhost.pp
    file { "${confdir}/conf.d/${shortname}.conf":
      ensure  => file,
      #source => "/home/training/puppet/files/${shortname}.conf",
      content => template('/home/training/puppet/templates/vhost.conf.erb'),
    }


!SLIDE smbullets small
# EPP Syntax

* Simple textfile including some Ruby code

   <pre>
   &lt;%- | Boolean $variable = true,
         Array   $values
   | -%&gt;
   &lt;%# Comment not printed in file -%&gt;<br>
   &lt;% if $variable == true { -%&gt;
   Print this &lt;%= $variable %&gt;
   &lt;% } -%&gt;<br>
   &lt;% $values.each |value| { -%&gt;
   Value is &lt;%= value %&gt;
   &lt;% } -%&gt;
   </pre>

~~~SECTION:handouts~~~

****

An epp template consists simply of text and Puppet code embedded with &lt;% and %&gt;. On top
of the file you should define the parameters required. If none are defined every parameter is accepted.
If a default value is set, the parameter is optional and if not passed to the epp function will fall
back to the default. In epp you do not require a special syntax to use Puppet functions instead you can
use them in the same ways like in your manifests.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: EPP Template

* Objective:
 * Create your webserver content from an epp template
* Steps:
 * Create an epp template to represent your webserver content
 * Change the resource to use the template instead of fixed string


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: EPP Template

## Objective:

****

* Create your webserver content from an epp template

## Steps:

****

* Create an epp template to represent your webserver content

For syntax checking on epp templates you can use `cat template.epp | puppet epp validate`.

* Change the resource to use the template instead of fixed string

#### Expected Result:

Webserver serves your expected content.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: EPP Template

****

## Create your webserver content from an epp template

****

### Create an epp template to represent your webserver content

In this example both parameters get a default value for being optional. The greeting message must be a string
and falls back to "Hello World". The parameter from is per default undefined and can be this value or a string.

    $ vim ~/puppet/templates/index.html.epp
    <%- | String           $greeting = "Hello World",
          Optional[String] $from     = undef
    | -%>
    <h1><%= $greeting %> <% unless $from =~ Undef { -%> from <%= $from %><% } -%></h1>

### Change the resource to use the template instead of fixed string

This example defines only the from parameter and uses the default for the greeting message.

    $ vim ~/puppet/manifests/vhost.pp
    file { "${documentroot}/index.html":
      ensure   => file,
      #content => '<h1>Hello World</h1>',
      content  => epp('/home/training/puppet/templates/index.html.epp', {
        'from' => "${fullname}"
      }),
    }

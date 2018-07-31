!SLIDE smbullets small
# Node Declaration

* Nodes are another resource type
* Only objects not declared in modules
* Matching
 * Exact match
 * Regex
 * Fuzzy name matching
 * Default

   <pre>
   node 'www.example.com' {
     include apache
   }<br>
   node /\.example\.com$/ {
     include base
   }<br>
   node default {
     notice('Node not configured')
   }
   </pre>

~~~SECTION:handouts~~~

****

Nodes are just another resource to be declared. The title of the resource will be matched against
the nodes certificate name. For this it will use the exact name, if not found it will look for a
regular expression matching (avoid multiple matching regex because puppet will not guarantee which
is used), if not regex is found it will start choping domain parts from the fqdn and if also this
does not provide a match the default node will be used.

Typically you will not want to assign configuration to the default node and instead print a message
showing nodes not properly configured. If you want to configure multiple identic nodes you can provide
them also as comma separated list instead of regular expression. This configuration is done in the
main manifest which is by default the site.pp.

~~~ENDSECTION~~~


!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Node Declaration

* Objective:
 * Create a node declaration for your agent
* Steps:
 * Create a node declaration for your agent
 * Create a default node declaration printing a notice
 * Commit and push it to your server


!SLIDE supplemental exercises
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Node Declaration

## Objective:

****

* Create a node declaration for your agent

## Steps:

****

* Create a node declaration for your agent 'agent-centos.localdomain'
* Create a default node declaration printing a notice 'Node not configured'
* Commit and push it to your server

#### Expected Result:

Running the agent will configure it and not print the default notice.


!SLIDE supplemental solutions
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Node Declaration

****

## Create a node declaration for your agent

****

### Create a node declaration for your agent 'agent-centos.localdomain'

Add a node declaration to a manifest called site.pp for 'agent-centos.localdomain'
including apache.

    $ sudo vim ~/puppet/manifests/site.pp
    node 'agent-centos.localdomain' {
      include apache
    }

### Create a default node declaration printing a notice 'Node not configured'

Add a default node declaration printing a notice 'Node not configured' which will be
printed if you run the agent with verbose or debug output. If you want it also included
in a report use a notify resource instead which will also a changed resource on every
run.

    $ sudo vim ~/puppet/manifests/site.pp
    node default {
      notice('Node not configured')
    }

### Commit and push it to your server

Pushing the node declaration is required to use it.

    $ cd ~/puppet/
    $ git add manifests/site.pp
    $ git commit -m "adds default node declaration and agent-centos.localdomain"
    $ git push origin master


!SLIDE smbullets small
# ENC

* External Node Classifier is an alternative to site.pp
* Script providing a node declaration in yaml format
 * Simple script logic
 * Query configuration management database
 * Communication with a web frontend

~~~SECTION:handouts~~~

****

An alternative to the file based configuration would be an External Node Classifier.
This is not mutually exclusive instead both sources of configuration will be merged,
but normally you will only use one.

~~~PAGEBREAK~~~

The ENC is configured in the master section of the configuration file and can be any
script providing a node declaration in yaml format. Using simple script logic to
generate yaml output based on the certificate name provided, querying a configuration
management database or similar sources or using it as communication interface with
a web frontend like Puppet Enterprise Console or Foreman are all valid options.

For more on ENC see https://docs.puppet.com/guides/external_nodes.html.

~~~ENDSECTION~~~

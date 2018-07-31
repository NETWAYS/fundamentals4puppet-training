!SLIDE smbullets small
# Lab ~~~SECTION:MAJOR~~~.~~~SECTION:MINOR~~~: Puppet tasks

* Objective:
 * Learn Orchestration with bolt and Puppet tasks
* Steps:
 * Install bolt
 * Configure bolt and create an inventory
 * Install a module containing tasks like puppetlabs-service
 * Run the included tasks

~~~SECTION:handouts~~~

****

__Bolt is still in development and not released as a stable version!__

You can install bolt from packages provided in the Puppet repository.
Configuration is done in `~/.puppetlabs/bolt.yml` and can look like:

    modulepath: "/etc/puppetlabs/code/environments/production/modules"
    inventoryfile: "~/.puppetlabs/inventory.yml"
    concurrency: 10
    format: human
    ssh:
      host-key-check: false
    
The inventory can be created manually or by using `bolt-inventory-pdb`.
An example for our training environment can look like:

    groups:
      - name: agents
        nodes: 
          - agent-centos.localdomain
          - agent-debian.localdomain
        config:
          transport: ssh

Modules containing tasks can be installed from the forge. One simple
example is puppetlabs-service which can use puppet or linux and windows
mechanism to start, stop or restart tasks.

A task is then executed by running the bolt command.

    bolt task run service action=restart name=sshd --nodes agents

~~~ENDSECTION~~~

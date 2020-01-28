---
title: "How To"
date: 2019-08-13T16:35:22+02:00
type: docs
---

How To
======

Here we provide some guides for various aspects of using the Robotarium cluster.
The most important ones are listed directly below --- it is a good idea to
familiarise yourselves with these first. Please be aware that some of the guides
here are hosted on other sites and will need you to navigate away from here.

_Note: this page is still being populated, if you feel that anything is missing
or amiss please contact us and we'll update this page appropriately._

Basics
------

### Accessing the Cluster

The cluster can only be accessed from within the Heriot-Watt University network.
Users wishing to use it from outside the university will need to setup an SSH
tunnel (see [SSH Forwarding](#ssh-forwarding)) or use the HW-VPN (please contact us to give you
access. HW staff have VPN access per default (see the HW-VPN details).

> **Notice**
> There is a [user portal website](//robotarium.hw.ac.uk/userportal) available
> for users to check the current load of the cluster, you'll need to login using
> your cluster account to access this. For the moment, the site is using a
> self-signed SSL certificate, as such you will likely need to set your browser
> to accept the certificate before you can access the site.

#### SSH Forwarding

> **Notice**
> This is only available for users with MACS (School of Mathematics and Computer
> Science) accounts. Otherwise you can try out the HW-VPN.

As a quick introduction, a SSH tunnel is a secure method to transport other
network protocols across network boundaries --- assuming of course that you can
access the network over SSH in the first place. This is achieved by establishing
a SSH connection between the client (yourself) and the remote server, and then
encapsulating (tunnelling) other network protocols --- such as HTTP(S), FTP, and
SSH --- into it. In this instance, we will use a tunnel to forward an SSH
connection from inside the university network to your system.

The basic idea is that you can forward SSH connections, meaning that one tunnels
a series of SSH connections over one or more relay hosts to connect to some
server. Historically, there are several way of doing this (if your interested
you can read about it
[here](//en.wikibooks.org/wiki/OpenSSH/Cookbook/Proxies_and_Jump_Hosts)), but
the easiest way to achieve this is by using the SSH `ProxyCommand` option and
the `-W` flag. Together these provide a way to chain SSH connections together.
An example of this on the command line would be:

```
$ ssh -o ProxyCommand='ssh -W %h:%p <USER>@<IP of remote server>' <USER>@<IP of relay server>
```

Within the `ProxyCommand` we specify the remote server and through the `-W` flag we
state that we want the connection to be forwarded to the relay server --- this is
given as the last argument of the SSH command.

 We can simplify this by removing the need to write all that out by placing it
 the `~/.ssh/config` file. The structure of this would then be:

 {{< highlight sshd >}}
Host SERVER1
  HostName 192.168.0.1
  User someone
  IdentityFile ~/.ssh/id_rsa
Host SERVER2
  HostName 192.168.1.1
  User someoneelse
  ProxyCommand ssh SERVER1 -W %h:%p
 {{< /highlight >}}

Then by calling `ssh SERVER2` you automatically get the connection forwarded
over `SERVER1`.


### Setting up Your Account

### The Module System

The cluster provides many different software packages (see Software for details)
through the Modules system. The basic commands to access and manage these
software packages is:

 * `module list` --- list loaded modules
 * `module avail` --- list all available modules
 * `module load <module name>` --- load a specific module
 * `module unload <module name>` --- unload a specific module

Further commands can be found in the man-page --- `man module`.

When you first login, you'll find that the default-environment module has been
loaded --- this gives you access the SLURM batch-management system. To make
changes to what modules are loaded automatically for you, use module initadd and
module initrm to add entries for you. It is advised not include module purge
within your `.bashrc` file unless you know what you are doing.

More details on how to use the modules system can be read up in the
[Modules](#modules) section.

Queueing System
---------------

The cluster uses [SLURM](//slurm.schedmd.com/), or the _Simple Linux Utility for Resource Management_ to
manage user workloads. It is the only means by which to run applications on the
cluster. A good resource to understand how to use it is through the [quickstart
guide](//slurm.schedmd.com/quickstart.html).

### The Queues

In the table below is given the queues (or as they are referred to in SLURM ---
the _partitions_). The queues are ordered in their priority, with `amd-shortq`
having the highest priority. What this means is that jobs assigned to that queue
will likely be allocated before jobs in other queues.

Name | Time Limit | Nodes | Notes
--- | --- | --- | ---
`amd-shortq` | 1 hour | gpu01 | default queue – please take note of this!
`amd-longq` | 7 days | gpu02-gpu08 |
`intel-shortq` | 1 hour | mic01 |
`intel-longq` | 7 days | mic02, dgx01 |
`specialq` | 30 days | gpu01-gpu08, mic01-mic02, dgx01 | only accessible on request!

If users need access to the specialq or have other needs, please contact us.

Mored details about our queues (partitions) can be found using `sinfo`. For example:

{{< highlight sh >}}
# to get detailed information about the queues (include generic resources)
$ sinfo -o "%15N %10c %10m  %25f %24G" --partition=amd-shortq
NODELIST        CPUS       MEMORY      AVAIL_FEATURES            GRES
gpu07           64         1018366     gpu-host                  gpu:k20:1,gpu:k6000:1
gpu08           64         1018854     gpu-host                  gpu:xp:1

$ sinfo -o "%15N %10c %10m  %25f %24G" --partition=amd-longq
NODELIST        CPUS       MEMORY      AVAIL_FEATURES            GRES
gpu[01-05]      64         515989      gpu-host                  gpu:k20:1
gpu06           64         515989      gpu-host                  gpu:k20:2

$ sinfo -o "%15N %10c %10m  %25f %24G" --partition=intel-longq
NODELIST        CPUS       MEMORY      AVAIL_FEATURES            GRES
dgx01           80         515896      gpu-host                  gpu:p100:8
mic02           32         128906      (null)                    (null)
{{< /highlight >}}

Which jobs are currently running and which jobs are currently queued for
execution can be inspected using the `squeue` command.

### Running Programs

The three most important SLURM commands for running code are `srun`, `sbatch` and
`scancel`. They allow you to insert programs into the queues and to take them off
queues again. They also allow you to specify your program's exact needs.

> **Notice**
> This is a heterogeneous cluster! Not all codes can be run on all nodes! The
> nodes `gpu01-gpu08` have AMD-based CPUs, the nodes `mic01-mic02` have INTEL-based
> CPUs. Both are i86 compatible but depending on the level of compiler
> optimisation your programs may only run one of these two architectures.
> Furthermore, your code may or may not expect a certain number or even version
> of GPU or a MIC to be available. If so, you need to make sure that you specify
> your needs as precisely as possible; otherwise, your code will fail to run or
> suffer poor performance!

The four most important needs you can specify are:

 * the number of nodes you want `--nodes=<n>`
 * which nodes you do or do not want `--nodelist=<name,name,...>` / `--exclude=<name,name,...>`
 * how many cpus you want `-c<n>`
 * which resources (gpus) you want `--gres=<gres,gres,...>`

Example usage:

{{< highlight sh >}}
# to run a command and have its output printed in the shell we use the `srun' command
$ srun <...command...> <...args...>

# another similar example to run an application on an AMD node in the `amd-longq' queue:
$ srun --partition=amd-longq <...command...> <...args...>

# or on three AMD nodes, but not on gpu04 or gpu05
$ srun --partition=amd-longq --nodes=3 --exclude=gpu04,gpu05 <...command...> <...args...>

# if you want to use all cores on a two AMD nodes (2 nodes with 64 cores each!)
$ srun --partition=amd-longq --nodes=2 -c64 <...command...> <...args...>

# if you want to use two particular AMD nodes
$ srun --partition=amd-longq --nodelist=gpu06,gpu07 <...command...> <...args...>
# Note here that the use of `nodelist' implies a minimum number of nodes while
# `exclude' does not impact on the number of nodes asked for!

# If you want to use one AMD core with a single gpu for longer than 1 hour but you do not care
# which node you use
$ srun --partition=amd-longq --gres=gpu  <...command...> <...args...>
# Note here, that this blocks the gpu from being used by anyone else; so
# please do only specify `--gres=gpu' if your code *actually does use* a gpu!

#If you want to use a system that requires two 'K20` gpus for less than 1 hour:
$ srun --gres==gpu:k20:2 <...command...> <...args...>

# to run in 'batch' mode, we use the `sbatch' command
# these examples are the same as those above
sbatch --output=outfile <...command...> <...args...>
sbatch --partition=amd-longq --output=outfile <...command...> <...args...>
sbatch --partition=amd-longq --nodes=3 --exclude=gpu04,gpu05 --output=outfile <...command...> <...args...>
sbatch --partition=amd-longq --nodes=2 -c64 --output=outfile <...command...> <...args...>
sbatch --partition=amd-longq --nodelist=gpu06,gpu07 --output=outfile <...command...> <...args...>
sbatch --partition=amd-longq --gres=gpu --output=outfile <...command...> <...args...>
sbatch --gres=gpu:k20:2 --output=outfile <...command...> <...args...>

# to view the current cluster usage we can look at the queues using `squeue'
$ squeue

# to cancel a batch job we can use the `scancel' command
$ scancel <...job ID...>
{{< /highlight >}}

Modules
-------

Most of the software packages available are managed through a system of modules
which contain both the software files and configuration information. These
modules can be dynamically loaded and unloaded allowing for a great deal of
flexibility --- this is especially useful for making use of different versions or
builds of the same software. More information can be found on the [project
website](//modules.sourceforge.net/).

Example usage:
{{< highlight sh >}}
$ module avail
acml/gcc/64/5.3.1
acml/gcc/fma4/5.3.1
# and many many more modules

$ module load cuda65/toolkit
# this loads the CUDA SDK and toolkit

$ module unload cuda65/toolkit
# this unloads the module
{{< /highlight >}}

### Personal Modules

It is possible to create one's own modules. The benefit of doing this is that
the module system will handle your environment variables for you, as well as
other configuration. Additionally, if for instance you have a dependency on a
module for a piece of software to work, this can be encoded into the module
file.

The first step is to create a `.modulerc` file your home directory, e.g.
`~/.modulerc`. File should contain the following:

{{< highlight tcl >}}
#%Module -*- tcl -*-
## get extra modules files...

module use /home/<USERNAME>/.modules
{{< /highlight >}}

Replace `<USERNAME>` with your username. The module use directive points to a
directory where all of your modules are to be found. The next step is to create
a module. Assuming that you have created the `~/.modules` directory, you can add
a module file to the directory. The typical convention is to create a directory
naming the software (e.g.`~/.modules/mysoftware`) and give the module file the
version of the software as its name, e.g. `~/.modules/mysoftware/1.0.0`.

An example of the content of a module file goes as follows:

{{< highlight tcl >}}
#%Module -*- tcl -*-

# Helpful messages
proc ModulesHelp { } {
        puts stderr "This module sets up access to something"
}
module-whatis "sets up access to something"

prereq somethingelse # ensure that this module is loaded before hand
conflict thatothermodule # ensure that this module is NOT loaded

module load gcc # you can have the module load dependencies for you

set          root             /home/<USERNAME>/install/location # a TCL variable
setenv       SOMEVERION       0.95       # set an environment variable
append-path  PATH             $root/bin  # append to $PATH
append-path  MANPATH          $root/man  # append to $MANPATH
append-path  LD_LIBRARY_PATH  $root/lib  # append to $LD_LIBRARY_PATH
{{< /highlight >}}

For more information on what to put in a module file, have a look at the man
pages, e.g. `man modulefile`.









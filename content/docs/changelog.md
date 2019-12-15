---
title: "Changelog"
weight: 1
noIndex: true
# bookFlatSection: false
# bookToc: 6
# bookHidden: false
---

Changelog
=========

About
-----

This page provides an overview of the most recent changes to the cluster.

### Legend

| Mark | Meaning |
| ---- | ------- |
| **#NAME** | assigned to person with NAME |
| **###** | collaborative task |
| **[DONE]** | task complete |
| **[NNNN]** | task could not be completed |
| **[DELAY]** | task has been delayed |
| **[PART]** | task has been partly completed |


Future Cluster upgrade
------------

### Note

### Todo

* Due to some strange configuration decision by Bright, systemd-journald logs are not persistent (WTF?!). The fix is simple, change the `Storage` key-value to `persistent` in `/etc/systemd/journald.conf`.
* `numa-devel` package (needed for some operations of the hwloc library) is not installed consistently on all nodes!

(Jan 2019) Software Stack upgrade
---------------------------------

### Tasks

  * General software update (headnode + nodes)
    * Move to BCM 8.1 **[DONE]**
    * Nvidia now (Nov. 2018) support RHEL-based distros on the DGX-1 (see http://go.nvidianews.com/h671aUF02O0001EjM900NNk) - using RHEL7 would be a better choice in the long term given that all the other nodes use RHEL7. **[DELAY]**
    * Upgrade MLNX firmware (not possible on `gpu0[1-8]` as the ASUS card is OEM-shit!) **[PART]**
    * Setup CPU-based OpenCL support (using the `amd-app-sdk` - note that AMD longer supports this, as such max OCL API version support is 1.2) **[DONE]**
  * Extension of NetData panel with live status output for users (maybe? **definitely not doing this as there are performance related concerns**)
  * Local Docker and Singularity Registry
    * Setup cm-singularity... **[DONE]**
      * actually, we want to compile from source - also testing has revealed that accessing the NV-related libraries stored in `/cm/shared` via singularity image is non-trivial. Further work is needed, though nothing significant as far as I can tell.
      * There is no stable registry like service yet other than SyLabs Cloud (a Docker Hub contender), which is free but for public images only...
  * Mirror NVIDIA Docker Registry (is this really useful?) **[DELAY]**

### Notes

The main purpose here is to allow users to use Docker images for their work. Main reason is that several vendors/frameworks provide Docker images that are specially optimised (how, and to what degree, is not known) and these optimisation are not available as binary releases (ugh...). Additionally some user prefer docker as it simplifies managing their environment and maintains a degree of consistency across machines/distros.

Main problem: docker is insecure for multi-user environments, has no resource management, and requires additional infrastructure/management. Solution: Singularity (http://singularity.lbl.gov/index.html), which is a tool which converts docker images to binaries - which generate a fs-tree within a chroot. There is no need for a hypervisor or other infrastructure and it works well together with existing management systems like SLURM. Additionally is recommended by Bright Computing (CM provider).

Of course, the usual system updating should be done. In particular CUDA 9.1 is out, so it might be nice for users - especially on `dgx01`.

RDMA setup is not working correctly as the `ib_srp` kernel module has some strange version mismatch meaning it will not load into the kernel... this is not critical though as SRP protocol is used for accessing SCSI-related resources on a remote system... as far as I know no-one needs this feature.

(Oct 2017) DGX-1 Upgrade Ubuntu 14 to 16
-----------------------

### Tasks

* CM 8.0 Upgrade **[DONE]**
  * Reset GPU/Intel node images (maybe?) **[DONE]**
* DGX-1
  * Upgrade to latest image **[DONE]**  --- //thank you Rob Stewart//
  * Upgrade BMC to latest firmware **[DONE]** --- //thank you Rob Stewart//
  * Get CM 8.0 provision working (maybe?) **[DELAY]**
  * Setup Slurm-client **[DONE]**
  * Setup/Test NVIDIA Registry **[PART]**
    * See how well this works with Singularity **[PART]**
* Extend Wiki to include Singularity Examples **[DELAY]**
* Extend `salloc` block to nodes **[DONE]**
* Upgrade to CUDA 9.0 **[DONE]**
  * Upgrade to cuDNN v6 and v7 **[DONE]**


### Notes

* DGX-1
  * NVIDIA have released Ubuntu 16 image for the box - which supports the latest version of SLURM, meaning we can now setup batch managment control there.
  * After DGX-UG meeting, Docker based system seems like a nice solution to reduce lag in installing user modules/keeping the modules system up to date --- using EasyBuild is aweful. We cannot setup docker as its insecure (allows for privilage esciliation from within the container), but instead we can use [Singularity](http://singularity.lbl.gov/index.html) which converts a Docker image into set of scripts which generated a fake-chroot. No privilages are needed for this + its easier to gain access to the hardware as there isn't a hypervisor. Users can just extend/create a sbatch script which launched their Singularity image as such.
* CM 8.0 is out, with the primary update being to support more Linux Distros as slave-nodes - which is fanatastic because it means we could potentially provision the DGX-1 using NVIDIA image - Whoo!!! Other then that they hve updated their data gathering and monitoring system (to what effect I don't know), and a new snazzy web-based management interface.


(Nov 2016) Cluster RHEL6 to RHEL7 upgrade
--------------------------

### Tasks

* Configure default account settings (simplifies users initial experience) **[DONE]**
  * Create informative banner + motd **[DONE]**
  * Set default modules (e.g. `shared`) **[DONE]**
* Install additional packages
  * GCC (4.8 and 6.1) + glibc 2.17 **[DONE]**
  * Intel Compiler Suite
    * Intel VTune facility
  * Portland Compiler Suite **[DONE]**
  * Python + pip (versions 2.7 and 3.4) **[DONE]**
* Configure cluster management system
  * Adaptive user access to nodes (SSH) **[DONE]**
  * Add MIC hosts and MIC nodes
    * identify MIC processor units
* Configuration of SLURM
  * GPU types setup (mainly for gpu08) **[DONE]**
  * Create dedicated MIC queue
  * Initiate Usage logging facility (needed in order to log the number of hours, cpu cores, gpus, etc. used by a user or job) **#Igor**
* Configure Nodes
  * Head Node
    * Propagate sudoers file to nodes using systemd timers and `rsync` **[DONE]**
    * Apcupsd for APC monitoring **[DONE]**
      * Setup notification **[DONE]** //not necessary as default settings are adequate//
    * Configure SNMP for compute nodes (from IPMI) - this allows use to receive hardware level notification outwith the OS
  * MIC Nodes
    * Setup the MIC Node image (copy from `default` image) **#Igor**
    * Configure MICs [relevent](https://software.intel.com/en-us/articles/intel-manycore-platform-software-stack-mpss#lx37rel) **#Igor**
      * install the MIC toolchain **#Igor**
      * compile dedicated linux kernel **#Igor**
    * InfiniBand firmware update **[DONE]**
      * install OFED framework **[DONE]**
  * GPU Nodes
    * Setup GPU node image **[DONE]**
      * install cuda-driver **[DONE]**
    * InfiniBand firmware update
      * Currently running OEM //ConnectX 2 VPI// firmware
    * install OFED framework **[DONE]**
* Update Intranet Wiki
  * New usage pattern for nodes (user can now SSH to node IFF they allocate the node, e.g. `salloc -N 1`). This allows users to now directly interact with a node, monitor processes, and in some cases install there own software. Be aware, the node is stateless, thus on a weekly cycle it will be re-installed and all data there will be lost. #Hans
  * Provide more examples on using SLURM in general - with support for multiple GPU types, the user can now explicitly select the K20 or Quadro 6000.
  * (Internal pages) Include description of cluster upgrade process as well as custom configurations. **###**

#### Backburner

* Setup [YARP](http://www.yarp.it/)
* Setup MatLab clustering

### Notes

#### InfiniBand

* It is not clear yet if the switch is acting as the sub-net manager or if one needs to be setup (e.g. `opensm`).
* Though the firmware versions of the IB adaptors are usable for OFED 3.4 from Mallonex, there seems to be a slight problem with the adaptors install on the GPU nodes. These are **not** original Mallonex adaptors, but some OEM ones (probably ASUS, but maybe HP). As such their `device_id` is not recognised (actually is unparsable) by the OFED management tools/services. This _so far_ is not problematic, but could cause problems if an application needs specific features the OEM firmware is lacking.
* **kernel version locked**, due to how the OFED is setup, any updates to the kernel require a complete re-install of the OFED. `yum` is already setup to ignore kernel package updates.

#### Node Imaging

* The tools/procedures to do node imaging is rather unrefined, and open to errors. In essences, though the CM systems has a notion of variants on images, it provides no means of merging these together to create one. Instead on needs to keep moving forward (which risks missing out on packages updates).
* **Do not do anything in parallel** - work cannot be shared when dealing with chroot an image.

#### APCupsd

* The default settings of `apcupsd` are adequate. In future, if further action is wanted, we can extent the functionality by adding scripts to `/etc/apcupsd` (see `/etc/apcupsd/apccontrol` for examples).

#### SLURM

##### GPU08 (or having multiple GPUs)

* The CMD way of setting things up is through _Roles_, which describe certain properties. These are interpreted and result in configuration files on the node being populated (in this instance, `/etc/slurm/slurm.conf` and `/etc/slurm/gres.conf`). The relevant properties are
  * `gpus`
  * `gpudevices`
  * and `gres`
* These properties though are not what we want, which is to setup GRES Types, in order to distinguish between GPU types. Setting `gpus` indicates the number of GPUs we have, but not their type. Setting `gres` allows use to set an arbitrary GRES type, which not useful here. And finally we have `gepudevices`; this allows use to enter in a list of GPU devices as path references (e.g. `/dev/nvidia0`). A funny thing about this property is that it no interpreted or sanitised in any way - we can right anything here we want.
* What we want is:
```
Name=gpu File=/dev/nvidia0 Type=tesla
Name=gpu File=/dev/nvidia1 Type=quadro
```
* The `gpudevices` property fills the space in `<>`, e.g. `Name=gpu File=<>`
* So to get something like above we do
  * `gpudevices` equals `/dev/nvidia0 Type=tesla\nName=gpu File=/dev/nvidia1 Type=quadro`; notice the `\n` (newline character).
* **This is a hack, this must be checked if we ever upgrade!** _There is no other way of doing this sadly._


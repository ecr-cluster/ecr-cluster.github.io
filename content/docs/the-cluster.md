---
title: "The Cluster"
weight: 1
# bookFlatSection: false
# bookShowToC: true
---

The Cluster
===========

The cluster is made up of 1 head node and 10 compute nodes. Of the compute
nodes, 8 are AMD based systems while the other 2 are Intel based systems. Here
is the following hardware stack for all of the nodes:

{{< hint warning >}}
**Repairs**
The DGX1 node is currently unavailable due to faulty GPU board. There is no ETA on when this will be repaired.
{{< /hint >}}

Node Type | Node Name | Processor | RAM | HDD (`/tmp`) | Extra Components
--- | --- | --- | --- | --- | ---
Head Node | `robotarium` | AMD Opteron 6320 (8 cores) | 64 GB | 916 GB | ---
AMD Compute Node | `gpu01`, `gpu02`, `gpu03`, `gpu04`, `gpu05`, `gpu06` | 4x AMD Opteron 6376 (64 cores) | 512 GB | 40 GB | NVIDIA K20 GPU, (2x in gpu06)
AMD Compute Node (Large RAM) | `gpu07`, `gpu08` | 4x AMD Opteron 6376 (64 cores) | 1024 GB | 40 GB | NVIDIA K20 GPU (_only in `gpu07`_), 2x NVIDIA Titan Xp GPUs (_only in `gpu08`_)
Intel Compute Node | `mic01`, `mic02` |	2x Intel Xeon E5-2650v2 (16 cores) | 128 GB | 40 GB | ---
NVIDIA DGX1 Node | `dgx01` | 2x Intel Xeon E5-2698v4 (40 cores) | 512 GB | 440 GB (7 TB at `/raid/scratch`) | 8x NVIDIA Tesla P100

In addition to the above listed nodes, there are also some special-purpose nodes
--- specifically, the cluster has eight [Intel MIC](//en.wikipedia.org/wiki/Xeon_Phi) nodes:

Node Type | Node Name | Processor | Onboard Memory | Extra Components
--- | --- | --- | --- | ---
Intel MIC Compute Units | `mic01-0`, `mic01-1`, `mic01-2`, `mic01-3`, `mic02-0`, `mic02-1`, `mic02-2`, `mic02-3` | Intel Xeon Phi 5120D | 8 GB | ---

All of the nodes are connected by both a 1Gbps network and an InfiniBand 4x 10Gbps network. We support the full OFED stack.

The nodes are made available through the SLURM resource management system --- more information on queues can be found [here](/docs/how-to#queueing-system).

Details about the OS and available software packages can be found on the [software information](#) page.

---
title: "Compilers"
weight: 1
# bookFlatSection: false
# bookToc: 6
# bookHidden: false
---

Compilers
=========

On the cluster we offer several C/C++/Fortran compilers through our modules
system.

Below is given a short introduction to these and a few tips on how best to
utilise them.

GNU Compiler Collection
-----------------------

Intel Compiler Suite
--------------------

Portland Group Compiler Suite
-----------------------------

The best resource on using any of the PGI compilers is by reading their user
guide, which can be found at http://www.pgroup.com/resources/docs.htm.

### Advice and Tips

#### Compiler Flags

The PGI developers recommend that a few key flags be active for all
compilations, specifically `-fast -Mipa=fast,inline`. The reasons for this and
other details can be found on
https://www.pgroup.com/support/compile.htm.

#### User Configurations

The PGI compiler suite has a default set of configurations that it uses when
first loaded. These can be altered, or new configurations added. The main
benefit of this is that certain compilation stages can be influenced in ways
which are not covered by command line arguments.

These configurations can be set by creating and inserting the configuration
settings into the appropriate RC file within your home directory. The name of
such a file must be of the format `.<compilerbin>rc`, e.g. for `pgcc` the RC
file is `.pgccrc`.

For example, PGI does not support the `-pthread` flag, and will error out if it
encounters this flag. For some situations, using the `-lpthread` flag would be
the solution - but other situations do not allow you to make this change.
Instead, a filter can be set within the PGI configuration which checks for the
`-pthread` flag and replaces it with the `-lpthread` flag. The configuration to
achieve this is `switch -pthread is replace(-lpthread) positional(linker);`.



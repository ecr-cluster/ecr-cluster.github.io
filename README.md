ECR Documentation Website
=========================

This repo contains a [Hugo](//gohugo.io) based website, whose content
constitutes the documentation of the ECR Robotarium Cluster.

The repository has two branches, this (_dev_) and the Github Pages branch
_master_. All edits to the documentation site happen in _dev_, the _master_ page
contains **only** the generated static content.

The website uses the [Hugo Book theme](//themes.gohugo.io/hugo-book/) as a
base, with some minor edits on top.

**Contributions from cluster users are welcome (and encouraged)!**

Contributing
------------

First clone the repo and load all submodules:

```sh
$ git clone git@github.com:ecr-cluster/ecr-cluster.github.io.git
$ cd ecr-cluster.github.io/
$ git submodule update --init # to get hugo-book theme

# this part is important!
$ git worktree add -B master public origin/master
```

_The last command is especially important, as it checkouts the publishing branch
into the directory *public*. This ensures that when calling Hugo, that the
generated content goes to the right place._

After this, edit the site anyway you want. Once complete, post a PR so that your
changes can be merged in.

Licence
-------

This site includes content that _might_ belong to others, it is unclear how to
properly handle this.

The logo/favicon are the property of the [ECR](//www.edinburgh-robotics.org/).

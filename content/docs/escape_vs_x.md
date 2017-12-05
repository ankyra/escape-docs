---
title: "Escape vs. X"
slug: escape-vs-x
type: "docs"
toc: true

back: /docs/how-does-it-work/
backLabel: How Does It Work?
next: /docs/escape-installation/
nextLabel: Installation
---

Escape provides abstractions over releases, deployments and environments,
making it easier to manage the life-cycle and delivery of software components
and their artefacts.  We primarly use Escape to manage cloud environments, and
as there are many tools in this space, this page will try and show where Escape 
fits in, how it's different or where the overlap is.

Any statements perceived as negative are hopefully fair critiques of the tools
in question. We've probably taken inspiration from all these tools so please
don't take this the wrong way, dear vendors <i class='fa fa-heart'></i>

## Escape vs. BOSH

[BOSH](http://bosh.io) is an open source tool for release engineering,
deployment, lifecycle management, and monitoring of distributed systems.
As such it's very similar in scope to Escape, but takes a different approach. 

In BOSH releases are built on top of stemcells which provide a cross-cloud
baseline to build on. A BOSH Director is used to track versions, deploy
releases and monitor and heal deployed virtual machines. To make this
all work the ecosystem prescribes various components and ways of working; it is
opinionated about how things should be done. 

Escape is heavily inspired by BOSH, but aims to be less opinionated about how
things should be done and what underlying tools are being used. BOSH is mainly
used to work with Virtual Machines, but its release engineering capabitilies
can't be used to do Containers, Serverless, etc.  Escape takes a more generic
approach, which makes it more flexible. It means that healthchecking and
self-healing is not provided out of the box, but pushed into the releases
themselves (if they need it). Escape _extensions_ make it possible to turn this
into a pattern though, which can then be reused across packages.

For that same reason Escape has no built-in concept of stemcells, but once
again we can achieve a similar result by building a cross-cloud base image
using regular Escape releases (that use `packer` and `ansible` for example, see
more below). For the moment these base images would have to be developed
in-house, but at some point we may have something like this up on the global
Inventory.

*Advantages of BOSH*

* Solid release engineering
* Cross-cloud virtual machines out of the box
* Self-healing deployments

*Disadvantages of BOSH*

* Primarly for Virtual Machines
* The development cycle for BOSH releases is slow
* Hard to install, learn and debug (although this is all improving)
* Leaky abstractions because of cloud-specific configuration


## Escape vs. Chef, Ansible, Puppet, Salt

[Chef](https://www.chef.io/chef/), [Ansible](https://www.ansible.com/),
[Puppet](https://puppet.com/) and [Salt](https://saltstack.com/) (CAPS) are
configuration management tools. Generally they bring existing machines into
some desired state by e.g. installing packages, starting services and writing
files. Some of these tools also support creating the machines and other bits of
cloud infrastructure, but generally they're best used on existing machines.

Escape is not meant to replace these tools, but can wrap around them to add
packaging, versioning, dependency management, environment promotions, etc.  For
example, using Escape we could combine a Terraform package that creates a
machine with an Ansible package that brings it into its desired state, and make
it possible to manage this as one logical unit.

Some (most) of these tools also provide some sort of package and dependency
management, but only for _other_ CAPS code. For example: you could get your
Ansible dependencies from the Ansible Galaxy, but not your Terraform code.
Escape is able to consolidate your Infrastructure as Code behind one cohesive
release process.

## Escape vs. Terraform and Packer

[Terraform](https://www.terraform.io) is a tool to write, plan, and create
Infrastructure as Code and [Packer](https://www.packer.io/) is a tool to build
automated machine images.  Escape is not meant to replace either of these tools
and at Ankyra we actually use them quite heavily. Combining Escape and
Terraform/Packer makes it possible to promote images and cloud infrastructure
from test environments to production, and have this be part of the regular 
delivery pipeline.

Terraform itself also supports
[modules](https://www.terraform.io/docs/modules/index.html) which makes it
possible to componentize Terraform code. We have however found that splitting
components out into Escape releases works quite nicely as well, as this allows
you to deploy, promote and manage the components as its own unit instead of one
giant Terraform codebase. Although Terraform handles big code bases quite well,
the deployment times start adding up. The other advantage of splitting things out 
is that it's easier to enforce ACL.

Using Escape, Packer and Terraform together we can cleanly fit a virtual
machine image release process into a terraform release process, which is
something that usually takes some ad-hoc scripting to achieve. We can go even
further and have our Packer build depend on CAPS code mentioned above, which
can be nice if you're doing multi-cloud builds (which is like building your own
stemcell, as mentioned in the BOSH section).

## Escape vs. Helm

[Helm](https://github.com/kubernetes/helm) is a package manager for Kubernetes
specifications providing popular software packaged for Kubernetes. 

Escape can also work as a package manager for Kubernetes specifications, and in
fact there's an extension for that. When Escape is used like that, and just for
that, there aren't many differences between Helm and Escape, except that Escape 
doesn't use a server process (ie. `tiller`) on each cluster. 

Escape can also wrap around Helm and provide lifecycle management for its _charts_; in
fact there's an extension for that as well. This allows you to promote Helm charts 
from the community or your own organisation throughout your environments and relate it 
to the rest of your platform (e.g. Kubernetes versions, cloud configuration, etc.)

## Escape vs. dpkg, apt, yum, brew, ...

These are tradional package managers. Some of them have more overlap with
Escape than others, but these are mainly used to manage files and services on a
local file system; they don't have a concept of _environments_ or
_deployments_, just _local installations_. 

Escape takes a more generic view and separates deployment state from packages,
enabling environments, unattended deployments, providers and consumers, etc. 

You _could_ use Escape to work with these package managers, but nowadays you'd
probably use the CAPS tools mentioned above.  You _could_, maybe, also use apt 
to implement cloud deployments, but at that point you're back into ad-hoc scripting 
territory so you might as well Escape.

## Did we forget anything?

There's a lot of stuff out there, but hopefully this has given you an idea of
how Escape compares to the rest of the world. We're always keen to hear from
people though so if you're wondering how Escape relates to X, let us know!

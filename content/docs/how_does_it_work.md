---
title: "How Does It Work?"
slug: how-does-it-work
type: "docs"
toc: true
next: /docs/escape-vs-x/
nextLabel: Escape vs X?
back: /docs/what-is-escape/
backLabel: What is Escape?
---

At its core Escape provides abstractions to work with _packages_ and
_environments_. A package is a collection of files, and some metadata to describe
what it can do.  Packages can depend, extend and consume other packages,
which makes it possible to compose platforms out of them and deploy and promote
them as single units.  Escape allows you to be explicit about the configuration
inputs (and outputs!) a package may have, which makes it easier to manage
different _environments_, into which the packages get deployed. 

<img src='/img/packages.png'/>

At the moment the Escape Ecosystem, if you will, consists of two pieces to make
this possible: the Escape command line tool and the Escape Inventory.  


## The Escape Inventory

The Escape Inventory is an artefact store. It's used for:

* storing and retrieving packages 
* resolving dependencies
* auto-versioning packages (ie. working out what the next version of a package will be)
* notifying downstream projects of updates to their dependencies

The Inventory is a server process that can be run locally or somewhere else to
enable teamwork.

<img src='/img/escape_overview.svg' width="400"/>

## The Escape Command Line Tool

The command line tool is used for building packages, pushing and pulling from
the inventory, deploying to environments, promoting between them, running
operational tasks against deployments, etc. It can be run from your laptop and
is easily integrated into a CI/CD system.

What makes Escape different from other tools is that it gives you a way to
explicitly state what configuration is needed and produced for each package,
and it then allows you to compose these packages into complete platforms. 

Other tools do the actual build and deployment work (for example: `terraform`,
`kubectl`, `docker`, ...), but Escape does all the book-keeping of what's where
and how it's configured -- and then it goes from there. This abstraction over
releases and their deployment state allows you to manage multiple environments,
work with different tools but give them the same release process, make everything 
identifiable and environments self-documenting. Because Escape knows where everything 
is and how it's configured it also becomes easier to build ephemereal environments and 
run operational tasks against deployments.

But you might wonder: isn't this a bit like _X_? Maybe:

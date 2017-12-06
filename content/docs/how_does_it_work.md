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
_environments_. A package is a collection of files, and some metadata to
describe what can be done with it.  Packages make all their configuration
explicit and can depend, extend and consume other packages.  This makes it
possible to compose platforms out of them and deploy and promote them as single
units across different _environments_.

At the moment the Escape Ecosystem, if you will, consists of two pieces to make
this possible: the Escape command line tool and the Escape Inventory.  


## The Escape Inventory

The Escape Inventory is an artefact store. It's used for:

* storing and retrieving packages 
* resolving dependencies
* auto-versioning packages (ie. working out what the next version of a package will be)
* notifying downstream projects of updates to their dependencies

The Inventory is a server process that can be run locally, or somewhere central
to enable teamwork.

<img src='/img/escape_overview.svg' width="400"/>

## The Escape Command Line Tool

The command line tool is used for building packages, pushing and pulling from
the inventory, deploying to environments, running operational tasks against
deployments, etc. It can be run from your laptop and is easily integrated into
a CI/CD system.

One of the things that makes Escape different from other tools is that it gives
you a way to explicitly state what configuration is needed and produced for
each package. At deployment time these variables are checked, evaluated and
persisted in a _state file_, which contains information about all the
environments and their deployments. With this view of the world Escape is able 
to promote between environments, rollback, update, run operational tasks, etc. It 
knows where everything is, how it's configured and what it's produced. 

Other tools do the actual build and deployment work (for example: `terraform`,
`kubectl`, `docker`, ...), but Escape does all the book-keeping of what's where
and how it's configured.  This abstraction over releases and their deployment
state allows you to:

* manage multiple environments
* work with different tools but give them the same release process
* make everything identifiable 
* make environments self-documenting
* build ephemereal environments
* run operational tasks
* ...

But you might wonder: isn't this a bit like _X_? Maybe:

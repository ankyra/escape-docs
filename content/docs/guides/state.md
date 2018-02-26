---
title: "State"
slug: state
type: "docs"
toc: true
wip: false
---

Escape needs to keep track of some state to function correctly. For instance:

* Environments 
* Deployment names and versions
* Providers and consumers
* Input and output values
* Deployment statuses

By default Escape stores this state in the current working directory under a
file called `escape_state.json`. This location can be changed by setting the
`--state` argument. 

Most [`escape run`](/docs/reference/escape_run/) operations manage state as a
side effect and this means that you generally won't have to worry about
manipulating the state by hand. There are some cases where viewing the state
can be useful though:

* Find out what's deployed where
* Find [providers](/docs/reference/providers-and-consumers/)

In these cases we can use the [`escape state`](/docs/reference/escape_state/) commands.

## Using State in a Pipeline

When you're developing or running Escape from your workstation having the state
on disk is not a problem, but when builds and deployments are done by a machine
we need to make sure that the state is kept in sync. For this reason it is
common to store the `escape_state.json` file in a central location or version
control system. This does mean we need to make sure that there's only a single
job using that state file at the same time, otherwise we could end up with an
inconsistent file.

Often you don't want to store your CI state with your production state so you 
could also create a state file per environment. This will allow you to deploy to 
separate environments at the same time, but it does mean you lose the built-in 
ability to [`escape run promote`](/docs/reference/escape_run_promote/).


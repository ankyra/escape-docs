---
title: "Errands"
slug: errands
type: "docs"
toc: true
wip: false

back: /docs/quickstart/deploying/
backLabel: Deploying Environments
next: /docs/quickstart/templates-and-downloads/
nextLabel: Templates and Downloads
---

Software and services generally need to be operated when they're being run in a
live environment. For example: we may need to run backups, scale a service, or
add a user account. Many of these operational tasks can be automated, which is
great, but what's harder is keeping the configuration for these tasks up to
date and testing and promoting them through environments.

Escape solves this problem by making operational tasks, Errands, part of the
deployment of a package. Errands are regular scripts defined in the Escape
Plan, and when deployed have access to all the deployment's input and output
variables. This means that the operational task is always in sync with the
deployment it operates against, and that it can be run in different
environments.

Errands are defined in the Escape Plan like this:

```yaml
name: my-database
version: 0.0.@
deploy: deploy_database.sh

inputs:
- host
- username
- password

outputs:
- database_url

errands:
  backup:
    description: Backup the database.
    script: backup.sh
```

The `backup.sh` script has access to input and output variables; ie. the
environment variables `$INPUT_host`, `$INPUT_username`, `$INPUT_password` and
`$OUTPUT_database_url` will all be set.  

You can also define additional inputs that are only needed for the task at
hand and not relevant to the release itself:

```yaml
name: my-database
version: 0.0.@
deploy: deploy_database.sh

inputs:
- id: host
- id: username
- id: password

errands:
  backup:
    description: Backup the database.
    script: backup.sh
    inputs:
    - id: destination_bucket
      default: "s3://little-backup-bucket"
```

The inputs section works exactly the same as it does for the inputs section on
the package, so in other words you can set defaults, types, use the scripting
language, etc. <a href='/docs/reference/input-and-output-variables'/>See here
for all the options</a>.

## Listing Errands

We can list the errands on a deployment using the [errands
list](/docs/reference/escape_errands_list/) command.  We will need to pass it
the deployment name, and optionally the environment (default is "dev"):

```bash
escape errands list --deployment my-deployment --environment ci
```

## Running Errands

Running an errand can be done using the [errands
run](/docs/reference/escape_errands_run/) command, surprisingly enough.
Once again we pass in the deployment name and environment, but this time we
also add the errand in question:


```bash
escape errands run --deployment my-deployment --environment ci backup
```

If the errand has input variables defined on it we can pass those in as well:

```bash
escape errands run --deployment my-deployment --environment ci backup \
  -v destination_bucket=s3://my-giant-backup-bucket
```

## Developing Errands

The previous commands are pretty simple, but when you're developing a new
errand their behaviour is slightly limiting, because these commands only work
on packages that have already been released.  This means that if
we were to be developing a new errand and we'd want to list and run it to make
sure it works we would have to release and deploy the package first.

To avoid this we can also pass the `--local` flag. This will make Escape read
the errands from the local Escape Plan, instead of trying to fetch them from the
Inventory:

```bash
escape errands list --local
```

To run an errand from the Escape Plan we do still need a deployment, otherwise
the errand has nothing to run against. We don't necessarily need to deploy an
_already released_ package however; we can deploy from our Escape Plan as well,
which fits the development process a bit better.  What's important is that the errand 
gets access to the right state, otherwise the inputs and outputs won't match.

Once the deployment is there we can keep rerunning the `escape errands run
--local` command:

```bash
escape run deploy --deployment my-deployment
escape errands run --deployment my-deployment --local backup
```

Note: it's currently not possible to write tests for Errands that run as part
of the release process, but you can trigger the errands from your "test" and
"smoke" scripts.

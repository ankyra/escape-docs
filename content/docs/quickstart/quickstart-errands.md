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

When you're developing a new errand this behaviour is slightly limiting, because 
for every change you would have to release and deploy the package before being 
able to see the errand. To work around this we can also pass the `--local` flag, 
which will instead read the errands from the Escape Plan:

```bash
escape errands list --local
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

When we're developing errands locally we don't want to release and deploy every
change just to run it, so we can use the `--local` flag again, which takes the
errands directly from the Escape Plan instead:

```bash
escape errands run --deployment my-deployment --environment ci --local backup
```

However, this time we do actually need a deployment present as well! Otherwise
the errand has nothing to run against. So we'll need to `escape run deploy`
first, but on the plus side we only need to do that once. 


---
title: "Dependencies"
slug: dependencies
type: "docs"
toc: true

back: /docs/quickstart/deploying/
backLabel: Deploying Environments
next: /docs/quickstart/output-variables/
nextLabel: Output Variables
---

More often than not a package will depend on a another package to function
correctly. For example: an application could need a database, some files on 
the filesystem, a Docker image, a configured virtual machine, etc. 

Dependencies can be expressed in Escape using the
[depends](/docs/reference/escape-plan/#depends) field of the Escape plan. Dependencies
are just regular old Escape packages, so this mechanism provides us one way to
componentize our infrastructure and software estate (we will look at more in
later sections)

There are many useful examples, but to keep things simple we're going to do
something very contrived and build upon our previous work.  So let's create a
new Escape plan to build a package that depends on our previous
`quickstart/hello-world` package.  Create a file called `escape-dep.yml` with the 
following contents:


```yaml
name: quickstart/introduction
version: 0.0.@
description: 
logo: 

depends:
- quickstart/hello-world-latest
```

Note that even though we specify the latest version of the hello-world package
this version gets resolved at build time and persisted in the release metadata
so that subsequent deployments always use the same dependency. This keeps
things repeatable and predictable (hello, npm). You can verify what versions
are pulled down using the `escape plan preview --plan escape-dep.yml` command.
For more information on versioning schemes see the [guide on
versioning](/docs/guides/versioning/).

Provided that you have a `quickstart/hello-world` release present in your inventory we 
should now we be able to run all of our classic commands:

```bash
$ escape run build --plan escape-dep.yml
Compile: ✔️ Dependencies have been fetched.                 
Build: Starting build.
  Dependency quickstart/hello-world-v0.0.4: Running deploy step /home/user/workspace/deps/quickstart/hello-world/hello_world.sh.
  Dependency quickstart/hello-world-v0.0.4: hello_world.sh: Hello World!
  Dependency quickstart/hello-world-v0.0.4: ✔️ Deployed dependency quickstart/hello-world-v0.0.4
Build: ✔️ Completed build
```

And there we have it.

<div class='docling'>
We ran a <i>build</i> for our parent, but our dependencies were <i>deployed</i>.
A build is never repeated.
</div>

## Configuring Dependencies

Careful readers may have noticed that we have completely ignored the [input
variables](/docs/quickstart/input-variables/) for our `quickstart/hello-world`
_dependency_, making the output default to "Hello World!". Luckily there are a
few ways we could set this variable. 

#### At build/deploy time

Input variables on the dependency are automatically added to the parent release
(which we can verify again by running `escape plan preview --plan
escape-dep.yml`), so the easiest way to change the variable is to pass a value 
at build or deploy time:

```bash
$ escape run build --plan escape-dep.yml -v who=You
Compile: ✔️ Dependencies have been fetched.                 
Build: Starting build.
  Dependency quickstart/hello-world-v0.0.4: Running deploy step /home/user/workspace/deps/quickstart/hello-world/hello_world.sh.
  Dependency quickstart/hello-world-v0.0.4: hello_world.sh: Hello You!
  Dependency quickstart/hello-world-v0.0.4: ✔️ Deployed dependency quickstart/hello-world-v0.0.4
Build: ✔️ Completed build
```

However, this is also the least explicit way and requires you to remember what
values need overriding.

#### Using literals

We can also set the value directly from the Escape plan by configuring the
dependency:

```yaml
name: quickstart/introduction
version: 0.0.@
description: 
logo: 

depends:
- release_id: quickstart/hello-world-latest
  mapping:
    who: Everyone I Know

```

This is handy if the value never changes from the perspective of the parent.

```bash
escape run build --plan escape-dep.yml           
Compile: ✔️ Dependencies have been fetched.                 
Build: Starting build.
  Dependency quickstart/hello-world-v0.0.4: Running deploy step /home/user/workspace/deps/quickstart/hello-world/hello_world.sh.
  Dependency quickstart/hello-world-v0.0.4: hello_world.sh: Hello Everyone I Know!
  Dependency quickstart/hello-world-v0.0.4: ✔️ Deployed dependency quickstart/hello-world-v0.0.4
Build: ✔️ Completed build
```

It does however mean that end-users won't be able to override the variable:

```bash
escape run build --plan escape-dep.yml -v who=You          
Compile: ✔️ Dependencies have been fetched.                 
Build: Starting build.
  Dependency quickstart/hello-world-v0.0.4: Running deploy step /home/user/workspace/deps/quickstart/hello-world/hello_world.sh.
  Dependency quickstart/hello-world-v0.0.4: hello_world.sh: Hello Everyone I Know!
  Dependency quickstart/hello-world-v0.0.4: ✔️ Deployed dependency quickstart/hello-world-v0.0.4
Build: ✔️ Completed build
```

Sometimes this is what you want, because you can use this to set reasonable
defaults or hide information and complexity, but sometimes you'd like to be
both explicit and flexible:

#### Passing variables from the parent

By adding an _input variable_ to the parent package and referencing the variable 
in the dependency mapping we can wire up our configuration values:

```yaml
name: quickstart/introduction
version: 0.0.@
description: 
logo: 

depends:
- release_id: quickstart/hello-world-latest
  mapping:
    who: $this.inputs.who

inputs:
- id: who
  default: Everyone
```

The `$this.inputs.who` bit is not standard YAML, but part of Escape's tiny
[scripting language](/docs/reference/scripting-language/). This is not meant to
be a full-blown language, but can be used to pass variables around and solve
some other small configuration problems similar to this one. 

Running `escape run build` now uses the parent's value:

```bash
escape run build --plan escape-dep.yml 
Compile: ✔️ Dependencies have been fetched.                 
Build: Starting build.
  Dependency quickstart/hello-world-v0.0.4: Running deploy step /home/user/workspace/deps/quickstart/hello-world/hello_world.sh.
  Dependency quickstart/hello-world-v0.0.4: hello_world.sh: Hello Everyone!
  Dependency quickstart/hello-world-v0.0.4: ✔️ Deployed dependency quickstart/hello-world-v0.0.4
Build: ✔️ Completed build
```

But we can also override it at build/deploy time:

```bash
escape run build --plan escape-dep.yml -v who=You          
Compile: ✔️ Dependencies have been fetched.                 
Build: Starting build.
  Dependency quickstart/hello-world-v0.0.4: Running deploy step /home/user/workspace/deps/quickstart/hello-world/hello_world.sh.
  Dependency quickstart/hello-world-v0.0.4: hello_world.sh: Hello You!
  Dependency quickstart/hello-world-v0.0.4: ✔️ Deployed dependency quickstart/hello-world-v0.0.4
Build: ✔️ Completed build
```

We have seen how we can use parent inputs to configure dependencies, but can we
use dependency outputs in the parent? And what are outputs? Yes.

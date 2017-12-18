---
title: "Output Variables"
slug: output-variables
type: "docs"
toc: true

back: /docs/quickstart/dependencies/
backLabel: Dependencies
next: /docs/quickstart/providers-and-consumers/
nextLabel: Providers and Consumers
---

In the [previous section](/docs/quickstart/dependencies/) we have seen how we
can use [input variables](/docs/quickstart/input-variables/) to configure
dependencies, but what if our dependency has created some very interesting
output that we would like to re-use or reference in our parent?  For example:
we may be deploying a website at a certain URL, a database that generates a new
connection string, a Kubernetes cluster with new credentials, etc.

What we need is a programmatic way to deal with outputs coming out of our
dependencies. Let's go back to our original `escape.yml` for the
`quickstart/hello-world` package and add an `outputs` field:

```yaml
name: quickstart/hello-world
version: 0.0.@
description: 
logo: 

includes:
- README.md

build: hello_world.sh
deploy: hello_world.sh

inputs:
- id: who
  default: World
  type: string
  description: Who should we be greeting?

outputs:
- id: literal
  default: "Some static configuration value"
  description: Defining outputs as literals
- id: who
  default: $this.inputs.who
  description: Defining outputs using the Escape scripting language.
- id: script_output
  description: This variable should be set in the hello_world.sh script.
```

This is very similar to configuring dependencies in that we can use literals or
the [scripting language](/docs/references/scripting-language/) to define output
values. However, crucially, we can also let our script define output variables,
and if no `default` output value is set Escape actually requires it:

```bash
$ escape run build            
Build: Running build step /home/user/workspace/hello_world.sh.
Build: hello_world.sh: Hello World!
Build: Error: Missing value for variable 'script_output'
```

## Outputting Values from Scripts

When Escape runs a script (e.g. `build`, `deploy`) it passes the location of a
file as a first argument.  We can use this location in our script to write a
JSON object containing key-value pairs defining our outputs. BASH isn't great
for JSON, but our assumption is that packages that are complex enough to
warrant outputs are probably not going to be written in BASH (although there's
always [jq](https://stedolan.github.io/jq/)). That being said, let's make our
above plan work by changing `hello_world.sh` to:

```bash
#!/bin/bash -e

echo "Hello ${INPUT_who}!"

echo '{"script_output": "We had a great time running this script. Thanks."}' > $1
```

This will make our build work again:

```bash
$ escape run build            
Build: Running build step /home/user/workspace/hello_world.sh.
Build: hello_world.sh: Hello World!
Build: ✔️ Completed build% 
```

You can't tell from this log output, but behind the scenes Escape has persisted 
the outputs in the state file:

```
escape state show-deployment
```

## Using Dependency Outputs

Before we try and use the refurbished `hello-world` package we should release 
it to our Inventory so that it can be picked up by our parent package:

```
escape run release
```

The "parent" package we've built in the [previous
section](/docs/quickstart/dependencies/) was using the following Escape plan
(saved in `escape-dep.yml`): 


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

Since this is a contrived example we'll just show a few patterns:

### Outputting Dependency Outputs

Sometimes we'd like to make our dependency outputs available to our upstream
dependencies.  This can be useful for writing wrappers or exposing certain 
configuration outputs that may be useful down the line (e.g. URLs, ...).
We can once again use the [scripting language](/docs/references/scripting-language/) 
to wire things up without having to fall-back to BASH scripts:

```yaml
name: quickstart/introduction
version: 0.0.@
description: 
logo: 

depends:
- quickstart/hello-world-latest as hello

outputs:
- id: who
  default: $hello.outputs.who
```

### Using Dependency Outputs as Inputs

In our previous example we have used the parent input to configure a
dependency, but we can also use a dependency output to configure a parent:

```yaml
name: quickstart/introduction
version: 0.0.@
description: 
logo: 

depends:
- quickstart/hello-world-latest as who

inputs:
- id: literal
  default: $hello.outputs.literal
  eval_before_dependencies: false
```

Note the use of `eval_before_dependencies`. Normally inputs are evaluated
before dependencies, but using this option we can defer it to after.  Using
this technique we can for instance depend on a database package and use its
outputs to configure our application. However, there might be a slightly more
appropriate way to model this, which we'll explore in the next section:

---
title: "Providers and Consumers"
slug: providers-and-consumers
type: "docs"
toc: true

back: /docs/quickstart/output-variables/
backLabel: Output Variables
next: /docs/quickstart/errands/
nextLabel: Errands
---

Things often run on other things or need other things to run. In Escape we can
express this idea using _providers_ and _consumers_. A _provider_ provides
a certain service or platform and a _consumer_ makes use of it.

In practical terms Providers and Consumers are regular Escape packages. A provider 
defines what kind of interface it implements and usually has a few outputs:


```yaml
name: quickstart/my-provider
version: 0.0.@
provides:
- introduction

outputs:
- id: credentials
  default: "My platform specific configuration output"
```

A consumer defines what kind of provider it consumes, and will usually use the
outputs to configure itself:


```yaml
name: quickstart/my-consumer
version: 0.0.@
consumes:
- introduction

inputs:
- id: credentials
  default: $introduction.outputs.credentials
```

When we try to `escape run build` or `escape run deploy` this package we'll get
an error:

```bash
$ escape run build --plan escape-consumer.yml
Build: Starting build.
Build: Error: Missing provider of type 'introduction'. This can be configured using the -p / --extra-provider flag.
```

Which is Escape complaining that it can't find a provider of type
'introduction', because we haven't deployed one. We can fix this by releasing
and deploying the provider:

```
$ escape run release --plan escape-provider.yml 
Release: Releasing quickstart/my-provider-v0.0.0
  Build: ✔️ Completed build
  Test: ✔️ Tests passed.
  Destroy: ✔️ Destruction complete
  Deploy: ✔️ Successfully deployed my-provider-v0.0.0 with deployment name quickstart/my-provider in the dev environment.
  Smoke tests: ✔️ Smoke tests passed.
  Destroy: ✔️ Destruction complete
  Package: ✔️ Packaged quickstart/my-provider-v0.0.0 at /home/user/workspace/.escape/target/my-provider-v0.0.0.tgz
  Push: ✔️ Push successful.
Release: ✔️ Successfully released quickstart/my-provider-v0.0.0

$ escape run deploy quickstart/my-provider-latest    
Deploy: ✔️ Successfully deployed my-provider-v0.0.0 with deployment name quickstart/my-provider in the dev environment.

$ escape run build --plan escape-consumer.yml        
Build: ✔️ Completed build

```

## Dependencies vs Providers/Consumers

In a previous section we have seen
[dependencies](/docs/quickstart/dependencies/). Dependencies are resolved at
build time and provide a tight coupling between parents and their children.
Providers and consumers provide a much looser coupling due to interface typing.
This makes it possible to implement multiple implementations for a provider
without having to change consumers; for example: we can provide a different
provider for testing or local development purposes.

We can configure dependency inputs from the parent package and/or use their
outputs. Consumers, on the other hand, are unable to configure the providers
and solely have access to their outputs. 

Another difference is that a provider can be consumed by multiple deployments
in the same environment, whereas a dependency only works as part of a parent
release. In practical terms this means that a platform or shared service (e.g.
a Kubernetes cluster, a message queue, etc.) is usually much more appropriate
to implement as a provider than a dependency. 

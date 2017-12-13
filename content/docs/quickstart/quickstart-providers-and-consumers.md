---
title: "Providers and Consumers"
slug: providers-and-consumers
type: "docs"
toc: true
wip: true

back: /docs/quickstart/output-variables/
backLabel: Output Variables
next: /docs/quickstart/errands/
nextLabel: Errands
---

In a previous section we have seen
[dependencies](/docs/quickstart/dependencies/). Dependencies are resolved at
build time and provide us a way to reuse packages at build and deployment time. 

Providers and consumers work similarly, but different.


```yaml
name: quickstart/my-provider
version: 0.0.@
provides:
- introduction
```


```yaml
name: quickstart/my-consumer
version: 0.0.@
consumes:
- introduction
```

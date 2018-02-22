---
title: "Templates and Downloads"
slug: templates-and-downloads
type: "docs"
toc: true
wip: false

back: /docs/quickstart/errands/
backLabel: Errands
---

When you're installing and setting up software you often have to download a
package or template a file. Because these tasks are so common Escape provides
built-in support for both.

## Templating

Templates are files that serve as starting points for other files. They are
most often used when some kind of configuration file needs to be generated for
a service or application.

Escape supports the [Mustach](https://mustache.github.io/) templating language
out of the box and integrates it into the build and deployment processes.  We
can define Templates in the Escape plan:

```yaml
name: quickstart/hello-world
version: 0.0.@

inputs:
- id: who
  default: World
  type: string
  description: Who should we be greeting?

templates:
- file: my_template.txt.tpl
  target: my_template.txt
```

Templates are rendered as part of the build and deployment steps, but they can
be scoped as well (see `deploy_templates` and `build_templates` in the
[plan](/docs/reference/escape-plan/)). If `my_template.txt.tpl` would look like this:

```
Hello, {{who}}!
```

After building or deploying the file `my_template.txt` should look like this:

```
Hello, World!
```

### Template Mapping

Sometimes we need to give the template more variables that are not directly
available in our parent release, or we have to mangle the ones that are. For
example, we could have something like this:

```
{{greeting}}, {{who}}!
```

In those cases we can explicitly set up a variable mapping:

```yaml
name: quickstart/hello-world
version: 0.0.@

inputs:
- id: who
  default: World
  type: string
  description: Who should we be greeting?

templates:
- file: my_template.txt.tpl
  target: my_template.txt
  mapping:
    greeting: "Alright"
```

We can also use [Escape Script](/docs/reference/scripting-language/) in the value
fields. In fact, behind the scenes, Escape adds a variable mapping for all the
parent's variables (unless you override it in the mapping). You can see this when
running `escape plan preview` on an Escape plan that uses a template:

```
   "templates": [
      {
         "file": "config.toml.tpl",
         "target": "config.toml",
         "scopes": [
            "build"
         ],
         "mapping": {
            "branch": "$this.branch",
            "description": "$this.description",
            "docker_cmd": "$this.inputs.docker_cmd",
            "docker_email": "$this.inputs.docker_email",
            ...
```

So Escape gives us a neat way to reuse our release's input variables for 
configuration files.

## Downloads

Downloads are defined in the Escape Plan and are performed during the build 
and deployment steps:

```yaml
name: quickstart/hello-world
version: 0.0.@

inputs:
- id: who
  default: World
  type: string
  description: Who should we be greeting?

downloads:
- url: https://example.com/some-archive.tgz
  dest: some-archive.tgz
```

### Unpacking Downloads

Escape can be told to automatically unpack downloaded packages, which is often
the first thing you want to do. Escape supports this feature on .zip, .tgz,
.tar.gz and .tar extensions. 

```yaml
name: quickstart/hello-world
version: 0.0.@

inputs:
- id: who
  default: World
  type: string
  description: Who should we be greeting?

downloads:
- url: https://example.com/some-archive.tgz
  dest: some-archive.tgz
  unpack: true
  if_not_exists:
  - some-binary
```

### Skipping Downloads

We can also tell Escape to skip the download and unpack step if a particular
file already exists (glob patterns are also supported here):

```yaml
name: quickstart/hello-world
version: 0.0.@

inputs:
- id: who
  default: World
  type: string
  description: Who should we be greeting?

downloads:
- url: https://example.com/some-archive.tgz
  dest: some-archive.tgz
  unpack: true
  if_not_exists:
  - some-binary
  - /usr/bin/already-installed-local-binary
```

There are a few more options on Downloads, which you can find in the [reference
documentation](/docs/reference/downloads/).

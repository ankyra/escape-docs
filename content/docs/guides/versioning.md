---
title: Versioning
slug: versioning
type: "docs"
toc: true
wip: false
---

## Semantic Versioning

Escape supports semantic versioning, which are versions that look like this:
`0.1`, `1.0`, `0.0.1`, `2.12.135`, etc.

We can have arbitrarily many dots in our version, but usually we use three
parts: the major version, the minor version and the patch version.  Each of
these parts should tell us something about the software:

* A major version change suggests major breaking changes in the API. 
* A minor version change suggests small changes or additions to the API.
* A patch version change suggests small bug fixes and tweaks. 

We use the word "suggests", because changing version numbers is a human
process. The same is true in Escape, except for patch versions, which can be
automated.

## Explicit Versioning

When we're building a package we define the version in the [Escape
Plan](/docs/reference/escape-plan/):

```
name: example/versioning
version: 1.0
```

When we release this package this version gets registered and uploaded into the
Inventory. Once registered the version cannot be overwritten. In Escape a
versioned package is immutable. This is good, because it means that when we
deploy a specific version or refer to it anywhere else, we always get the same
thing. But it also means that we can only release the above Escape Plan once.
If we make a change and want to release a new version than we need to update
the version field:

```
name: example/versioning
version: 1.0.1
```

This is not the end of the world, but could be awkward when an automated system
(e.g. Jenkins, CircleCI, Travis, Gitlab, ...) is doing the release, because you 
would have to remember to update the version field on every push.

## Auto Versioning

So explicit versioning is a bit awkward in an automated world, but luckily
Escape and the Escape Inventory know about all the previous versions of a
package; so it is able to work out the next version. We can enable automatic
versioning by ending the version on `.@`:

```
name: example/versioning
version: 1.0.@
```

This tells Escape to use the first available version that has `1.0.` as a
prefix. Now, every time we do a release we'll get a new immutable version:
`1.0.0`, `1.0.1`, `1.0.2`, ...

This makes it a lot easier to integrate into an automated system.

## Resolving Dependencies

Resolving dependencies is a balancing act between being up-to-date and secure
on one side, and having expected behaviour on the other side. In one extreme
you're always dependening on the latest version of a package, in the other
extreme you're tracking versions explicitly by hand. In Escape we can do both 
and some things in between.

Dependencies are defined in the Escape Plan, and their version is part of the
release id:

```
name: example/resolving-dependencies
version: 1.0.@
depends:
- my-project/my-dependency-v1.0.0
```

Setting explicit versions means we always get the same package, and if we ever
want to update and get the new changes we have to do that manually.

On the other end of the spectrum we can always depend on the latest package:

```
name: example/resolving-dependencies
version: 1.0.@
depends:
- my-project/my-dependency-latest
```

This will pull the latest version every time a build is done.  What's important
to note is that Escape only resolves dependency versions at build time, and
then persists those versions in the release metadata. This means that at
deployment time it's using the same versions as it did at build time. If it did
not do this it could be a big source of hard to debug unintended behaviour.

Finally, we can also use the `.@` syntax to resolve the latest version with 
a particular prefix:

```
name: example/resolving-dependencies
version: 1.0.@
depends:
- my-project/my-dependency-v1.0.@
- my-project/my-other-dependency-v1.@
```

The first example will pull the latest patch version in the `1.0` line, whereas 
the second example pulls the latest in the `1.` line. 

So which one should you pick? It's hard to say and heavily dependent on
context. Our rule of thumb is to use "latest" during heavy development periods
and switch to "auto-patching" (e.g. `v1.0.@`) when things settle down, although
often times we leave it because we want to find out as soon as possible when
our dependencies break (we trigger builds for upstream dependencies
automatically in our pipeline).


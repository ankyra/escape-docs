---
title: "How Does It Work?"
slug: how-does-it-work
type: "docs"
toc: true
---

At the moment there are two parts to it. There's the Escape Inventory which is an artefact store; used for storing and retrieving packages and answering questions like: what will be the next version if I would release another package? (ie. auto-versioning) The Inventory is a server process that can be run locally or somewhere else to enable teamwork.

Then there is the Escape command line tool. It is used for building packages, pushing and pulling from the inventory, deploying to environments, running operational tasks, etc. What makes it different from other tools is that Escape gives you a way to explicitly state what configuration is needed and produced for each package, and it then allows you to compose packages into complete platforms. You call other tools to do the actual build and deployment work, but Escape does all the book-keeping of what's where and how it's configured -- and then it goes from there.

The command line tool can run without the Inventory, if dependencies are on disk and auto-versioning isn't used, but it's very easy to plug in to CI and CD systems when it does. At the moment is doesn't model pipelines itself, but this is something we'd like to address when we've got the right building blocks in place.

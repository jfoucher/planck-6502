---
layout: post
title:  "Generating Gerbers and schematics with Kibot"
excerpt_separator: <!--more-->
---

Kibot is a great tool that can automatically generate output files for our boards. Let's take a look at how to use it

<!--more-->

I publish all source files for the Planck computer on Gitlab, a souce code repository based on git. Gitlab has a feature where it can run some code everytime you upload a new version. It is possible to use this feature to generate updated gerber files, schematics, etc everytime a new version is published with Kibot, the KiCad automation tool.
You can install Kibot on your computer and run it from there, but I think the real beauty of it is to run it everytime we publish a new version, so that documentation, schematics, gerbers etc are always is sync.

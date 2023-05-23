---

title: Showing PowerShell Demos
author: StartAutomating
sourceURL: https://github.com/StartAutomating/ShowDemo/issues/1
---
If you're trying to show off your scripts, typos are not your friend.

It would be really nice if you could just show your scripts step-by-step.

Long ago, Jeffery Snover wrote a little demo player, Start-Demo, that did exactly that.  This is a cool script, but it got lost to the sands of time, and hasn't been updated too much since V1.

ShowDemo is a small PowerShell module that makes sleek PowerShell demos.

Any file named: `*.demo.ps1` or `*.walkthru.ps1` will be considered a demo.

A demo file will follow this format:

~~~PowerShell

# 1. Chapters are comments that start with a number

# Comments or statements that start a line and are balanced will be considered a step

"like this is one step"

"but so is this whole pipeline,
    that stretches for multiple lines" -split
       ','

# Each step will output in full color

# and wait for you to press enter

"then a step will run"

# You press enter one more time after a command has run

# And so it goes.

# step by step

# until a demo is done
~~~

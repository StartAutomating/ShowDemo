#1. Get-Command

# Get-Command is one of three commands that make up the Trinity of Discoverability.

# These three commands will help you find your way around what PowerShell can do.

# Get-Command helps you find out what commands exist.

Get-Command -Module ShowDemo

# Because everything is an object in PowerShell, we can pipe this into other commands.

# So, if we wanted to just get a random loaded command from Show-Demo, we'd use:

Get-Command -Module ShowDemo | Get-Random

# In PowerShell, it's common for commands to share similar names.

# So we can search for commands by wildcard:

Get-Command *Demo*

#2. Get-Help

# Get-Help helps us figure out how commands work.

Get-Help Show-Demo

# By default, you see an overview of available help.

# We can get help about each parameter by using -Parameter *

Get-Help Show-Demo -Parameter *

#3. Get-Member

# Get-Member helps us figure out what properties and methods are available on an object.

# For example, we can see what properties are available on the output of Get-Command:

Get-Command -Module ShowDemo | Get-Member

# Every object has members.  Let's get the members of ShowDemo

Get-Module ShowDemo | Get-Member

# We can also get -Static members.  This is especially useful for classes.

[Math] | Get-Member -Static





# 1. Hello World in PowerShell

# .Silent cls

# 'Hello world' is a really simple script to write in PowerShell.
# You just put it in quotes.

"hello world"

# This is because in PowerShell, unassigned output is returned.

# 2. PowerShell and Objects

# Everything in PowerShell is an object.
# So I can tell you how many characters there are in hello world just by getting the .Length
"hello world".Length

# 3. Basic Math in PowerShell

<#
Math in PowerShell is also really straightforward.
#>
1 + 1

9 / 5

1 + 1 + 2 + 1

# 4. Basic string formatting with PowerShell

# You can use .NET string formatting with PowerShell by using the -f operator
'{0:c}' -f 1.99

# The format string in on the left, and the value you're formatting is on the right.

# '{0:c}' means 'format as currency'

# The value we are formatting is 1.99.

# We can also use the .NET type [string] to do the formatting:
[string]::Format("{0:c}", 1.99)

# You can do some fun things with PowerShell, like multiply strings to repeat them.
'$' * 10

# 5. The Object Pipeline (is money)

# A cool and unique part of PowerShell is the object pipeline

# You can send every object to a command by 'Piping' the object.

# You can pipe as many commands together as you would like.

# So you basically program in PowerShell by connecting the dots.

# To display information in a color, we use the built in command Write-Host.

# So let's see how much money we can make by connecting the dots.

# The joke for a long time has been PowerShell + a pulse is $50/hr.

'$' * 50 | Write-Host

'{0:c}' -f 50

# 40 hours a week
'$' * 50 * 40 | Write-Host

'{0:c}' -f (50 * 40)

# 52 weeks a year
'$' * 50 * 40 * 52 | Write-Host
'{0:c}' -f (50 * 40 * 52)

# Learn PowerShell.
# Write Scripts.
# Make Money.
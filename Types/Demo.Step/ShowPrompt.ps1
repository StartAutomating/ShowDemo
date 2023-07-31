<#
.SYNOPSIS
    Shows the prompt
.DESCRIPTION
    Show the prompt within a demo.
.EXAMPLE
    #.ShowPrompt
#>
param(
# Any additional parameters for the step.
# This is ignored when showing prompts.
$step
)

param($step)

$this.Chapter.Demo | Add-Member NoteProperty ShowPrompt $true
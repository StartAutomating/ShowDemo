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

$this.Chapter.Demo | Add-Member NoteProperty ShowPrompt $true

$null = New-Event -SourceIdentifier Demo.ShowPrompt -Sender $this.Chapter.Demo -EventArguments @($step)
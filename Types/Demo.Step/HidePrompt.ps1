<#
.SYNOPSIS
    Hides the prompt
.DESCRIPTION
    Hides the prompt within a demo.
.EXAMPLE
    #.HidePrompt
#>
param(
# Any additional parameters for the step.
# This is ignored when hiding prompts.
$step
)

$this.Chapter.Demo | Add-Member NoteProperty ShowPrompt $false
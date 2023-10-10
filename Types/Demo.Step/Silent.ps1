<#
.SYNOPSIS
    Run a silent step
.DESCRIPTION
    Run a silent step of a demo.
    
    Silent steps do not display their results.
#>
param($silentStep)

Invoke-Expression $silentStep | Out-Null

$null = New-Event -SourceIdentifier Demo.Step.Silent -Sender $this -EventArguments @($silentStep)
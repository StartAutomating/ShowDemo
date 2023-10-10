<#
.SYNOPSIS
    Sets demo status
.DESCRIPTION
    Sets the status of a demo.
#>
param([string]$Status)

$this | Add-Member Status $status -Force

$null = New-Event -SourceIdentifier Demo.SetStatus -Sender $this -EventArguments @($Status)
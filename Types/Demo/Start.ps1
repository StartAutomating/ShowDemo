<#
.SYNOPSIS
    Starts a Demo
.DESCRIPTION
    Starts a Demo file.
#>
$this | Add-Member NoteProperty Status Running -Force
$this | Add-Member NoteProperty DemoStarted ([DateTime]::Now) -Force

$null = New-Event -SourceIdentifier Demo.Start -Sender $this -EventArguments $args
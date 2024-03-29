<#
.SYNOPSIS
    Stops a demo
.DESCRIPTION
    Stops a demo that is currently running
#>
$this | Add-Member NoteProperty Status Stopped -Force
$this | Add-Member NoteProperty StepToRun $null -Force
$this | Add-Member NoteProperty DemoFinished ([datetime]::Now) -Force
$demo | Add-Member NoteProperty CurrentChapter $null -Force
$demo | Add-Member NoteProperty CurrentStep $null -Force

$null = New-Event -SourceIdentifier Demo.Stop -Sender $this -EventArguments $args
<#
.SYNOPSIS
    Resets a demo
.DESCRIPTION
    Resets a demo file, so that it can be replayed.
#>
$this | Add-Member NoteProperty Status "NotStarted" -Force
$this | Add-Member NoteProperty StepToRun $null -Force
$demo | Add-Member NoteProperty DemoFinished $null -Force
$demo | Add-Member NoteProperty DemoStarted  $null -Force
$demo | Add-Member NoteProperty CurrentChapter $null -Force
$demo | Add-Member NoteProperty CurrentStep $null -Force

$null = New-Event -SourceIdentifier Demo.Reset -Sender $this -EventArguments $args
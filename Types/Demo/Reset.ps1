$this | Add-Member NoteProperty Status "NotStarted" -Force
$this | Add-Member NoteProperty StepToRun $null -Force
$demo | Add-Member NoteProperty DemoFinished $null -Force
$demo | Add-Member NoteProperty DemoStarted  $null -Force
$demo | Add-Member NoteProperty CurrentChapter $null -Force
$demo | Add-Member NoteProperty CurrentStep $null -Force
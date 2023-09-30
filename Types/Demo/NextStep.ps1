<#
.SYNOPSIS
    Go to the next demo step
.DESCRIPTION
    Advances a demo to the next step.
#>
$demo = $this
$demo.CurrentStep++
# No more steps in this chapter
if (-not $demo.CurrentChapter.Steps[$demo.CurrentStep - 1]) {
    $demo.NextChapter()
}

$null = New-Event -SourceIdentifier Demo.NextChapter -Sender $this -EventArguments $args
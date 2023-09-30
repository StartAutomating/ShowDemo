<#
.SYNOPSIS
    Go to the Next Chapter in a Demo
.DESCRIPTION
    Advances a demo to the next chapter.
#>
$demo = $this
$chapterIndex = $demo.Chapters.IndexOf($demo.CurrentChapter)
$chapterIndex++
if (-not $demo.Chapters[$chapterIndex]) {
    $demo | Add-Member NoteProperty DemoFinished ([datetime]::Now) -Force
} else {
    $demo | Add-Member NoteProperty CurrentChapter $demo.Chapters[$chapterIndex] -Force
    $demo | Add-Member NoteProperty CurrentStep 0 -Force
}

$null = New-Event -SourceIdentifier Demo.NextChapter -Sender $this -EventArguments $args
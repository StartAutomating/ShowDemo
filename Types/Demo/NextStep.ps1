$demo = $this
$demo.CurrentStep++
# No more steps in this chapter
if (-not $demo.CurrentChapter.Steps[$demo.CurrentStep - 1]) {
    $demo.NextChapter()
}
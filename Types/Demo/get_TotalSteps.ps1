$stepCount = 0
foreach ($chapter in $this.Chapters) {
    $stepCount += $chapter.Steps.Length
}
$stepCount
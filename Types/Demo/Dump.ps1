$demoContent =
@(foreach ($chapter in $this.Chapters) {
    "# $($chapter.Number) $($chapter.Name)"
    $stepIndex = 0
    foreach ($step in $chapter.Steps) {
        $stepIndex++
        if ($this.CurrentChapter -eq $chapter -and $this.CurrentStep -eq $stepIndex) {
            "    <# *** You Are Here! *** #>"
        }
        $step

    }
}) -join [Environment]::NewLine

$demoContent
param([string]$Chapter)

if (-not $this.Chapters) { throw "No Chapters" }
$chapterParts = @($chapter -split '\.')
$potentialChapterNumbers = @(
    if ($chapterParts.Length -gt 1) {
        ($chapterParts[0..($chapterParts.Length - 2)] -join '\.') + '*'
    }    
    $chapter + '*'
)



$newChapter, $newStep = 
    :nextChapter foreach ($chap in $this.Chapters) {
        foreach ($potential in $potentialChapterNumbers) {
            if ($chap.Number -like $potential) {
                if ($potential -ne ($Chapter + '*')) {
                    # Setting chapter and step number
                    $chap, $chapterParts[-1] -as [int]
                    break nextChapter
                } else {
                    $chap, 1
    
                }
            }
        }        
        
    }

if (-not $newChapter) {
    throw "Could not find chapter '$chapter'"
}

$this | Add-Member NoteProperty CurrentChapter $newChapter -Force
$this | Add-Member NoteProperty CurrentStep ($newStep - 1) -Force



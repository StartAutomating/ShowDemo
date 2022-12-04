$specialStepNameRegex = '^\s{0,}\<{0,1}\#\s{0,}\.(?<st>[\S]+)'
if ($this -notmatch $specialStepNameRegex) { return $null }
[PSCustomObject]@{
    StepType  = $matches.st
    Arguments = $this -replace $specialStepNameRegex
}
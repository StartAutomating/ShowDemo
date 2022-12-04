$stepTokens = [Management.Automation.PSParser]::Tokenize($this, [ref]$null)
foreach ($token in $stepTokens) {
    if ($token.Type -notin 'Comment', 'Newline') {
        return $false
    }
}
return $true
param($step)

$stepTokens = [Management.Automation.PSParser]::Tokenize($step, [ref]$null)
$PreviousToken = $null
foreach ($_ in $stepTokens) {   
    $content = $_.Content
    if ($_.Type -in 'Variable', 'String') {
        $content = $step.Substring($_.Start, $_.Length)
    }
    if ($PreviousToken) {
        $token = $_
        $prevEnd = $PreviousToken.Start + $PreviousToken.Length
        $substring = $step.Substring($prevEnd, $token.Start -  $prevEnd)
        if ($substring) {
            @{InputObject=$substring}
        }
    }
    
    if ($_.Type -eq 'Comment') {
        @{
            ForegroundColor='Success'
            InputObject = $content
        }
    }
    elseif ($_.Type -in 'Keyword', 'String', 'CommandArgument') {
        @{
            ForegroundColor='Verbose'
            InputObject = $Content
        }
    }
    elseif ($_.Type -in 'Variable', 'Command') {
        @{
            ForegroundColor='Warning'
            InputObject = $Content
        }   
    }
    elseif ($_.Type -in 'CommandParameter') {
        @{
            ForegroundColor='Magenta'
            InputObject = $Content
        }        
    }
    elseif (
        $_.Type -in 'Operator','GroupStart', 'GroupEnd'
    ) {
        @{
            ForegroundColor='Magenta'
            InputObject = $Content
        }
    }
    elseif (
        $_.Type -notin 'Comment', 
            'Keyword', 'String', 'CommandArgument',
            'Variable', 'Command',
            'CommandParameter',
            'Operator','GroupStart', 'GroupEnd'
    )  {
        @{
            ForegroundColor='Output'
            InputObject=$Content
        }
    } else {
        @{
            ForegroundColor='Output'
            InputObject=$Content
        }
    }
    $PreviousToken = $_
}
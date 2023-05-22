$text = $this.Text
$step = @()
$ThisChapterSteps = @()

# We want every step to be able to run independently.
# This would be untrue if the code is unbalanced when a chapter would start
# Thus, while we're primarily looking for comments, we also need to track groups
$groupDepth  = 0 
for ($tokenNumber =0 ; $tokenNumber -lt $this.Tokens.Length; $tokenNumber++) {
    $token = $this.tokens[$tokenNumber]
    # If the token is a group start
    if ($token.Type -eq 'GroupStart') 
    {
        $groupDepth++ # increment depth.
    }
    # If the token was a group end
    elseif ($token.Type -eq 'GroupEnd')
    {
        $groupDepth-- # decrement depth.
    }
    
    # and 
    
    elseif (                
        (-not $groupDepth) -and  # If there was no depth and            
        $token.StartColumn -le 1 -and # the token was a comment starting in the first column
        $token[-1].Type -ne 'Keyword' -and # and it wasn't preceeded by a keyword
        $token[0].Type -ne 'Keyword' -and # and it wasn't a keyword
        $token[0].Type -ne 'Newline' # and it wasn't a newline
    ) {
        # Then it's the start of a new step
        if ($step) {
            $stepEnd = $step[-1].Start + $step[-1].Length
            $stepStart = $step[0].Start
            # Get the content of the last step
            $stepScript = $text.Substring($stepStart, $stepEnd - $stepStart) -replace '^\s{0,}$'
            if ($stepScript) {
                # and make it into a PSObject
                $stepScript = [PSObject]::new($stepScript)
                # with the PSTypeName 'Demo.Step'
                $stepScript.pstypenames.add('Demo.Step')
                # and add the .Chapter property, pointing to $this
                $stepScript.psobject.properties.add([psnoteproperty]::new(
                    'Chapter',$this
                ))
                
                $ThisChapterSteps += $stepScript
            }
            # then reset the collection of tokens in the current step.
            $step = @()
        }        
    }

    # Add any token we see into the current step.
    $step += $token
}

# If there were any steps remaining
if ($step) {    
    $stepEnd = $step[-1].Start + $step[-1].Length
    $stepStart = $step[0].Start
    $stepScript = $text.Substring($stepStart, $stepEnd - $stepStart) -replace '^\s{0,}$'
    if ($stepScript) {
        # make them into 'Demo.Step' objects
        $stepScript = [PSObject]::new($stepScript)
        $stepScript.pstypenames.add('Demo.Step')
        $stepScript.psobject.properties.add([psnoteproperty]::new(
            'Chapter',$this
        )) # and add the chapter.
        $ThisChapterSteps += $stepScript
    }
}

# Force steps to be returned as a list.
,$ThisChapterSteps
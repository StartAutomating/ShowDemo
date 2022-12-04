function Import-Demo
{
    <#
    .SYNOPSIS
        Imports Demos
    .DESCRIPTION
        Imports a Demo script.
    .LINK
        Export-Demo
    .LINK
        Get-Demo
    .LINK
        Start-Demo
    .EXAMPLE
        Import-Demo -DemoPath .\demo.ps1
    #>
    param(
    # The path to the demo file.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='DemoFile')]
    [Alias('FullName', 'DemoFile', 'File', 'Source')]
    $DemoPath,

    # A Demo Script block.
    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName='DemoScript')]
    [ScriptBlock]
    $DemoScript
    )

    begin {
        $ChapterExpression = '^\s{0,}(?<cn>(?:\d+\.){1,})\s{0,}'
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'DemoFile') {
            $resolvedPath = 
                $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($demoPath)
            if (-not $resolvedPath) {
                return    
            }
            $fileInfo = Get-Item -Path $resolvedPath
            if (-not $fileInfo) { return }
            if ($fileInfo.Extension -in '.clixml', '.clix') {
                Import-Clixml $fileInfo.Extension
                return
            }
            if ($fileInfo.Extension -ne '.ps1') {
                return
            }
    
            $demoName    = $fileInfo.Name -replace '\.ps1$' -replace '\.demo$' -replace '\.walkthru$'
    
            $scriptCmd   = $ExecutionContext.SessionState.InvokeCommand.GetCommand($fileInfo.FullName, 'ExternalScript')
    
            $DemoScript = $scriptCmd.ScriptBlock
        }

        if (-not $DemoScript) { return }
        
        $astString   = "$DemoScript"
        $psTokens    = [Management.Automation.PSParser]::Tokenize($astString, [ref]$null)

        $chapters = @()
        $currentChapter = $null
        $chapterTokens  = @()

        # We want every step to be able to run independently.
        # This would be untrue if the code is unbalanced when a chapter would start
        # Thus, while we're primarily looking for comments, we also need to track groups
        $groupDepth  = 0 
        $previousToken = $null            
        # Walk thru every token in the file.
        foreach ($token in $psTokens) {
            Add-Member NoteProperty PreviousToken $previousToken -Force -InputObject $token
            Add-Member NoteProperty Text $astString -Force -InputObject $token
            $previousToken = $token
            if ($token.Type -in 'Variable', 'String') {
                $realContent = $astString.Substring($token.Start, $token.Length)
                Add-Member NoteProperty Content $realContent  -Force -InputObject $token
            }
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
            # If there was no depth
            # and the token was a comment starting in the first column.
            elseif (                
                (-not $groupDepth) -and            
                $token.Type -eq 'Comment' -and $token.StartColumn -le 1
            )
            {
                $tokenContent = $token.Content -replace '^#' -replace '#$'
                # Then it could be the start of a chapter.
                
                # If it is not,
                if ($tokenContent -notmatch $ChapterExpression) {
                    $chapterTokens += $token # add it to the current chapter.
                }
                
                # If the comment does start a chapter
                else {
                    # get the chapter number from `$matches`.
                    $chapterNumber = $matches.cn
                    # Then get the chapter name by replacing the regex.
                    $chapterName   = $tokenContent -replace $ChapterExpression
                    
                    # Create a new chapter, starting at the current token.
                    $newChapter = [Ordered]@{
                        Number   = $chapterNumber
                        Name     = $chapterName
                        Text     = $astString
                        Start    = $token.Start
                        DemoFile = $fileInfo.FullName
                    }
                    
                    # If there was already a current chapter
                    if ($currentChapter) {
                        # finalize it by marking it's end
                        $currentChapter.Length = 
                            $chapterTokens[-1].Start + $chapterTokens[-1].End - $currentChapter.Start
                        # and attaching the tokens we have so far.
                        $currentChapter.Tokens = $chapterTokens
                        $chapterTokens = @()
                        $chapters += $currentChapter
                    }

                    # Then, make the new chapter the current chapter
                    $currentChapter = $newChapter
                }
            }
            else
            {
                $chapterTokens += $token
            }
        }

        if ($currentChapter) {
            $currentChapter.Tokens = $chapterTokens            
            $chapterTokens = @()
            $chapters += $currentChapter
        } elseif ($chapterTokens) {            
            $chapters += [Ordered]@{
                Number = ''
                Name = ''            
                Tokens = $chapterTokens
                Text   = $astString
            }
        }
        
        $demoFile = [Ordered]@{
            PSTypeName = 'Demo'
            Name       = $demoName
            DemoFile   = $fileInfo.FullName
        }

        $demoFile.Chapters = @(
            foreach ($chapter in $chapters) {
                [PSCustomObject]([Ordered]@{PSTypeName='Demo.Chapter'} + $chapter)
            }
        )

        [PSCustomObject]$demoFile
    }
}


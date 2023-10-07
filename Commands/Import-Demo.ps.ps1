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
        Import-Demo -DemoName "Demo"
    #>    
    param(
    # The source of the demo.  This can be a string, file, command, module, or path.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='DemoFile')]
    [ValidateTypes(TypeName={
        [IO.FileInfo]
        [IO.DirectoryInfo]
        [Management.Automation.PathInfo]
        [Management.Automation.CommandInfo]
        [Management.Automation.PSModuleInfo]
        [string]
    })]
    [Alias('DemoPath','DemoName','DemoText','DemoScript','FullName', 'DemoFile', 'File', 'Source')]    
    [PSObject]
    $From    
    )

    begin {
        $ChapterExpression  = '^\s{0,}(?<cn>(?:\d+\.){1,})\s{0,}'
        $ValidDemoFile      = '(?>(?<=^demo)|\.demo)\.(?>ps1|clixml)$'
        if (-not $script:CachedDemos) {
            $script:CachedDemos = [Ordered]@{}
        }
        # If we have not initialized a cache and we're inside of a module
        if (-not $script:CachedDemos.Count -and $MyInvocation.MyCommand.ScriptBlock.Module) {
            # we'll need to import our own demos.
            # to ensure this only happens once, 
            $MyCmd = $MyInvocation.MyCommand
            $myDepth = 0
            foreach ($frame in Get-PSCallStack) { # we callstack peek 
                if ($frame.InvocationInfo.MyCommand.Name -eq "$MyCmd") {
                    $myDepth++ # and track our depth
                }
            }
            if ($myDepth -eq 1) { # and only import if we are one level deep.
                $MyModule = $MyInvocation.MyCommand.ScriptBlock.Module
                Import-Demo -From $MyModule | Out-Null
            }
        }
        
        # Next we declare a few internal functions.
        # Essentially, our import will boil down to a few possible scenarios:
        
        # The easy one is Importing a demo .clixml
        function Import-DemoClixml {
            if ($FromFileInfo -match '\.(clix|clixml)$') {
                return Import-Clixml -LiteralPath $FromFileInfo.FullName
            }
        }
        # The big one is Importing a demo from a script
        function Import-DemoScript {
            if (-not $FromScriptBlock) {
                return
            }
    
            $demoName = 
                if ($FromCommand) {
                    $FromCommand.Name -replace $ValidDemoFile
                } elseif ($FromFileInfo) {
                    $FromFileInfo.Name -replace $ValidDemoFile
                }
    
            $astString   = "$from"
            $psTokens    = [Management.Automation.PSParser]::Tokenize($astString, [ref]$null)
            if (-not $psTokens) { return }
    
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
                            DemoFile = $FromFileInfo.FullName
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
    
            # If we have a named chapter
            if ($currentChapter) {
                # add any remaining tokens to it.
                $currentChapter.Tokens = $chapterTokens
                $chapterTokens = @()
                # and add the chapter.
                $chapters += $currentChapter
            } elseif ($chapterTokens) {
                # Otherwise, if we have chapter tokens by no named chapter
                # create an empty chapter and add the steps to it.
                $chapters += [Ordered]@{
                    Number = ''
                    Name = ''
                    Tokens = $chapterTokens
                    Text   = $astString
                }
            }
    
            $demoScript = [scriptblock]::create($astString)
    
            # Create the demo object.
            $demoFile = [PSCustomObject][Ordered]@{
                PSTypeName = 'Demo'
                Name       = $demoName
                DemoFile   = $fileInfo.FullName
                DemoScript = $DemoScript
                DemoText   = "$DemoScript"
            }
    
    
            if ($demoFile.Name) {
                $script:CachedDemos[$demoFile.Name] = $demoFile
            }
    
            # And add each chapter to it
            $demoFile | 
                Add-Member NoteProperty Chapters @(
                    foreach ($chapter in $chapters) {
                        # linking back to the demo as we go (#57).
                        [PSCustomObject]([Ordered]@{PSTypeName='Demo.Chapter';Demo=$demoFile} + $chapter)
                    }
                ) -Force -PassThru # We -PassThru the modified object to return it.
        }
    }

    process {
        # Since -From can be many things, but a demo has to be a ScriptBlock,
        # the purpose of this function is to essentially resolve many things to one or more ScriptBlocks.        
        $fromModule, $FromDirectory, $FromCommand, $FromFileInfo, $fromScriptBlock = $null, $null,$null, $null, $null

        # If -From was a string
        if ($From -is [string]) {
            # It could be a module, so check those first.
            :ResolveFromString do {
                if ($from -match '\n') {
                    # If the -From had newlines, try to make a [ScriptBlock]
                    $fromScriptBlock = try { [ScriptBlock]::create($from) } catch { }
                    if ($fromScriptBlock) { break }
                }                

                foreach ($loadedModule in @(Get-Module)) {
                    # If we find the module, don't try to resolve -From as a path
                    break ResolveFromString
                        if ($loadedModule.Name -eq $from) {
                             # (just set -From again and let the function continue)
                            $from = $fromModule = $loadedModule
                        }
                }
                if ($script:CachedDemos["$From"]) {
                    $script:CachedDemos["$From"]
                } else {
                    # If we think from was a path
                    foreach ($resolvedPath in $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($from)) {
                        Import-Demo -From $resolvedPath                    
                    }
                }
                return
            } while ($false)
        }

        if ($From -is [Management.Automation.PSModuleInfo]) {        
            # then, make -From a directory
            if ($from.Path) {
                $from = Get-Item ($from.Path | Split-Path) -ErrorAction SilentlyContinue
            }
        }

        # If -From is a path
        if ($from -is [Management.Automation.PathInfo]) {
            $from = Get-Item -LiteralPath "$from" # turn it into a file or a directory
        }
        
        # If -From is a directory
        if ($from -is [IO.DirectoryInfo]) {
            $FromDirectory = $from
            # recursively call ourselves with all matching scripts
            Get-ChildItem -LiteralPath $from.FullName -Recurse -File |
                Where-Object Name -match $ValidDemoFile |
                Import-Demo
            return
        }
        
        # If -From is a file
        if ($from -is [IO.FileInfo]) {
            # set $FromFileInfo            
            $FromFileInfo = $from
            # and make -From a command.
            if ($from.Extension -eq '.ps1') {
                $from = $ExecutionContext.SessionState.InvokeCommand.GetCommand($from.FullName, 'ExternalScript')
            }
        }
        
        # If -From is a command
        if ($from -is [Management.Automation.CommandInfo]) {
            $FromCommand = $From
            # and it is an external script
            if ($from -is [Management.Automation.ExternalScriptInfo]) {
                # then use that script's contents as the source
                $FromScriptBlock = $from.ScriptBlock
                if (-not $FromFileInfo) {
                    $FromFileInfo = [IO.FileInfo]$from.Source
                } 
                $From = "$FromScriptBlock" # (stringified)
            }
            else {

                # Otherwise, see if it has help and examples
                $cmdHelp = Get-Help $from -ErrorAction Ignore
                if ($cmdHelp -and $cmdHelp.examples.example) {
                    # and make the demo the combined sequence of examples
                    $allExampleLines = @(
                        foreach ($example in $cmdHelp.Examples.example) {                        
                            $example.Code
                            foreach ($remark in $example.Remarks.text) {
                                if (-not $remark) { continue }
                                $remark
                            }                        
                        }
                    ) -join [Environment]::NewLine
                    try {
                        # at least, assuming we can convert it into a [ScriptBlock]
                        $From = $fromScriptBlock = [scriptblock]::create($allExampleLines)
                    } catch {
                        $ex = $_
                        Write-Error "Example in $from cannot be converted into a ScriptBlock"
                        return
                    }
                }
            }
        }
        

        if ($fromScriptBlock) {
            . Import-DemoScript
        }
        elseif ($FromFileInfo) {
            . Import-DemoClixml
        }        
    }
}


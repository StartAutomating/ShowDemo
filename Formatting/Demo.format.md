
###  


```PowerShell
Write-FormatView -TypeName Demo -Property Name, TotalSteps, Chapters -Wrap -VirtualProperty @{
    Chapters = {
        @(foreach ($chap in $_.Chapters) {
            $chap.Number + ' ' + $chap.Name
        }) -join [Environment]::NewLine
    }
}
```

```PowerShell
Write-FormatView -TypeName DemoViewer -Name DemoViewer -AsControl -Action {
    Write-FormatViewExpression -If {
        # If the demo has not started yet
        -not $_.DemoStarted
    } -ScriptBlock {
        $demo = $_
        # Start the demo.
        $demo.Start()
        
        # Then, create a message indicating we've started.
        $demoStartMessage = 
            Format-RichText -ForegroundColor Warning -InputObject (
                "Demo Started" +
                    ([Environment]::NewLine * 2)
            ) -Italic
        
        # If the demo is being run interactively,
        if ($demo.Interactive) {
            # write that message to the host.
            $demoStartMessage | Out-Host
            ""
        }
        # Otherwise, as long as we are not outputting markdown
        elseif (-not $demo.Markdown) {
            # output the demo started message.
            ($demoStartMessage -join '') + [Environment]::NewLine
        } else {
            ''
        }
    }
```

```PowerShell
Write-FormatViewExpression -If {
        # If the demo has started, is interactive, and not markdown
        $_.DemoStarted -and $_.Interactive -and -not $_.Markdown
    } {
        # attempt to to change the window title.
        $Duration = [DateTime]::Now - $_.DemoStarted
        $Host.UI.RawUI.WindowTitle = "{0}[{1}m, {2}s]        {2}" -f $_.Name, [int]$Duration.TotalMinutes, [int]$Duration.Seconds
        ""
    }
```

```PowerShell
Write-FormatViewExpression -If {
        # If we do not have a current chapter
        -not $_.CurrentChapter
    } -ScriptBlock {
        # pick the first chapter and modify the object.
        $firstChapter = $_.Chapters[0]
        $_ | Add-Member NoteProperty CurrentChapter $firstChapter  -Force
        $_ | Add-Member NoteProperty CurrentStep 0 -Force
        ""
    }
```

```PowerShell
Write-FormatViewExpression -If {
        # If we do not have a current step
        -not $_.CurrentStep
    } -ScriptBlock {
        # Start the chapter
        $_.StartChapter()
        $demo = $_
        # and get the first step
        $stepToRun = $demo.CurrentChapter.Steps[$demo.CurrentStep - 1]
```

```PowerShell
# while the step is hidden
        while ($stepToRun.HiddenStep) {
            $stepToRun.Invoke() # run it 
            $demo.NextStep()    # and move onto the next step.            
            $stepToRun = $demo.CurrentChapter.Steps[$demo.CurrentStep - 1]
        }
        
        # declare a chapter heading
        $chapterHeading =
            $demo.CurrentChapter.Number + 
                ' ' + 
                    $demo.CurrentChapter.Name + ([Environment]::NewLine * 2)
```

    

```PowerShell
# and get a rich text version of that heading
        $currentChapterText = 
            Format-RichText -ForegroundColor Verbose -InputObject (
                 $chapterHeading                    
            ) -Underline
        
        # If we are running interactively
        if ($_.Interactive) {
            # output that message now
            $currentChapterText | Out-Host
            ''
        } elseif ($demo.Markdown) {
            # otherwise, if we are generating markdown, 
            # determine the heading size.
            $headingSize = [int][math]::max($demo.HeadingSize, 3)
            # use Format-Markdown
            (Format-Markdown -HeadingSize $headingSize -InputObject $chapterHeading)
        } else {
            # if we are not running interactively, output the rich text from our formatter.
            ($currentChapterText -join '') + [Environment]::NewLine
        }      
        
    }
```

```PowerShell
Write-FormatViewExpression -If {
        # If there is a current step
        $_.CurrentStep
    } -ScriptBlock {
```

```PowerShell
$demo = $_
        # set step to run
        $stepToRun = $demo.CurrentChapter.Steps[$demo.CurrentStep - 1]
        
        # while the step is hidden
        while ($stepToRun.HiddenStep) {
            $stepToRun.Invoke() # run it 
            $demo.NextStep()    # and move onto the next step.            
            $stepToRun = $demo.CurrentChapter.Steps[$demo.CurrentStep - 1]
        }        
    }
```

```PowerShell
Write-FormatViewExpression -If {
        # If we still have a current step        
        $_.CurrentStep
    } -ScriptBlock {
        $demo = $_
        $stepToRun = $demo.CurrentChapter.Steps[$demo.CurrentStep - 1]
        # Update the object with it.
        $demo | Add-Member NoteProperty StepToRun $stepToRun -Force
        # If we are rendering markdown
        if ($demo.Markdown) {
            # and the step is a comment
            if ($stepToRun.IsComment) {
                # replace the comment start and end
                "$stepToRun" -replace '^\<{0,1}\#{1}' -replace '\#\>\s{0,}$'
```

```PowerShell
}
            # If the step was not a comment
            else
            {
                # Make it a PowerShell code block.
                [Environment]::NewLine  +
                    (Format-Markdown -InputObject $stepToRun.Trim() -CodeLanguage PowerShell) +
                        [Environment]::NewLine
```

```PowerShell
}
```

```PowerShell
# If we are outputting markdown, we're done with this formatting step.
            return
        }
```

```PowerShell
# If we are not outputting markdown, then let's figure out our real sleep
        $realSleep = 
            # If it's greater than a millisecond
            if ($demo.TypeSpeed.TotalMilliseconds -ge 1) {
                $demo.TypeSpeed # trust their input
            } elseif ($demo.TypeSpeed.Ticks) 
            {
                # Otherwise, try to convert from
                $letterPerMillisecond = 
                    ($demo.TypeSpeed.Ticks  * 6) # words per minute 
                        / (60 * 1000) # to milliseconds.
                [TimeSpan]::FromMilliseconds($letterPerMillisecond)
            } else {
                # otherwise, have no delay
                [timespan]0
            }
```

    

```PowerShell
# Now run over each segment of colorized output for the step
        $strOut = @(foreach ($output in $demo.ColorizeStep($stepToRun)) {
                $outputCopy = @{} + $output
                if ($output.InputObject) {
                    # Start off by setting the rich text formatting used for this sequence of tokens
                    $outputCopy.NoClear = $true
                    $outputCopy.InputObject = ''
                    # If we're running interactively, write that to the console now
                    if ($demo.Interactive) {
                        [Console]::Write((Format-RichText @outputCopy))
                    } else {
                        # otherwise, add it to $strOut.
                        Format-RichText @outputCopy
                    }
                    # Next, determine our chunks of output
                    $chunks =
                        # If we're going letter-by-letter
                        if ($demo.TypeStyle -eq 'Letters') {
                            # it's a character array.
                            "$($output.InputObject)".ToCharArray()
                        }
                        # If we're going word by word, 
                        elseif ($demo.TypeStyle -eq 'Words') {
                            # it's split next to each space.
                            "$($output.InputObject)" -split '(?=\s)'
                        }
                        # otherwise, just output the block
                        else{                            
                            "$($output.InputObject)"
                        }
                    
                    # Walk over each chunk of output
                    foreach ($chunk in $chunks)  {
                        if (-not $chunk) { continue }
                        # If running interactively,
                        if ($demo.Interactive) {
                            # write it to the console
                            [Console]::Write("$chunk")
                        } else {
                            # otherwise, add it to $strOut
                            $chunk
                        }
                        
                        # If we are running interactively, sleep.
                        if ($realSleep.Ticks -and $demo.Interactive) {
                            # (this gives us our typing effect)
                            $null = Start-Sleep -Milliseconds $realSleep.TotalMilliseconds
                        }
                    }
```

```PowerShell
# Now we need to do one more write to close the formatting
                    $null = $outputCopy.Remove('NoClear')
                    $outputCopy.InputObject = ' '
                    $output.InputObject = ''
                    # If we're running interactively
                    if ($demo.Interactive) {
                        # that goes to the console now.
                        [Console]::Write((Format-RichText @output) -join '')
                    } else {
                        (Format-RichText @output) -join ''
                    }
                }
            })
```

```PowerShell
# If we are running interactively
        if ($demo.Interactive) {
            '' # emit nothing from the formatter (since we've already written to the console)
        } else {
            # otherwise, emit the string.
            $strOut -join ''
        }                    
    }
```

```PowerShell
Write-FormatViewExpression -If {
        # If the demo is not done and it is interactive
        -not $_.DemoFinished -and $_.Interactive
    } -ScriptBlock {        
        $demo = $_
        # Read input        
        $hostInput = Read-Host
        # and the process it
        foreach ($output in $demo.ProcessInput($hostInput)) {
            # any output we want to display as a warning
            if ($output -is [string]) {
                Format-RichText -ForegroundColor Warning -InputObject $output | Out-Host
            }
            # unless it was a series of splats for Format-RichText
            elseif ($output -is [Collections.IDictionary]) {
                Format-RichText @output | Out-Host  # ( which we will run and output )
            }
            # or  a scriptblock.
            elseif ($output -is [scriptblock]) {
                . $output | Out-Host # (which we will run).
            }
        }
    
    }
```

```PowerShell
Write-FormatViewExpression -If {
        $_.StepToRun # If we have a StepToRun
    } -ScriptBlock {
        $demo = $_
        # Run it.
        if ($demo.Interactive) {            
            [Console]::WriteLine()            
            # If we're running interactively, pipe it out.
            Invoke-Expression $demo.StepToRun | Out-Host
        } 
        else{
            # Otherwise, pipe it to Out-String
            $stepOutput = Invoke-Expression $demo.StepToRun | Out-String -Width 1kb
            
            # If we're outputting markdown
            if ($demo.Markdown) {               
                # add a newline above and below
                [Environment]::NewLine + $(
                    @(
                        # If it looks like a tag
                        if ($stepOutput -match '^\<') {
                            $stepOutput # include without indentation
                        } else {
                            # Otherwise, indent 4 chars so it is seen as preformatted text.
                            foreach ($line in @($stepOutput -split '(?>\r\n|\n)')) {
                                (' ' * 4) + $line
                            }
                        }
                    ) -join [Environment]::NewLine
                ) +
                [Environment]::NewLine
            } else {
                [Environment]::NewLine + $stepOutput
            }            
        }
    }
```

```PowerShell
Write-FormatViewExpression -If {
        # If we had a step to run
        $_.StepToRun -and 
            (-not $_.DemoFinished) -and # and the demo's not done
            (-not $_.StepToRun.IsComment) -and # and the step is not a comment
            $_.Interactive # and we're running interactively
    } -ScriptBlock {
        $demo = $_
        
        # Prompt and process again
        $hostInput = Read-Host
        foreach ($output in $demo.ProcessInput($hostInput)) {
            if ($output -is [string]) {
                Format-RichText -ForegroundColor Warning -InputObject $output | Out-Host
            }
            elseif ($output -is [Collections.IDictionary]) {
                Format-RichText @output | Out-Host
            }
            elseif ($output -is [scriptblock]) {
                . $output | Out-Host
            }
        }
    }
```

```PowerShell
Write-FormatViewExpression -If {
        # If we had a current step
        $_.CurrentStep
    } -ScriptBlock {
        # Advanced to the next step
        $_.NextStep()
    }
    
    Write-FormatViewExpression -If {
        -not $_.DemoFinished # If the demo was not finished
    } -ControlName DemoViewer -ScriptBlock {
        # recursively call this formatter
        $_
    }
```

```PowerShell
Write-FormatViewExpression -If {
        # If the demo is finished
        $_.DemoFinished
    } -ScriptBlock {
        $demo = $_
        # figure out how long it took
        $duration = $_.DemoFinished - $_.DemoStarted
        # change the status
        $demo.SetStatus('Finished')
        # and prepare a message.
        $finishedMessage = 
            Format-RichText -InputObject (
                "Demo $($demo.Status) {0} Minutes and {1} Seconds" -f [int]$duration.TotalMinutes, [int]$duration.Seconds
            )  -ForegroundColor Warning -Italic
        
        # If the demo was interactive
        if ($demo.Interactive) {
            # writ the message
            $finishedMessage | Out-Host
            # and if we had a nested prompt, exit it
            if ($NestedPromptLevel) {
                $host.ExitNestedPrompt()
            }
        } elseif (-not $demo.Markdown) {
            $finishedMessage -join ''            
        }
        
        # Last but not least, reset the demo.
        $demo.Reset()
    }
}
```

```PowerShell
Write-FormatView -TypeName Demo -Action {
    Write-FormatViewExpression -ScriptBlock {
        # set a script variable to contain the current demo
        $ExecutionContext.SessionState.PSVariable.Set('script:currentDemo',$_)
    }
    Write-FormatViewExpression -ScriptBlock {
        $_ # display the demo using the DemoViewer control
    } -ControlName DemoViewer
    
    Write-FormatViewExpression -ScriptBlock {
        # unset a script variable
        $ExecutionContext.SessionState.PSVariable.Set('script:currentDemo',$null)
    }
}
```




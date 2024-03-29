Write-FormatView -TypeName Demo -Property Name, TotalSteps, Chapters -Wrap -VirtualProperty @{
    Chapters = {
        @(foreach ($chap in $_.Chapters) {
            $chap.Number + ' ' + $chap.Name
        }) -join [Environment]::NewLine
    }
}

Write-FormatView -TypeName DemoViewer -Name DemoViewer -AsControl -Action {
    Write-FormatViewExpression -If {
        # If the demo has not started yet
        -not $_.DemoStarted
    } -ScriptBlock {
        $demo = $_
    
        if ($demo.RecordDemo) {
            $startRecordingCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Start-Recording','Function,Alias')
            if ($startRecordingCommand) {                
                $null = Start-Recording
            } else {
                Write-Warning "Start-Recording was not found.  Have you installed/imported obs-powershell?"                
            }
        }
    
        # Start the demo.
        $demo.Start()
        
        # Then, create a message indicating we've started.
        if ($demo.StartMessage) {
            $demoStartMessage = 
                Format-RichText -ForegroundColor Warning -InputObject (
                    $demo.StartMessage +
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

        if ($demo.Interactive) {
            [Console]::OutputEncoding = $OutputEncoding
        }
    }

    Write-FormatViewExpression -If {
        # If the demo has started, is interactive, and not markdown
        $_.DemoStarted -and $_.Interactive -and -not $_.Markdown
    } {
        # attempt to to change the window title.
        $Duration = [DateTime]::Now - $_.DemoStarted
        $Host.UI.RawUI.WindowTitle = "{0}[{1}m, {2}s]        {2}" -f $_.Name, [int]$Duration.TotalMinutes, [int]$Duration.Seconds
        ""
    }


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

    Write-FormatViewExpression -If {
        # If we do not have a current step
        -not $_.CurrentStep
    } -ScriptBlock {
        # Start the chapter
        $_.StartChapter()
        $demo = $_
        # and get the first step
        $stepToRun = $demo.CurrentChapter.Steps[$demo.CurrentStep - 1]

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

        $ChapterHeadingSplat = [Ordered]@{ForegroundColor='Verbose';InputObject=$chapterHeading;Underline=$true}
        # and get a rich text version of that heading
        $null = New-Event -SourceIdentifier Demo.WriteChapterName -Sender $demo -MessageData ([Ordered]@{} + $ChapterHeadingSplat)
        $currentChapterText = 
            Format-RichText @ChapterHeadingSplat
        
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

    Write-FormatViewExpression -If {
        # If there is a current step
        $_.CurrentStep
    } -ScriptBlock {

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

    Write-FormatViewExpression -If {
        $_.StepToRun -and 
        $_.ShowPrompt -and
        (-not $_.DemoFinished)                           
    } -ScriptBlock {
        $promptOutput = prompt
        $null = New-Event -SourceIdentifier Demo.WritePrompt -Sender $demo -MessageData $promptOutput
        if ($_.Interactive) {
            $promptOutput | Out-Host
        } # and we're running interactively
        else {            
            $promptOutput | Out-String            
        }
    }

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
                ("$stepToRun" -replace '^\<{0,1}\#{1}' -replace '\#\>\s{0,}$').Trim()
            }
            # If the step was not a comment
            else
            {
                # Make it a PowerShell code block.
                [Environment]::NewLine  +
                    (Format-Markdown -InputObject $stepToRun.Trim() -CodeLanguage PowerShell) +
                        [Environment]::NewLine

            }

            # If we are outputting markdown, we're done with this formatting step.
            return
        }

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

        # Now run over each segment of colorized output for the step
        $strOut = @(foreach ($output in $demo.ShowStep($stepToRun)) {
                $outputCopy = @{} + $output
                if ($output.InputObject) {
                    # Start off by setting the rich text formatting used for this sequence of tokens
                    $null = New-Event -SourceIdentifier Demo.WriteStep -Sender $demo -MessageData ([Ordered]@{} + $output)
                    $outputCopy.NoClear = $true
                    $outputCopy.InputObject = ''
                    # If we're running interactively, write that to the console now
                    if ($demo.Interactive) {
                        [Console]::Write((Format-RichText @outputCopy) -join '')
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

        # If we are running interactively
        if ($demo.Interactive) {
            '' # emit nothing from the formatter (since we've already written to the console)
        } else {
            # otherwise, emit the string.
            $strOut -join ''
        }                    
    }

    Write-FormatViewExpression -If {
        # If the demo is not done and it is interactive
        -not $_.DemoFinished -and $_.Interactive -and -not $_.AutoPlay
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

    Write-FormatViewExpression -If {
        $_.StepToRun # If we have a StepToRun
    } -ScriptBlock {
        $demo = $_
        # Run it.
        $DemoStepOutput = $null
        
        if ($PSStyle) {
            $PSStyle.OutputRendering = 'ANSI'
        }

        if ($demo.Interactive) {
            [Console]::WriteLine()
            if ($demo.PauseBetweenLine) {
                # If we're running interactively, pipe it out.
                $DemoStepOutput = @(Invoke-Expression -Command $demo.StepToRun *>&1 |
                    Out-String) -split '(?>\r\n|\n)'
                foreach ($demoOutputLine in $DemoStepOutput) {
                    Start-Sleep -Milliseconds $demo.PauseBetweenLine.TotalMilliseconds
                    Write-Host $demoOutputLine                    
                }
            } else {
                # If we're running interactively, pipe it out.
                Invoke-Expression -Command $demo.StepToRun *>&1 |
                    Out-String -OutVariable DemoStepOutput |
                    Out-Host
            }            
        } 
        else{
            # Otherwise, pipe it to Out-String
            $stepOutput = 
                Invoke-Expression -Command $demo.StepToRun *>&1 |
                    Out-String -Width 1kb -OutVariable DemoStepOutput 
            
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

        if ($DemoStepOutput) {
            $null = New-Event -SourceIdentifier Demo.WriteOutput -Sender $demo -EventArguments $demo.StepToRun -MessageData $DemoStepOutput
        }
    }

    Write-FormatViewExpression -If {
        # If we had a step to run
        $_.StepToRun -and 
            (-not $_.DemoFinished) -and # and the demo's not done
            (-not $_.StepToRun.IsComment) -and # and the step is not a comment
            (-not $_.Autoplay) -and # and we're not autoplaying
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

    Write-FormatViewExpression -If {
        $_.Autoplay
    } -ScriptBlock {
        Start-Sleep -Milliseconds $_.PauseBetweenStep.TotalMilliseconds
    }

    
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

    Write-FormatViewExpression -If {
        # If the demo is finished
        $_.DemoFinished
    } -ScriptBlock {
        $demo = $_
        # figure out how long it took
        $duration = $_.DemoFinished - $_.DemoStarted
        # change the status
        $demo.SetStatus('Finished')
        if ($demo.RecordDemo) {
            $stopRecording = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Stop-Recording', 'Alias,Function')
            if ($stopRecording) {
                $recordingOutputFile = Stop-Recording
                $newRecordingName    = "$($demo.Name).$($demo.DemoStarted.ToString('s') -replace ':', '-')$($recordingOutputFile.Extension)"
                if ($recordingOutputFile) {
                    try {                        
                        Copy-Item $recordingOutputFile.FullName -Destination ($recordingOutputFile.FullName | Split-Path | Join-Path -ChildPath $newRecordingName )
                    } catch {
                        Write-Warning "Could not copy $($recordingOutputFile) to $($demo.Name): $($_ | Out-String)"
                    }
                }
            }
        }
        # and prepare a message.
        if ($demo.EndMessage) {
            $finishedMessage = 
                Format-RichText -InputObject (
                    $demo.EndMessage -f [int]$duration.TotalMinutes, [int]$duration.Seconds
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
        }
        
        
        # Last but not least, reset the demo.
        $demo.Reset()
    }
}

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


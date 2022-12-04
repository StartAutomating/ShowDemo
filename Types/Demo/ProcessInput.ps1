param($hostInput)
$demo = $this
switch ($hostInput) {
    '?' {
        @{
            ForegroundColor = 'Cyan'
            InputObject = @"
Running demo: $($demo.Name)
(q) Quit
(# ...) Goto Chapter/Step
(f ...) Find cmds using X
(t) Timecheck
(s) Skip
(!) Debug Demo
(d) Dump demo
"@
        }
    }
    'q' {
        $demo.Stop()
    }
    'd' {
        $demoDump = $demo.Dump()
        $demoDump | Out-Host
        if (Get-Command Set-Clipboard -ErrorAction SilentlyContinue) {
            $demoDump | Set-Clipboard
        }        
    }
    's' {
        $demo | Add-Member NoteProperty StepToRun $null -Force
    }
    't' {
        $duration = [Datetime]::now - $demo.DemoStarted
        @{
            ForegroundColor = 'Warning'
            Italic = $true
            InputObject = 
                "{0} {1} [{2}m, {3}s]" -f $demo.Name, $demo.Status, [int]$Duration.TotalMinutes, [int]$Duration.Seconds
        }
    }
    '!' {
        Write-Warning "Debugging Demo:  Use Resume-Demo to resume."
        $host.EnterNestedPrompt()
        
    }
    default {
        
        if ($hostInput -match '^\s{0,}\#\s{0,}\d') {
            $demo | Add-Member NoteProperty StepToRun $null -Force
            $demo.SetChapter($hostInput -replace '^\s{0,}\#\s{0,}')
        }
        elseif ($hostInput -match '^\s{0,}(?>f|/)\s{0,}\S') {
            $toFind = $hostInput -replace '^\s{0,}(?>f|/)\s{0,}'
            Select-String -Path $demo.DemoFile -Pattern $toFind | Out-Host
            {}
        }
    }        
}

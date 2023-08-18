function Show-Demo
{
    <#
    .SYNOPSIS
        Shows a Demo
    .DESCRIPTION
        Shows a PowerShell Demo Script.
    .EXAMPLE
        Show-Demo
    .LINK
        Get-Demo
    #>
    [Alias('Start-Demo')]
    [CmdletBinding(DefaultParameterSetName='LoadedDemos')]
    param(
    # The name of the demo
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='LoadedDemos')]
    [string]
    $DemoName,

    # The path to the demo file.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='DemoFile')]
    [Alias('FullName', 'DemoFile', 'File', 'Source')]
    $DemoPath,

    # A Demo Script block.
    [Parameter(Mandatory,ValueFromPipeline,ParameterSetName='DemoScript')]
    [scriptblock]
    $DemoScript,

    # The name of the chapter
    [string]
    $Chapter,

    # The current step (within -Chapter)
    [ValidateRange(1,10000)]
    [int]
    $Step,

    # The typing style.  Can be letters, words, or none.
    [ValidateSet('Letters','Words','None')]
    [string]
    $TypeStyle = 'Letters',

    # If this is an integer less than 10000, it will be considered 'words per minute'
    # Otherwise, this will be the timespan to wait between words / letters being displayed.
    [timespan]
    $TypeSpeed,

    # The amount of time to wait between each step.
    # If provided, implies -AutoPlay.
    [Alias('PauseBetweenSteps')]
    [timespan]
    $PauseBetweenStep,

    # If set, will automatically play demos.
    # Use -PauseBetweenStep to specify how long to wait between each step.
    [switch]
    $AutoPlay,

    # If set, will make the demo noniteractive.
    [switch]
    $NonInteractive,

    # If set, will show the prompt between each step.
    # This can also be enabled or disabled within a demo, with .ShowPrompt or .HidePrompt
    [switch]
    $ShowPrompt,

    # If set, will attempt to record the demo.
    # This presumes that [obs-powershell](https://github.com/StartAutomating/obs-powershell) is installed.
    [switch]
    $Record,

    # If provided, will set the message displayed at demo start.
    [string]
    $StartMessage,
    
    # If provided, will set the message displayed at demo start.
    [string]
    $EndMessage
    )

    process {
        $demoFile =
            if ($DemoPath) {
                Get-Demo -DemoPath $DemoPath
            }
            elseif ($DemoScript) {
                Get-Demo -DemoScript $DemoScript
            }
            elseif ($DemoName) {
                Get-Demo -DemoName $DemoName
            }
            else {
                $allDemos = Get-Demo
                $justNamedDemo = $allDemos |
                    Where-Object Name -eq 'Demo' |
                    Select-Object -First 1
                if (-not $justNamedDemo) {
                    $allDemos | Select-Object -First 1
                } else {
                    $justNamedDemo
                }
            }

        if (-not $demoFile) {
            Write-Error "No demo to show"
        }

        $demoFile | Add-Member StartMessage $StartMessage -Force
        $demoFile | Add-Member EndMessage $EndMessage -Force

        if ($chapter) {
            $demoFile | Add-Member CurrentChapter $Chapter -Force
        }
        if ($step) {
            $demoFile | Add-Member CurrentStep $step -Force
        }

        if ($Record) {            
            $demoFile | Add-Member RecordDemo $true -Force
        }

        if ($ShowPrompt) {
            $demoFile | Add-Member ShowPrompt $true -Force
        }

        $demoFile | Add-Member TypeStyle $TypeStyle -Force
        if ($TypeStyle -eq 'Letters' -and -not $TypeSpeed) {
            $TypeSpeed = [timespan]::FromMilliseconds(1)
        }
        elseif ($TypeStyle -eq 'Words' -and -not $TypeSpeed) {
            $TypeSpeed = [timespan]::FromMilliseconds(30)
        }
        $demoFile | Add-Member TypeSpeed $TypeSpeed -Force

        
        if ($NonInteractive -or
            ($Host.Name -eq 'Default Host') -or
            $env:BUILD_ID -or
            $env:GITHUB_WORKSPACE
        ) {
            $demoFile | Add-Member Interactive $false -Force
        } else {
            $demoFile | Add-Member Interactive $true -Force
        }

        if ($AutoPlay -or $PauseBetweenStep.TotalMilliseconds) {
            if (-not $PauseBetweenStep.TotalMilliseconds) {
                $PauseBetweenStep = [timespan]::FromMilliseconds(500)
            }
            $demoFile | Add-Member Autoplay $true -Force
            $demoFile | Add-Member PauseBetweenStep $PauseBetweenStep -Force
        }

        if ($NonInteractive) {
            $demoFile | Format-Custom | Out-String -Width 1mb
        } else {
            $demoFile | Format-Custom
        }        
    }
}

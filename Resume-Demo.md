
###  


```PowerShell
function Resume-Demo
{
    <#
    .SYNOPSIS
        Resumes a Demo
    .DESCRIPTION
        Resumes a Demo that was paused or debugged with `!`.
    .EXAMPLE
        Resume-Demo
    .LINK
        Show-Demo
    .LINK
        Get-Demo
    #>
    param(
    # The demo that will be resumed.
    [Parameter(ValueFromPipeline)]
    [PSTypeName('Demo')]
    $DemoToResume
    )
```

```PowerShell
process {
        if (-not $DemoToResume -and $demo) {
            $DemoToResume = $demo
        }
        if (-not $DemoToResume) {
            Write-Error "No demo to resume"
            return
        }
        $DemoToResume | Format-Custom
    }
}
```




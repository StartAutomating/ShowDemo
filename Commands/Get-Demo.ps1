function Get-Demo {
    <#
    .SYNOPSIS
        Gets Demos
    .DESCRIPTION
        Gets PowerShell Demos.
        Demos located in ShowDemo and all modules that tag ShowDemo will be automatically discovered.
    .LINK
        Import-Demo
    .EXAMPLE
        Get-Demo
    #>
    [CmdletBinding(DefaultParameterSetName='LoadedDemos')]
    param(
    # The source of the demo.  This can be a string, file, command, module, or path.
    [Parameter(Mandatory,ParameterSetName='DemoFile',ValueFromPipelineByPropertyName)]
    [Alias('DemoPath','DemoName','DemoScript','FullName', 'DemoFile', 'File', 'Source')]    
    [PSObject]
    $From
    )
    
    process {
        if ($from) {
            Import-Demo -From $from
        } elseif ($script:CachedDemos.Count) {
            $script:CachedDemos.Values
        }
    }
}


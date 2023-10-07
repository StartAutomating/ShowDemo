function Get-Demo
{
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
    [vbn(Mandatory,ParameterSetName='DemoFile')]
    [Alias('DemoPath','DemoName','DemoScript','FullName', 'DemoFile', 'File', 'Source')]    
    [PSObject]
    $From
    )

    begin {
        $myModule = $MyInvocation.MyCommand.ScriptBlock.Module
        if ($myModule) {
            Import-Demo -From $myModule
        }
    }

    process {
        if ($from) {
            Import-Demo -From $from
        } elseif ($script:CachedDemos.Count) {
            $script:CachedDemos.Values
        }
    }
}

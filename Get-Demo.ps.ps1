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
    $DemoScript
    )

    begin {
        $myModule = $MyInvocation.MyCommand.ScriptBlock.Module
    }

    process {
        if ($PSCmdlet.ParameterSetName -in 'DemoFile', 'DemoScript') {
            Import-Demo @psboundParameters
            return
        }

        $filePaths =
            @(            
            $pwd
            if ($myModule) {
                $moduleRelationships = [ModuleRelationships()]$myModule
                foreach ($relationship in $moduleRelationships) {
                    $relationship.RelatedModule | Split-Path
                }
            } else {
                $PSScriptRoot
            }
            )

        $allDemoFiles =
            all scripts in $filePaths that {
                $_.Name -match '^(?>demo|walkthru)\.ps1$' -or
                $_.Name -match '\.(?>demo|walkthru)\.ps1$'
            } are demofiles

        $allDemoFiles |
            Where-Object Name -like "*$demoName*" |
            Import-Demo
    }
}

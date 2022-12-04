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
        $ChapterExpression = '^\s(?<cn>(?:\d+\.){1,})\s{0,}'
    }
    process {
        if ($PSCmdlet.ParameterSetName -in 'DemoFile', 'DemoScript') {
            Import-Demo @psboundParameters
            return
        }
        $myModule = $MyInvocation.MyCommand.ScriptBlock.Module
        $filePaths = 
            if ($myModule) {
                $moduleRelationships = 
                                       @(
                                       $MyModuleName, $myModule = 
                                           if ($myModule -is [string]) {
                                               $myModule, (Get-Module $myModule)
                                           } elseif ($myModule -is [Management.Automation.PSModuleInfo]) {
                                               $myModule.Name, $myModule
                                           } else {
                                               Write-Error "$myModule must be a [string] or [Management.Automation.PSModuleInfo]"    
                                           }
                                       #region Search for Module Relationships
                                       if ($myModule -and $MyModuleName) {
                                           foreach ($loadedModule in Get-Module) { # Walk over all modules.
                                               if ( # If the module has PrivateData keyed to this module
                                                   $loadedModule.PrivateData.$myModuleName
                                               ) {
                                                   # Determine the root of the module with private data.            
                                                   $relationshipData = $loadedModule.PrivateData.$myModuleName
                                                   [PSCustomObject][Ordered]@{
                                                       PSTypeName     = 'Module.Relationship'
                                                       Module        = $myModule
                                                       RelatedModule = $loadedModule
                                                       PrivateData   = $loadedModule.PrivateData.$myModuleName
                                                   }
                                               }
                                               elseif ($loadedModule.PrivateData.PSData.Tags -contains $myModuleName) {
                                                   [PSCustomObject][Ordered]@{
                                                       PSTypeName     = 'Module.Relationship'
                                                       Module        = $myModule
                                                       RelatedModule = $loadedModule
                                                       PrivateData   = @{}
                                                   }
                                               }
                                           }
                                       }
                                       #endregion Search for Module Relationships
                                       )
                                       
                foreach ($relationship in $moduleRelationships) {
                    $relationship.RelatedModule | Split-Path
                }
            } else {
                $PSScriptRoot
            }
        $allDemoFiles = 
            $(
            # Collect all items into an input collection
            $inputCollection =$(
            $executionContext.SessionState.InvokeCommand.GetCommands('*','Script',$true)
            ),
               $(($PSScriptRoot |
                & { process {
                    $inObj = $_
                    if ($inObj -is [Management.Automation.CommandInfo]) {
                        $inObj
                    }
                    elseif ($inObj -is [IO.FileInfo] -and $inObj.Extension -eq '.ps1') {
                        $ExecutionContext.SessionState.InvokeCommand.GetCommand($inObj.Fullname, 'ExternalScript')
                    }
                    elseif ($inObj -is [string] -or $inObj -is [Management.Automation.PathInfo]) {
                        $resolvedPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($inObj)
                        if ($resolvedPath) {
                            $pathItem = Get-item -LiteralPath $resolvedPath
                            if ($pathItem -is [IO.FileInfo] -and $pathItem.Extension -eq '.ps1') {
                                $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                            } else {                    
                                foreach ($pathItem in @(Get-ChildItem -LiteralPath $pathItem -File -Recurse)) {
                                    if ($pathItem.Extension -eq '.ps1') {
                                        $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                                    }
                                }
                            }
                        }            
                    }
                } }
            ))
            # 'unroll' the collection by iterating over it once.
            $filteredCollection = $inputCollection =
                @(foreach ($in in $inputCollection) {
                    $in
                })
            # Since filtering conditions have been passed, we must filter item-by-item
            $filteredCollection = :nextItem foreach ($item in $inputCollection) {
                # we set $this, $psItem, and $_ for ease-of-use.
                $this = $_ = $psItem = $item
             
                # Some of the items may be variables.
                if ($item -is [Management.Automation.PSVariable]) {
                    # In this case, reassign them to their value.
                    $this = $_ = $psItem = $item = $item.Value
                }
                
                # Some of the items may be enumerables
                $unrolledItems = 
                    if ($item.GetEnumerator -and $item -isnot [string]) {
                        @($item.GetEnumerator())
                    } else {
                        $item
                    }
                foreach ($item in $unrolledItems) {
                    $this = $_ = $psItem = $item
                    if (-not $(
                            $_.Name -match '^(?>demo|walkthru)\.ps1$' -or
                            $_.Name -match '\.(?>demo|walkthru)\.ps1$'
                        
                    )) { continue } 
                    $item
                }
                
                
            }
            # Walk over each item in the filtered collection
            foreach ($item in $filteredCollection) {
                # we set $this, $psItem, and $_ for ease-of-use.
                $this = $_ = $psItem = $item
            if ($item.value -and $item.value.pstypenames.insert) {
                if ($item.value.pstypenames -notcontains 'demofiles') {
                    $item.value.pstypenames.insert(0, 'demofiles')
                }
            }
            elseif ($item.pstypenames.insert -and $item.pstypenames -notcontains 'demofiles') {
                $item.pstypenames.insert(0, 'demofiles')
            }
            $item
                        
            }   
            )
        $allDemoFiles |
            Where-Object Name -like "*$demoName*" |
            Import-Demo
    }
}


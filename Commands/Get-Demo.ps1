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
        $myModule = $MyInvocation.MyCommand.ScriptBlock.Module
    }
    process {
        if ($PSCmdlet.ParameterSetName -in 'DemoFile', 'DemoScript') {
            Import-Demo @psboundParameters
            return
        }
        $filePaths =
            @(
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
            )
        $allDemoFiles =
            @($(
                      # Collect all items into an input collection
                      $inputCollection = @(($filePaths |& {
                      param([switch]$IncludeApplications)
                      process {
                      $inObj = $_
                      # Since we're looking for commands, pass them thru directly
                      if ($inObj -is [Management.Automation.CommandInfo]) {
                          $inObj
                      }
                      # If the input object is ps1 fileinfo 
                      elseif ($inObj -is [IO.FileInfo] -and $inObj.Extension -eq '.ps1') {
                          # get that exact command.
                          $ExecutionContext.SessionState.InvokeCommand.GetCommand($inObj.Fullname, 'ExternalScript')
                      }
                      # If the input is a string or path        
                      elseif ($pathItem -is [IO.FileInfo] -and $IncludeApplications) {
                          $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'Application')
                      }
                      elseif ($inObj -is [string] -or $inObj -is [Management.Automation.PathInfo]) {
                          # resolve it
                          foreach ($resolvedPath in $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath("$inObj")) {
                              # and get the literal item
                              $pathItem = Get-item -LiteralPath $resolvedPath
                              # if it is a .ps1 fileinfo
                              if ($pathItem -is [IO.FileInfo] -and $pathItem.Extension -eq '.ps1') {
                                  # get that exact command
                                  $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                              } 
                              elseif ($pathItem -is [IO.FileInfo] -and $IncludeApplications) {
                                  $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'Application')
                              }
                              elseif ($pathItem -is [IO.DirectoryInfo]) {
                                  # Otherwise, get all files beneath the path
                                  foreach ($pathItem in @(Get-ChildItem -LiteralPath $pathItem -File -Recurse)) {
                                      # that are .ps1
                                      if ($pathItem.Extension -eq '.ps1') {
                                          # and return them directly.
                                          $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                                      }
                                      elseif ($IncludeApplications) {
                                          $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'Application')
                                      }
                                  }
                              }
                          }
                      }
                  } }))
              # Since filtering conditions have been passed, we must filter item-by-item
              $filteredCollection = :nextItem foreach ($item in $inputCollection) {
                  # we set $this, $psItem, and $_ for ease-of-use.
                  $this = $_ = $psItem = $item 
                   
                      
                  if (-not $(
                              
                              $_.Name -match '^(?>demo|walkthru)\.ps1$' -or
                              $_.Name -match '\.(?>demo|walkthru)\.ps1$'
                          
                          )) { continue nextItem } 
                  
                  $item
                  
                  
              }
              # Walk over each item in the filtered collection
              foreach ($item in $filteredCollection) {
                  # we set $this, $psItem, and $_ for ease-of-use.
                  $this = $_ = $psItem = $item
                  
              if ($item.pstypenames.insert -and $item.pstypenames -notcontains 'demofiles') {
                  $item.pstypenames.insert(0, 'demofiles')
              }
                  $item 
              }   
              ))
        if ($filePaths -ne $pwd) {
            $currentDirectoryDemos = 
                Get-ChildItem -Filter *.ps1 -Path $pwd |
                Where-Object {
                    $_.Name -match '^(?>demo|walkthru)\.ps1$' -or
                    $_.Name -match '\.(?>demo|walkthru)\.ps1$'
                }
        
            $allDemoFiles += @(
                $(
                        # Collect all items into an input collection
                        $inputCollection = @(($currentDirectoryDemos |& {
                        param([switch]$IncludeApplications)
                        process {
                        $inObj = $_
                        # Since we're looking for commands, pass them thru directly
                        if ($inObj -is [Management.Automation.CommandInfo]) {
                            $inObj
                        }
                        # If the input object is ps1 fileinfo 
                        elseif ($inObj -is [IO.FileInfo] -and $inObj.Extension -eq '.ps1') {
                            # get that exact command.
                            $ExecutionContext.SessionState.InvokeCommand.GetCommand($inObj.Fullname, 'ExternalScript')
                        }
                        # If the input is a string or path        
                        elseif ($pathItem -is [IO.FileInfo] -and $IncludeApplications) {
                            $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'Application')
                        }
                        elseif ($inObj -is [string] -or $inObj -is [Management.Automation.PathInfo]) {
                            # resolve it
                            foreach ($resolvedPath in $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath("$inObj")) {
                                # and get the literal item
                                $pathItem = Get-item -LiteralPath $resolvedPath
                                # if it is a .ps1 fileinfo
                                if ($pathItem -is [IO.FileInfo] -and $pathItem.Extension -eq '.ps1') {
                                    # get that exact command
                                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                                } 
                                elseif ($pathItem -is [IO.FileInfo] -and $IncludeApplications) {
                                    $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'Application')
                                }
                                elseif ($pathItem -is [IO.DirectoryInfo]) {
                                    # Otherwise, get all files beneath the path
                                    foreach ($pathItem in @(Get-ChildItem -LiteralPath $pathItem -File -Recurse)) {
                                        # that are .ps1
                                        if ($pathItem.Extension -eq '.ps1') {
                                            # and return them directly.
                                            $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'ExternalScript')
                                        }
                                        elseif ($IncludeApplications) {
                                            $ExecutionContext.SessionState.InvokeCommand.GetCommand($pathItem.FullName, 'Application')
                                        }
                                    }
                                }
                            }
                        }
                    } }))
                # Walk over each item in the filtered collection
                foreach ($item in $inputCollection) {
                    # we set $this, $psItem, and $_ for ease-of-use.
                    $this = $_ = $psItem = $item
                    
                if ($item.pstypenames.insert -and $item.pstypenames -notcontains 'demofiles') {
                    $item.pstypenames.insert(0, 'demofiles')
                }
                    $item 
                }   
                )
            )
        }
        
        $allDemoFiles |
            Where-Object Name -like "*$demoName*" |
            Import-Demo
    }
}


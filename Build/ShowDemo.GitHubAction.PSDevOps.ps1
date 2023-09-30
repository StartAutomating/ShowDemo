#requires -Module PSDevOps
#requires -Module ShowDemo
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubWorkflow

Push-Location ($PSScriptRoot | Split-Path)
New-GitHubAction -Name "DemoPowerShell" -Description @'
Make Demos of your PowerShell projects.
'@ -Action DemoPowerShell -Icon terminal -OutputPath .\action.yml
Pop-Location
#requires -Module PSDevOps
#requires -Module ShowDemo
Import-BuildStep -ModuleName ShowDemo
New-GitHubAction -Name "DemoPowerShell" -Description @'
Make Demos of your PowerShell projects.
'@ -Action DemoPowerShell -Icon terminal -OutputPath .\action.yml
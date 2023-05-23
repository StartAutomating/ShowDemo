
#requires -Module PSDevOps
#requires -Module ShowDemo
#requires -Module GitPub

Import-BuildStep -Module ShowDemo

Push-Location $PSScriptRoot

New-GitHubWorkflow -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, BuildShowDemo -OutputPath @'
.\.github\workflows\BuildShowDemo.yml
'@ -Name "Build, Test, and Release ShowDemo" -On Push, PullRequest

Pop-Location


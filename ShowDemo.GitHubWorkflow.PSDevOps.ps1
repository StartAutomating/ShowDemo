
#requires -Module PSDevOps
#requires -Module ShowDemo
#requires -Module GitPub

Import-BuildStep -Module ShowDemo

Push-Location $PSScriptRoot

New-GitHubWorkflow -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, BuildShowDemo -OutputPath @'
.\.github\workflows\BuildShowDemo.yml
'@ -Name "Build, Test, and Release ShowDemo" -On Push, PullRequest

Import-BuildStep -ModuleName GitPub

New-GitHubWorkflow -On Issue, Demand -Job RunGitPub -Name GitPub -OutputPath @'
.\.github\workflows\GitPub.yml
'@

Pop-Location


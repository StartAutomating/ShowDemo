
###  

requires -Module PSDevOps

    
requires -Module ShowDemo

    

```PowerShell
Import-BuildStep -Module ShowDemo
```

```PowerShell
Push-Location $PSScriptRoot
```

    

```PowerShell
New-GitHubWorkflow -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, BuildShowDemo -OutputPath @'
.\.github\workflows\BuildShowDemo.yml
'@ -Name "Build, Test, and Release ShowDemo" -On Push, PullRequest
```

```PowerShell
Pop-Location
```

    





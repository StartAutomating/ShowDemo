
#requires -Module PSDevOps
#requires -Module ShowDemo
#requires -Module GitPub

Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubWorkflow

Push-Location ($PSScriptRoot | Split-Path)

New-GitHubWorkflow -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, BuildShowDemo -OutputPath @'
.\.github\workflows\BuildShowDemo.yml
'@ -Name "Build, Test, and Release ShowDemo" -On Push, PullRequest -Env ([Ordered]@{
    "AT_PROTOCOL_HANDLE" = "mrpowershell.bsky.social"
    "AT_PROTOCOL_APP_PASSWORD" = '${{ secrets.AT_PROTOCOL_APP_PASSWORD }}'
    "REGISTRY" = "ghcr.io"
    "IMAGE_NAME" = '${{ github.repository }}'
})

Import-BuildStep -ModuleName GitPub

New-GitHubWorkflow -On Demand -Job RunGitPub -Name GitPub -OutputPath @'
.\.github\workflows\GitPub.yml
'@

New-GitHubWorkflow -On Demand -Name 'show-demo-psa' -Job SendPSA -OutputPath .\.github\workflows\SendPSA.yml  -Env @{
    "AT_PROTOCOL_HANDLE" = "mrpowershell.bsky.social"
    "AT_PROTOCOL_APP_PASSWORD" = '${{ secrets.AT_PROTOCOL_APP_PASSWORD }}'
}

Pop-Location


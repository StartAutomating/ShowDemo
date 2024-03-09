@{
    Author           = 'James Brundage'
    CompanyName      = 'Start-Automating'
    Copyright        = '2022-2024 Start-Automating'
    Description      = 'A simple tool to showcase your scripts.'
    Guid             = 'c4516317-f99e-44cf-b138-d8c4d1eadf66'
    ModuleVersion    = '0.1.6'
    RootModule       = 'ShowDemo.psm1'
    FormatsToProcess = 'ShowDemo.format.ps1xml'
    TypesToProcess   = 'ShowDemo.types.ps1xml'        
    PrivateData      = @{
        PSData       = @{
            Tags         = 'PowerShell', 'Demo', 'ShowDemo'
            ProjectURI   = 'https://github.com/StartAutomating/ShowDemo'
            LicenseURI   = 'https://github.com/StartAutomating/ShowDemo/blob/main/LICENSE'
            ReleaseNotes = @'
## ShowDemo 0.1.6:

* Show-Demo Syncing Console Encoding ( Fixes #101 )
* Show-Demo -PauseBetweenLine(s) ( Fixes #100 )
* Adjusting Default Type Speed ( Fixes #97 )
* Showing unknown steps in White, not Output ( Fixes #99 )

---

Previous release notes in [CHANGELOG](https://github.com/StartAutomating/ShowDemo/blob/main/CHANGELOG.md)

Like It?  [Star It](https://github.com/StartAutomating/ShowDemo)!  Love It?  [Support It](https://github.com/sponsors/StartAutomating)!
'@
            Recommendation = 'obs-powershell', 'Posh'
        }
  }
}

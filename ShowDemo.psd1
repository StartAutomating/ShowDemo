@{
    Author           = 'James Brundage'
    CompanyName      = 'Start-Automating'
    Copyright        = '2022-2024 Start-Automating'
    Description      = 'A simple tool to showcase your scripts.'
    Guid             = 'c4516317-f99e-44cf-b138-d8c4d1eadf66'
    ModuleVersion    = '0.1.7'
    RootModule       = 'ShowDemo.psm1'
    FormatsToProcess = 'ShowDemo.format.ps1xml'
    TypesToProcess   = 'ShowDemo.types.ps1xml'        
    PrivateData      = @{
        PSData       = @{
            Tags         = 'PowerShell', 'Demo', 'ShowDemo'
            ProjectURI   = 'https://github.com/StartAutomating/ShowDemo'
            LicenseURI   = 'https://github.com/StartAutomating/ShowDemo/blob/main/LICENSE'
            ReleaseNotes = @'
## ShowDemo 0.1.7:

* ShowDemo in Docker (#103)
  * Added Dockerfile (#104)
  * Publishing all builds to GitHub Container Registry (#105)
* Added Trinity of Discoverability Demo (#51)
* Exporting $ShowDemo (#106)
* Mounting as ShowDemo: (#107)

---
            
Full history in [CHANGELOG](https://github.com/StartAutomating/ShowDemo/blob/main/CHANGELOG.md)

> Like It? [Star It](https://github.com/StartAutomating/ShowDemo)
> Love It? [Support It](https://github.com/sponsors/StartAutomating)
'@
            Recommendation = 'obs-powershell', 'Posh'
        }
  }
}

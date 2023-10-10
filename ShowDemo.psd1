@{
    Author           = 'James Brundage'
    CompanyName      = 'Start-Automating'
    Copyright        = '2022-2023 Start-Automating'
    Description      = 'A simple tool to showcase your scripts.'
    Guid             = 'c4516317-f99e-44cf-b138-d8c4d1eadf66'
    ModuleVersion    = '0.1.5'
    RootModule       = 'ShowDemo.psm1'
    FormatsToProcess = 'ShowDemo.format.ps1xml'
    TypesToProcess   = 'ShowDemo.types.ps1xml'        
    PrivateData      = @{
        PSData       = @{
            Tags         = 'PowerShell', 'Demo', 'ShowDemo'
            ProjectURI   = 'https://github.com/StartAutomating/ShowDemo'
            LicenseURI   = 'https://github.com/StartAutomating/ShowDemo/blob/main/LICENSE'
            ReleaseNotes = @'
## ShowDemo 0.1.5:

* Demos are now more eventful (#66)
  * Nearly every part of ShowDemo transmits PowerShell engine events
  * These can be used for highly customized display of demos
* Refactoring all *-Demo commands to use a single -From parameter (#86)
* Added Logo (#90)
* Integrated PSA (#91)

---

Previous release notes in [CHANGELOG](https://github.com/StartAutomating/ShowDemo/blob/main/CHANGELOG.md)

Like It?  Star It!  Love It?  Support It!
'@
            Recommendation = 'obs-powershell', 'Posh'
        }
  }
}

@{
    Author           = 'James Brundage'
    CompanyName      = 'Start-Automating'
    Copyright        = '2022 Start-Automating'
    Description      = 'A simple tool to showcase your scripts.'
    Guid             = 'c4516317-f99e-44cf-b138-d8c4d1eadf66'
    ModuleVersion    = '0.1'
    RootModule       = 'ShowDemo.psm1'
    FormatsToProcess = 'ShowDemo.format.ps1xml'
    TypesToProcess   = 'ShowDemo.types.ps1xml'        
    PrivateData      = @{
        PSData       = @{
            Tags         = 'PowerShell', 'Demo', 'ShowDemo'
            ProjectURI   = 'https://github.com/StartAutomating/ShowDemo'
            LicenseURI   = 'https://github.com/StartAutomating/ShowDemo/blob/main/LICENSE'
            ReleaseNotes = @'
## ShowDemo 0.1 

Initial Release of Show-Demo.

* List Demos with Get-Demo
* Show Demos with Show-Demo
* Export Demos with Export-Demo.
* ShowDemo GitHub Action

'@
        }
  }
}

@{
    Author           = 'James Brundage'
    CompanyName      = 'Start-Automating'
    Copyright        = '2022-2023 Start-Automating'
    Description      = 'A simple tool to showcase your scripts.'
    Guid             = 'c4516317-f99e-44cf-b138-d8c4d1eadf66'
    ModuleVersion    = '0.1.3'
    RootModule       = 'ShowDemo.psm1'
    FormatsToProcess = 'ShowDemo.format.ps1xml'
    TypesToProcess   = 'ShowDemo.types.ps1xml'        
    PrivateData      = @{
        PSData       = @{
            Tags         = 'PowerShell', 'Demo', 'ShowDemo'
            ProjectURI   = 'https://github.com/StartAutomating/ShowDemo'
            LicenseURI   = 'https://github.com/StartAutomating/ShowDemo/blob/main/LICENSE'
            ReleaseNotes = @'
## ShowDemo 0.1.3:

* Adding support for prompts in demos
  * Demo.Step - Adding .ShowPrompt()/HidePrompt() (#54/#55)
  * Demo Formatting - Supporting ShowPrompt (#56)
  * Show-Demo - Adding -ShowPrompt (#53)
  * Import-Demo - Linking Chapters (#57)
* Partitioning repository (#48, #49, #50)

---

## ShowDemo 0.1.2:

* Get-Demo - Skipping $pwd if in $filePaths (Fixes #43)
* Show-Demo - Adding -Record (Fixes #42)
* Import-Demo - Including .DemoScript (Fixes #44)
* Adding Demo.ToMarkdown (Fixes #45)

---

## ShowDemo 0.1.1:

* Show-Demo now supports -AutoPlay/-PauseBetweenStep (#39)
* Export-Demo - Defaults to English when invariant culture (Fixes #37)
* Improvements in how steps are determined (#35 #36)
* Please Sponsor ShowDemo (#38)

---

## ShowDemo 0.1:

Initial Release of Show-Demo.

* List Demos with Get-Demo
* Show Demos with Show-Demo
* Export Demos with Export-Demo.
* ShowDemo GitHub Action

'@
        }
  }
}

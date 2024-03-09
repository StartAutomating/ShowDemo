## ShowDemo 0.1.6:

* Show-Demo Syncing Console Encoding ( Fixes #101 )
* Show-Demo -PauseBetweenLine(s) ( Fixes #100 )
* Adjusting Default Type Speed ( Fixes #97 )
* Showing unknown steps in White, not Output ( Fixes #99 )

---

## ShowDemo 0.1.5:

* Demos are now more eventful (#66)
  * Nearly every part of ShowDemo transmits PowerShell engine events
  * These can be used for highly customized display of demos
* Refactoring all *-Demo commands to use a single -From parameter (#86)
* Added Logo (#90)
* Integrated PSA (#91)

---

## ShowDemo 0.1.4:
                        
* ShowDemo - Adding Recommendations (Fixes #63)
* Demo Format - Honoring .StartMessage/.EndMessage (Fixes #62)
* Show-Demo - Adding -StartMessage/-EndMessage (Fixes #61)

---

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

## ShowDemo 0.1.1

* Show-Demo now supports -AutoPlay/-PauseBetweenStep (#39)
* Export-Demo - Defaults to English when invariant culture (Fixes #37)
* Improvements in how steps are determined (#35 #36)
* Please Sponsor ShowDemo (#38)

---

## ShowDemo 0.1 

Initial Release of Show-Demo.

* List Demos with Get-Demo
* Show Demos with Show-Demo
* Export Demos with Export-Demo.
* ShowDemo GitHub Action


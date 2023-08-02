#requires -Module HelpOut
Push-Location ($PSScriptRoot | Split-Path)
Import-Module .\ShowDemo.psd1
Save-MarkdownHelp -Module ShowDemo -PassThru
Pop-Location
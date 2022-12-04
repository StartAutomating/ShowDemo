describe ShowDemo {
    it 'Shows Demos' {
        $showedADemo = Show-Demo -NonInteractive 
        $showedADemo | Should -match '\e\[' # and it had an escape sequence for color
    }

    it 'Can export a demo as markdown' {
        $exportedDemo = Export-Demo -DemoPath .\demo.ps1 -OutputPath .\demo.md
        $exportedDemo.Extension | Should -be '.md'
        $exportedContent = Get-Content $exportedDemo.FullName -Raw
        $exportedContent | Should -BeLike '*###*1.*'
        $exportedContent | Should -BeLike '*Learn*PowerShell*'
    }
}

describe ShowDemo {
    it 'Shows Demos' {
        $showedADemo = Show-Demo -NonInteractive 
        $showedADemo | Should -match '\e\[' # and it had an escape sequence for color
    }
}

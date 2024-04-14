[Include('*-*.ps1')]$PSScriptRoot

$thisModule = $MyInvocation.MyCommand.ScriptBlock.Module
$thisModule.pstypenames.insert(0, $thisModule.Name)
$ExecutionContext.SessionState.PSVariable.Set($thisModule.Name, $thisModule)

$newDriveSplat = [ordered]@{
    Name = $thisModule.Name
    PSProvider = 'FileSystem'
    Root = $PSScriptRoot
    ErrorAction = 'Ignore'
}

New-PSDrive @newDriveSplat

Export-ModuleMember -Variable $thisModule.Name  -Function * -Alias *
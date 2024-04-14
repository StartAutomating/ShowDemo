[Include('*-*.ps1')]$PSScriptRoot

$thisModule = $MyInvocation.MyCommand.ScriptBlock.Module
$ExecutionContext.SessionState.PSVariable.Set($thisModule.Name, $thisModule)

Export-ModuleMember -Variable $thisModule.Name  -Function * -Alias *
:ToIncludeFiles foreach ($file in (Get-ChildItem -Path "$PSScriptRoot" -Filter "*-*.ps1" -Recurse)) {
    if ($file.Extension -ne '.ps1')      { continue }  # Skip if the extension is not .ps1
    foreach ($exclusion in '\.[^\.]+\.ps1$') {
        if (-not $exclusion) { continue }
        if ($file.Name -match $exclusion) {
            continue ToIncludeFiles  # Skip excluded files
        }
    }     
    . $file.FullName
}

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

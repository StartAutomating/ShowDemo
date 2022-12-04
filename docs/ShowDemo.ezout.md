
###  

requires -Module EZOut

    
  Install-Module EZOut or https://github.com/StartAutomating/EZOut

    

```PowerShell
$myFile = $MyInvocation.MyCommand.ScriptBlock.File
```

    

```PowerShell
$myModuleName = 'ShowDemo'
```

    

```PowerShell
$myRoot = $myFile | Split-Path
```

```PowerShell
Push-Location $myRoot
```

    

```PowerShell
$formatting = @(
    # Add your own Write-FormatView here,
    # or put them in a Formatting or Views directory
    foreach ($potentialDirectory in 'Formatting','Views') {
        Join-Path $myRoot $potentialDirectory |
            Get-ChildItem -ea ignore |
            Import-FormatView -FilePath {$_.Fullname}
    }
)
```

```PowerShell
$destinationRoot = $myRoot
```

    

```PowerShell
if ($formatting) {
    $myFormatFile = Join-Path $destinationRoot "$myModuleName.format.ps1xml"
    $formatting | Out-FormatData -Module $MyModuleName | Set-Content $myFormatFile -Encoding UTF8
    Get-Item $myFormatFile
}
```

    

```PowerShell
$types = @(
    # Add your own Write-TypeView statements here
    # or declare them in the 'Types' directory
    Join-Path $myRoot Types |
        Get-Item -ea ignore |
        Import-TypeView
```

```PowerShell
)
```

```PowerShell
if ($types) {
    $myTypesFile = Join-Path $destinationRoot "$myModuleName.types.ps1xml"
    $types | Out-TypeData | Set-Content $myTypesFile -Encoding UTF8
    Get-Item $myTypesFile
}
```

    

```PowerShell
Pop-Location
```

    





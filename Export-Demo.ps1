function Export-Demo
{
    <#
    .SYNOPSIS
        Exports Demos
    .DESCRIPTION
        Exports a Demo.
        
        Demos can be saved to a Markdown (.md) file or a Clixml (.clixml/.clix)file
    .EXAMPLE
        Export-Demo -DemoPath .\demo.ps1 -OutputPath .\demo.md
    #>
    param(
    # The path to the demo file.
    [Parameter(Mandatory,
        ValueFromPipelineByPropertyName,
        ParameterSetName='DemoFile')]
    [Alias('FullName', 'DemoFile', 'File', 'Source')]
    $DemoPath,

    # The output path.  This is the location the demo will be saved to.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [ValidatePattern('\.(?>clixml|clix|md)$')]
    [Alias('OutputFile')]
    [string]
    $OutputPath
    )

    begin {
        $extensionPattern = '\.(?>ps1|clixml|clix|md|html)$'

        # In order to make Markdown demos render correctly, we need to override Write-Host
        # (in case the demo Writes to the host)
        function Write-Host {
    <#
    .ForwardHelpTargetName Write-Host
    .ForwardHelpCategory Cmdlet
    #>

    [CmdletBinding()]
    [OutputType([Nullable])]
    param(    
    [Parameter(Position=0, ValueFromPipeline=$true, ValueFromRemainingArguments=$true)]
    [System.Object]
    ${Object},

    [Switch]
    ${NoNewline},

    [System.Object]
    ${Separator},

    [System.ConsoleColor]
    ${ForegroundColor},

    [System.ConsoleColor]
    ${BackgroundColor}
    )
    process {
        #region Override Write-Host for inside of the demo
        if ($demo) {
            # Write as HTML
            $objectHtml = $Object
            
            $styleChunk = if ($ForegroundColor -or $backgroundColor)  {
                if ($ForegroundColor -and $backgroundcolor) {
                    " style='color:${ForeGroundColor};background=${BackgroundColor}'"
                } else {
                    if ($ForegroundColor) {
                        " style='color:${ForeGroundColor}'"
                    } else {
                        " style='background=${BackgroundColor}'"
                    }
                }
            } else {
                ""
            }
            $tag = "span"
            "<${tag}${styleChunk}>${ObjectHtml}</${tag}>$(if (-not $NoNewLine) {'<br/>'})"
        } else {
            # If we're not in a web site...
            Microsoft.PowerShell.Utility\Write-Host @psboundParameters
        }
        #endregion Override Write-Host for web context
    }
} 

    }
    process {
        $demoContents = Get-Demo -File $DemoPath
        if (-not $demoContents) { return }
        
        if ($OutputPath -notmatch $extensionPattern) {
            Write-Error "Invalid Extension"
            return
        }
        $extension = $matches.0
        $unresolvedOutput = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputPath)
        if ($extension -in '.clixml', '.clix') {
            Export-Clixml -LiteralPath $unresolvedOutput -InputObject $demoContents
            
            Get-Item -LiteralPath $unresolvedOutput |
                Add-Member NoteProperty SourceFile $demoContents.DemoFile -Force -PassThru
        }
        elseif ($extension -eq '.md') {
            $demoContents | Add-Member NoteProperty Markdown $true -Force
            $demoContents | Add-Member NoteProperty Interactive $false -Force
            $demoContents | 
                Format-Custom | 
                Out-String -Width 1mb |
                Set-Content -LiteralPath $unresolvedOutput -Encoding UTF8
            
            Get-Item -LiteralPath $unresolvedOutput |
                Add-Member NoteProperty SourceFile $demoContents.DemoFile -Force -PassThru
        }
    }
}

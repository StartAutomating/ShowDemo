# We don't want to modify this object
$demoCopy = # so create a copy
    if ($this.DemoFile) { # by importing the file
        Import-Demo -DemoPath $this.DemoFile
    } elseif ($this.DemoScript) { # or the script block.
        Import-Demo -DemoPath $this.DemoScript
    }

# We need Write-Host to be overridden in the same way as Export-Demo does.
# So find Export-Demo's Abstract Syntax Tree
$exportDemoAst = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Export-Demo','Function').ScriptBlock.Ast.Body
# and find our inner function
$writeHost     = $exportDemoAst.Find({param($ast)
    $ast.Name -eq 'Write-Host' -and $ast.IsFilter -eq $false
}, $false)
# And override it here
${function:Write-Host} = $writeHost.Body.GetScriptBlock()

# Now, modify our demo copy to make it non-interactive
$demoCopy | Add-Member NoteProperty Interactive $false -Force 
# and markdown
$demoCopy | Add-Member NoteProperty Markdown $true -Force
# then use the formatter to get the markdown as a string.
$demoCopy | 
    Format-Custom | 
    Out-String -Width 1mb
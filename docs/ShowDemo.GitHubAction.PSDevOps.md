
###  

requires -Module PSDevOps

    
requires -Module ShowDemo

    

```PowerShell
Import-BuildStep -ModuleName ShowDemo
```

```PowerShell
New-GitHubAction -Name "DemoPowerShell" -Description @'
Make Demos of your PowerShell projects.
'@ -Action DemoPowerShell -Icon terminal -OutputPath .\action.yml
```





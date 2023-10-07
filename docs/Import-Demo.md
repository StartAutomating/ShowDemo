Import-Demo
-----------




### Synopsis
Imports Demos



---


### Description

Imports a Demo script.



---


### Related Links
* [Export-Demo](Export-Demo.md)



* [Get-Demo](Get-Demo.md)



* [Start-Demo](Start-Demo.md)





---


### Examples
> EXAMPLE 1

```PowerShell
Import-Demo -DemoName "Demo"
```


---


### Parameters
#### **From**

The source of the demo.  This can be a string, file, command, module, or path.






|Type        |Required|Position|PipelineInput        |Aliases                                                                                        |
|------------|--------|--------|---------------------|-----------------------------------------------------------------------------------------------|
|`[PSObject]`|true    |named   |true (ByPropertyName)|DemoPath<br/>DemoName<br/>DemoText<br/>DemoScript<br/>FullName<br/>DemoFile<br/>File<br/>Source|





---


### Syntax
```PowerShell
Import-Demo -From <PSObject> [<CommonParameters>]
```

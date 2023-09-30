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
Import-Demo -DemoPath .\demo.ps1
```


---


### Parameters
#### **DemoPath**

The path to the demo file.






|Type      |Required|Position|PipelineInput        |Aliases                                  |
|----------|--------|--------|---------------------|-----------------------------------------|
|`[Object]`|true    |named   |true (ByPropertyName)|FullName<br/>DemoFile<br/>File<br/>Source|



#### **DemoScript**

A Demo Script block.






|Type           |Required|Position|PipelineInput |
|---------------|--------|--------|--------------|
|`[ScriptBlock]`|true    |named   |true (ByValue)|





---


### Syntax
```PowerShell
Import-Demo -DemoPath <Object> [<CommonParameters>]
```
```PowerShell
Import-Demo -DemoScript <ScriptBlock> [<CommonParameters>]
```

Get-Demo
--------




### Synopsis
Gets Demos



---


### Description

Gets PowerShell Demos.
Demos located in ShowDemo and all modules that tag ShowDemo will be automatically discovered.



---


### Related Links
* [Import-Demo](Import-Demo.md)





---


### Examples
> EXAMPLE 1

```PowerShell
Get-Demo
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
Get-Demo [<CommonParameters>]
```
```PowerShell
Get-Demo -From <PSObject> [<CommonParameters>]
```

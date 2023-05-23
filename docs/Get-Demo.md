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
#### EXAMPLE 1
```PowerShell
Get-Demo
```



---


### Parameters
#### **DemoName**

The name of the demo






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



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
Get-Demo [-DemoName <String>] [<CommonParameters>]
```
```PowerShell
Get-Demo -DemoPath <Object> [<CommonParameters>]
```
```PowerShell
Get-Demo -DemoScript <ScriptBlock> [<CommonParameters>]
```

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



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DemoPath**

The path to the demo file.



> **Type**: ```[Object]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DemoScript**

A Demo Script block.



> **Type**: ```[ScriptBlock]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByValue)



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
---

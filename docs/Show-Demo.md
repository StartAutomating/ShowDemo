Show-Demo
---------
### Synopsis
Shows a Demo

---
### Description

Shows a PowerShell Demo Script.

---
### Related Links
* [Get-Demo](Get-Demo.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Show-Demo
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
#### **Chapter**

The name of the chapter



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **Step**

The current step (within -Chapter)



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **TypeStyle**

The typing style.  Can be letters, words, or none.



Valid Values:

* Letters
* Words
* None



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **TypeSpeed**

If this is an integer less than 10000, it will be considered 'words per minute'
Otherwise, this will be the timespan to wait between words / letters being displayed.



> **Type**: ```[TimeSpan]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **NonInteractive**

If set, will make the demo noniteractive.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Show-Demo [-DemoName <String>] [-Chapter <String>] [-Step <Int32>] [-TypeStyle <String>] [-TypeSpeed <TimeSpan>] [-NonInteractive] [<CommonParameters>]
```
```PowerShell
Show-Demo -DemoPath <Object> [-Chapter <String>] [-Step <Int32>] [-TypeStyle <String>] [-TypeSpeed <TimeSpan>] [-NonInteractive] [<CommonParameters>]
```
```PowerShell
Show-Demo -DemoScript <ScriptBlock> [-Chapter <String>] [-Step <Int32>] [-TypeStyle <String>] [-TypeSpeed <TimeSpan>] [-NonInteractive] [<CommonParameters>]
```
---

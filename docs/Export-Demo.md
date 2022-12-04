Export-Demo
-----------
### Synopsis
Exports Demos

---
### Description

Exports a Demo.

Demos can be saved to a Markdown (.md) file or a Clixml (.clixml/.clix)file

---
### Examples
#### EXAMPLE 1
```PowerShell
Export-Demo -DemoPath .\demo.ps1 -OutputPath .\demo.md
```

---
### Parameters
#### **DemoPath**

The path to the demo file.



> **Type**: ```[Object]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **OutputPath**

The output path.  This is the location the demo will be saved to.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
### Syntax
```PowerShell
Export-Demo -DemoPath <Object> -OutputPath <String> [<CommonParameters>]
```
---

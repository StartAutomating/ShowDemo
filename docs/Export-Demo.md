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
> EXAMPLE 1

```PowerShell
Export-Demo -DemoPath .\demo.ps1 -OutputPath .\demo.md
```


---


### Parameters
#### **DemoPath**

The path to the demo file.






|Type      |Required|Position|PipelineInput        |Aliases                                  |
|----------|--------|--------|---------------------|-----------------------------------------|
|`[Object]`|true    |named   |true (ByPropertyName)|FullName<br/>DemoFile<br/>File<br/>Source|



#### **OutputPath**

The output path.  This is the location the demo will be saved to.






|Type      |Required|Position|PipelineInput        |Aliases   |
|----------|--------|--------|---------------------|----------|
|`[String]`|true    |named   |true (ByPropertyName)|OutputFile|





---


### Syntax
```PowerShell
Export-Demo -DemoPath <Object> -OutputPath <String> [<CommonParameters>]
```

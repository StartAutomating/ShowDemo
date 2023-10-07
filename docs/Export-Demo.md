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
#### **From**

The source of the demo.  This can be a string, file, command, module, or path.






|Type        |Required|Position|PipelineInput        |Aliases                                                                                        |
|------------|--------|--------|---------------------|-----------------------------------------------------------------------------------------------|
|`[PSObject]`|true    |named   |true (ByPropertyName)|DemoPath<br/>DemoName<br/>DemoText<br/>DemoScript<br/>FullName<br/>DemoFile<br/>File<br/>Source|



#### **OutputPath**

The output path.  This is the location the demo will be saved to.






|Type      |Required|Position|PipelineInput        |Aliases   |
|----------|--------|--------|---------------------|----------|
|`[String]`|true    |named   |true (ByPropertyName)|OutputFile|





---


### Syntax
```PowerShell
Export-Demo -From <PSObject> -OutputPath <String> [<CommonParameters>]
```

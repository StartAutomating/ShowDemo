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



#### **Chapter**

The name of the chapter






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



#### **Step**

The current step (within -Chapter)






|Type     |Required|Position|PipelineInput|
|---------|--------|--------|-------------|
|`[Int32]`|false   |named   |false        |



#### **TypeStyle**

The typing style.  Can be letters, words, or none.



Valid Values:

* Letters
* Words
* None






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



#### **TypeSpeed**

If this is an integer less than 10000, it will be considered 'words per minute'
Otherwise, this will be the timespan to wait between words / letters being displayed.






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[TimeSpan]`|false   |named   |false        |



#### **NonInteractive**

If set, will make the demo noniteractive.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |





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

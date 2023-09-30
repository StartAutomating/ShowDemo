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
> EXAMPLE 1

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



#### **PauseBetweenStep**

The amount of time to wait between each step.
If provided, implies -AutoPlay.






|Type        |Required|Position|PipelineInput|Aliases          |
|------------|--------|--------|-------------|-----------------|
|`[TimeSpan]`|false   |named   |false        |PauseBetweenSteps|



#### **AutoPlay**

If set, will automatically play demos.
Use -PauseBetweenStep to specify how long to wait between each step.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **NonInteractive**

If set, will make the demo noniteractive.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **ShowPrompt**

If set, will show the prompt between each step.
This can also be enabled or disabled within a demo, with .ShowPrompt or .HidePrompt






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **Record**

If set, will attempt to record the demo.
This presumes that [obs-powershell](https://github.com/StartAutomating/obs-powershell) is installed.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **StartMessage**

If provided, will set the message displayed at demo start.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



#### **EndMessage**

If provided, will set the message displayed at demo start.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |





---


### Syntax
```PowerShell
Show-Demo [-DemoName <String>] [-Chapter <String>] [-Step <Int32>] [-TypeStyle <String>] [-TypeSpeed <TimeSpan>] [-PauseBetweenStep <TimeSpan>] [-AutoPlay] [-NonInteractive] [-ShowPrompt] [-Record] [-StartMessage <String>] [-EndMessage <String>] [<CommonParameters>]
```
```PowerShell
Show-Demo -DemoPath <Object> [-Chapter <String>] [-Step <Int32>] [-TypeStyle <String>] [-TypeSpeed <TimeSpan>] [-PauseBetweenStep <TimeSpan>] [-AutoPlay] [-NonInteractive] [-ShowPrompt] [-Record] [-StartMessage <String>] [-EndMessage <String>] [<CommonParameters>]
```
```PowerShell
Show-Demo -DemoScript <ScriptBlock> [-Chapter <String>] [-Step <Int32>] [-TypeStyle <String>] [-TypeSpeed <TimeSpan>] [-PauseBetweenStep <TimeSpan>] [-AutoPlay] [-NonInteractive] [-ShowPrompt] [-Record] [-StartMessage <String>] [-EndMessage <String>] [<CommonParameters>]
```

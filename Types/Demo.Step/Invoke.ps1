<#
.SYNOPSIS
    Invokes a demo step
.DESCRIPTION
    Invokes a step in a demo file.
#>
$hiddenStep = $this.HiddenStep

$invokeResults = 
    if (-not $hiddenStep) {
        Invoke-Expression $this
    } elseif ($this.$($hiddenStep.StepType).Invoke) {
        $this.$($hiddenStep.StepType).Invoke($hiddenStep.Arguments)
    }
$invokeResults
$null = New-Event -SourceIdentifier Demo.Step.Invoke -Sender $this -EventArguments $args -MessageData $invokeResults

$hiddenStep = $this.HiddenStep

if (-not $hiddenStep) {
    Invoke-Expression $this
} elseif ($this.$($hiddenStep.StepType).Invoke) {
    $this.$($hiddenStep.StepType).Invoke($hiddenStep.Arguments)
}
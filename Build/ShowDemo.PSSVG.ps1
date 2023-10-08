#requires -Module PSSVG
Push-Location ($psScriptRoot | Split-Path)
$powerShellChevron = Invoke-RestMethod https://pssvg.start-automating.com/Examples/PowerShellChevron.svg   
$assetsPath = Join-Path $pwd Assets
$scaleMin = 1
$scaleMax = 1.02


$FontSplat = [Ordered]@{
    FontFamily = "sans-serif" 
}

$φ = (1.0 + [Math]::Sqrt(5))/2

$AnimateSplat = [Ordered]@{
    Dur = 60/128*8
    AttributeName = 'font-size'
    Values = "${scaleMin}em;${scaleMax}em;${scaleMin}em"
    RepeatCount = 'indefinite'
}

$AnimateSplat2 = [Ordered]@{} + $AnimateSplat
$AnimateSplat2.Values = "${scaleMax}em;${scaleMin}em;${scaleMax}em"

if (-not (Test-path $assetsPath)) {
    $null = New-Item -ItemType Directory -Path $assetsPath -Force
}


foreach ($variant in '','animated') {
svg @(
    SVG.GoogleFont -FontName $FontName    
    svg.symbol -ViewBox $powerShellChevron.svg.viewBox -Content $powerShellChevron.svg.symbol.InnerXml -Id psChevron
    SVG.rect -Rx 30 -Ry (30 / $φ) -Stroke "#4488ff" -StrokeWidth 1% -Fill 'transparent' -Width 275 -Height (275 / $φ) -X 12.5 -Y (12.5 / $φ)
    
    svg.use -href '#psChevron'  -X '12.5%' -Y '-2%' -Width '12.5%' -Stroke '#4488ff' -Fill '#4488ff'
    svg.text @(
        svg.tspan "Show" -Children @(
            if ($variant -match 'animated') {
                SVG.animate @AnimateSplat
            }
        ) -FontSize "${scaleMin}em"
        svg.tspan "Demo" -Children @(
            if ($variant -match 'animated') {
                SVG.animate @AnimateSplat2 -Begin ($dur / 2)
            }
        ) -FontSize "${scaleMin}em"        
    ) -FontSize 32 -Fill '#4488ff' -X 50% -DominantBaseline 'middle' -TextAnchor 'middle' -Y 50% @FontSplat
) -ViewBox 300, ([Math]::Floor(300 / $φ)) -OutputPath (Join-Path $assetsPath "ShowDemo$(if ($variant){"-$($variant)"}).svg")
}

Pop-Location

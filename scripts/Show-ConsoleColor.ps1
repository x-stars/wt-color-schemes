<#
.SYNOPSIS
显示控制台颜色设置。
#>

[CmdletBinding()]
[OutputType([void])]
param
(
)

$DarkColors = @(
    "Black", "DarkBlue", "DarkGreen", "DarkCyan",
    "DarkRed", "DarkMagenta", "DarkYellow", "Gray")
$LightColors = @(
    "DarkGray", "Blue", "Green", "Cyan",
    "Red", "Magenta", "Yellow", "White")
$Length = ($DarkColors.Length + $LightColors.Length) / 2

foreach ($Index in 0..$($Length - 1))
{
    $DarkColor = $DarkColors[$Index]
    $LightColor = $LightColors[$Index]
    Write-Host "●$DarkColor".PadRight(16) -ForegroundColor $DarkColor -NoNewline
    Write-Host "●$LightColor".PadRight(16) -ForegroundColor $LightColor -NoNewline
    Write-Host "●$DarkColor".PadRight(16) -BackgroundColor $DarkColor -NoNewline
    Write-Host "●$LightColor".PadRight(16) -BackgroundColor $LightColor -NoNewline
    Write-Host
}

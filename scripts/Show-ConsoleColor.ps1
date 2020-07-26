<#
.SYNOPSIS
显示控制台颜色设置。
#>

[CmdletBinding()]
[OutputType([void])]
param ()

@(
    "Black"
    "DarkBlue"
    "DarkGreen"
    "DarkCyan"
    "DarkRed"
    "DarkMagenta"
    "DarkYellow"
    "Gray"
    "DarkGray"
    "Blue"
    "Green"
    "Cyan"
    "Red"
    "Magenta"
    "Yellow"
    "White"
) |
ForEach-Object `
{
    Write-Host "●$_".PadRight(16) -ForegroundColor $_ -NoNewline
    Write-Host "●$_".PadRight(16) -BackgroundColor $_ -NoNewline
    Write-Host
}

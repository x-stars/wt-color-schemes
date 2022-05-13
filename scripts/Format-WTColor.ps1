<#
.SYNOPSIS
标准化 Windows Terminal 配色文件。

.PARAMETER Path
Windows Terminal 的 JSON 配色文件的路径。可从管道接收值。
#>

[CmdletBinding()]
[OutputType([void])]
param
(
    [Parameter(
        Position = 0,
        Mandatory = $true,
        ValueFromPipeline = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript(
        { Test-Path -LiteralPath $_ -PathType Leaf })]
    [string[]]$Path
)

process
{
    foreach ($FilePath in $Path)
    {
        $Color = Get-Content $FilePath | ConvertFrom-Json
        $Color = [PSCustomObject]@{
            name         = $Color.name
            foreground   = $Color.foreground
            background   = $Color.background
            cursorColor  = $Color.cursorColor
            black        = $Color.black
            red          = $Color.red
            green        = $Color.green
            yellow       = $Color.yellow
            blue         = $Color.blue
            purple       = $Color.purple
            cyan         = $Color.cyan
            white        = $Color.white
            brightBlack  = $Color.brightBlack
            brightRed    = $Color.brightRed
            brightGreen  = $Color.brightGreen
            brightYellow = $Color.brightYellow
            brightBlue   = $Color.brightBlue
            brightPurple = $Color.brightPurple
            brightCyan   = $Color.brightCyan
            brightWhite  = $Color.brightWhite
        }
        if (-not $Color.foreground) { $Color.foreground = $Color.white }
        if (-not $Color.background) { $Color.foreground = $Color.black }
        if (-not $Color.cursorColor) { $Color.cursorColor = $Color.foreground }
        foreach ($Property in $Color.PSObject.Properties.Name)
        {
            if ($Color.$Property -is [string] -and $Color.$Property.StartsWith('#'))
            {
                $Color.$Property = $Color.$Property.ToUpper()
            }
        }
        $ColorJson = $Color | ConvertTo-Json
        $ColorJson = $ColorJson.Replace(":  ", ": ").Replace('  "', '    "')
        $ColorJson | Out-File $FilePath -Encoding default
    }
}

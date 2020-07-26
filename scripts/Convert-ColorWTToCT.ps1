<#
.SYNOPSIS
将 Windows Terminal 的 JSON 配色文件转换为 ColorTool 的 INI 配色文件。

.PARAMETER Path
指定 Windows Terminal 的 JSON 配色文件的路径。可从管道接收值。

.PARAMETER OutFile
指定 ColorTool 的 INI 配色文件的输出路径。默认为当前路径的同名 *.ini 文件。

.PARAMETER Literal
指定是否按原样转换配色。默认会将背景和前景分别映射到黑色和白色。

.OUTPUTS
转换得到的 ColorTool 的 INI 配色文件。
#>

[CmdletBinding()]
[OutputType([System.IO.FileInfo[]])]
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
    ,
    [Parameter(
        Position = 1,
        Mandatory = $false,
        ValueFromPipelineByPropertyName = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript(
        { Test-Path -LiteralPath $_ -PathType Leaf -IsValid })]
    [string[]]$OutFile
    ,
    [Parameter()]
    [switch]$Literal
)

begin
{
    $CTColorNames = @(
        "DARK_BLACK"
        "DARK_BLUE"
        "DARK_GREEN"
        "DARK_CYAN"
        "DARK_RED"
        "DARK_MAGENTA"
        "DARK_YELLOW"
        "DARK_WHITE"
        "BRIGHT_BLACK"
        "BRIGHT_BLUE"
        "BRIGHT_GREEN"
        "BRIGHT_CYAN"
        "BRIGHT_RED"
        "BRIGHT_MAGENTA"
        "BRIGHT_YELLOW"
        "BRIGHT_WHITE"
    )

    $ColorNameMap = @{
        "black"        = "DARK_BLACK"
        "blue"         = "DARK_BLUE"
        "green"        = "DARK_GREEN"
        "cyan"         = "DARK_CYAN"
        "red"          = "DARK_RED"
        "purple"       = "DARK_MAGENTA"
        "yellow"       = "DARK_YELLOW"
        "white"        = "DARK_WHITE"
        "brightBlack"  = "BRIGHT_BLACK"
        "brightBlue"   = "BRIGHT_BLUE"
        "brightGreen"  = "BRIGHT_GREEN"
        "brightCyan"   = "BRIGHT_CYAN"
        "brightRed"    = "BRIGHT_RED"
        "brightPurple" = "BRIGHT_MAGENTA"
        "brightYellow" = "BRIGHT_YELLOW"
        "brightWhite"  = "BRIGHT_WHITE"
    }

    if (-not $Literal)
    {
        $ColorNameMap["background"] = $ColorNameMap["black"]
        $ColorNameMap["foreground"] = $ColorNameMap["white"]
        $ColorNameMap.Remove("black")
        $ColorNameMap.Remove("white")
    }

    function Convert-ColorHexToDec([string]$HexColor)
    {
        $IntColor = [uint32]::Parse($HexColor.Substring(1),
            [System.Globalization.NumberStyles]::HexNumber)
        $DecColor = [string]::Join(',',
            [byte[]]@(
                [byte]($IntColor -shl 8 -shr 24),
                [byte]($IntColor -shl 16 -shr 24),
                [byte]($IntColor -shl 24 -shr 24)))
        $DecColor
    }
}

process
{
    for ($i = 0; $i -lt $Path.Length; $i++)
    {
        $thisPath = $Path[$i]
        if ($OutFile -and $OutFile[$i])
        {
            $thisOutFile = $OutFile[$i]
        }
        else
        {
            $thisOutFile = Join-Path $(Get-Location) "$($(Get-Item $thisPath).BaseName).ini"
        }

        $WTColorObj = Get-Content $thisPath | ConvertFrom-Json
        $CTColorTable = @{ }
        foreach ($WTColorName in $WTColorObj.PSObject.Properties.Name)
        {
            if ($WTColorName -in $ColorNameMap.Keys)
            {
                $CTColorTable[$ColorNameMap[$WTColorName]] = $WTColorObj.$WTColorName
            }
        }

        $CTColorList = @("[table]")
        foreach ($CTColorName in $CTColorNames)
        {
            $HexColor = $CTColorTable[$CTColorName]
            $DecColor = Convert-ColorHexToDec $HexColor
            $CTColorList += "$CTColorName=$DecColor"
        }
        $CTColorList += ""
        $CTColorList += @("[info]")
        $CTColorList += "NAME=$($WTColorObj.name)"

        $CTColorList | Out-File -FilePath $thisOutFile -Encoding default

        Get-Item $thisOutFile
    }
}

end
{
}

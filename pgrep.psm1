

filter timestamp {"$(Get-Date -Format "yy/MM/dd HH:mm:ss.ff"): $_"}

$LogName = "pgrep.log"
function Set-LogName($newLogName){
    if($newLogName){
        Write-Log "Set-LogName - $newLogName" -noFile
        $script:LogName = $newLogName
    }
}

function Write-Log{
    <#
    .SYNOPSIS
    Write a log entry with a timestamp. Optionally write to file.
    #>
    param(
    # The message to write
        [Parameter(Mandatory=$true)]
        [string]$msg = "",
    # The color of the log to use
        [Parameter(Mandatory=$false)]
        [System.ConsoleColor]$ForegroundColor,
    # Whether to write to file or not. Set this to only write to screen.
        [Parameter(Mandatory=$false)]
        [switch]$noFile
    )
    $params = @{}
    if($ForegroundColor){
        $params.ForegroundColor = $ForegroundColor
    } else {
        $params.ForegroundColor = "Cyan"
    }
    Write-Output $msg | timestamp | Write-Host -BackgroundColor Black @params
    if(!$noFile){
        Add-Content $LogName -Value ($msg | timestamp)
    }
}

function Test-NoErrors($msg){
    if($LASTEXITCODE -ne 0){
        Set-Location $PSScriptRoot
        Throw $msg 
    }
}

function Select-StringGrep {
    <#
    .SYNOPSIS
    Fetch an artifact from the Praesto Bridge Repos
    #>
    param(
    # The pattern against which to match candidate text
        [Parameter(Mandatory=$true, Position=0)]
        [string[]]$Patterns,
    # Search file/path
        [Parameter(Mandatory=$false, Position=1)]
        [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "Input path does not exist"
            }
            return $true 
        })]
        [System.IO.FileInfo]$Path= (Get-Location),
    # Not sure how to handle the options just yet...
        [Parameter(Mandatory=$false)]
        [String]$Options
    )
}

New-Alias -Name pgrep -Value Select-StringGrep
Export-ModuleMember -Alias * -Function *

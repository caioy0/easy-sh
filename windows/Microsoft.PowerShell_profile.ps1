oh-my-posh init pwsh | Invoke-Expression

$MaximumHistoryCount = 20000

# Set-PoshPrompt - Theme spaceship
#Set-PoshPrompt -Theme "$HOME\AppData\Local\oh-my-posh\spaceship.omp.json"

# Uses tab for autocompletion
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# History definitions
$HistoryFilePath = Join-Path ([Environment]::GetFolderPath('UserProfile')) .ps_history
Register-EngineEvent PowerShell.Exiting -Action { Get-History | Export-Clixml $HistoryFilePath } | out-null
if (Test-path $HistoryFilePath) { Import-Clixml $HistoryFilePath | Add-History }

Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History

# Aliases
Set-Alias which Get-Command
Set-Alias open Invoke-Item

function ll() { Get-ChildItem | Format-Table }
function la() { Get-ChildItem | Format-Wide }
function lb() { Get-ChildItem | Format-List }
function scoopclean() {
    scoop cache rm *
    scoop cleanup *
}

Set-Alias ls la
Set-Alias l lb
Set-Alias c cls

# Aliases Functions
function cdd() { Set-Location "D:\Downloads" }
function cdp() { Set-Location "D:\Desenvolvimento\Projetos" }
function cdvscode() { Set-Location "C:\Users\User18\Documents\vscode" }

function opd() { open "D:\Downloads" }
function opp() { open "D:\Desenvolvimento\Projetos" }

function edp() { code $PROFILE }
function edh() { code "$HOME\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt" }
function eds() { code "$HOME\AppData\Local\oh-my-posh\spaceship.omp.json" }

# Compute file hashes - useful for checking successful downloads
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

function tail { Get-Content $args -Tail 30 -Wait }

function take {
  New-Item -ItemType directory $args
  Set-Location "$args"
}

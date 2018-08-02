#region Description
<# 
    The script is intended for the following specific example (but I want to be able to easily add more usages later):
    I want it to backup my WeakAuras files or Witcher game saves onto my google drive. 
    Then, whenever I am on a different computer I simply pull the newest files and it saves those in the correct location.

    The reason I cannot just use a folderpair or similar is because I may only want a few files in the folder, and also
    because cloud sync would keep hitting conflics when I have the files opened (because I'm playing WoW or Witcher).
#>
#endregion

# I am still missing: recursive copy of an entire folder and its contents if the path points at a folder

#region Parameters

Param
(
    [Parameter(Mandatory=$True)]
    [ValidateSet('push', 'pull', ignorecase=$False)]
    [string]$mode
)

#endregion

#region Definitions


$notebookName = 'DESKTOP-TJJDDLA'
$localFolderPathNotebook = 'C:\Program Files (x86)\World of Warcraft\WTF\Account\107329825#1\SavedVariables'
$remoteFolderPathNotebook = 'C:\Users\karlz\Google Drive\Other\WorldOfWarcraftDocuments\WeakAuras'

$desktopName = 'ASUS1JONATHAN'
$localFolderPathDesktop = 'C:\Program Files (x86)\World of Warcraft\WTF\Account\107329825#1\SavedVariables'
$remoteFolderPathDesktop = 'C:\Users\karlz\Google Drive\Other\WorldOfWarcraftDocuments\WeakAuras'

$fileNames = 'WeakAuras.lua', 'WeakAurasOptions.lua'


$localFolderPath
$remoteFolderPath
# Local is the file on the pc, remote is the file on the drive
# Undefined for now, because the value these gain depend on which computer I'm on

#endregion

#region IdentifyComputer

If ($env:computername -ceq $notebookName)
{
    $localFolderPath = $localFolderPathNotebook
    $remoteFolderPath = $remoteFolderPathNotebook
}
elseif ($env:computername -ceq $desktopName)
{
    $localFolderPath = $localFolderPathDesktop
    $remoteFolderPath = $remoteFolderPathDesktop
}
else
{
    Write-Host Could not identify computer
    Exit
}

#endregion

#region Push

function Files-Push
{
    # Create new folder at remote location if there's not one for this date already
    # Copy files from local location into the folder (recursively)

    $date = Get-Date -Format yyyy_MM_dd

    # Creates a new folder at the remote location with its name as the current date
    $newFolderPath = "$remoteFolderPath\$date"

    If (!(Test-Path -Path $newFolderPath -PathType Container)) 
    {
        # If folder does not exist, then create folder
        New-Item -Path $newFolderPath -ItemType "directory"
        Write-Host "> Create new folder | $newFolderPath"
    }

    Foreach ($file in $fileNames)
    {
        Copy-Item "$localFolderPath\$file" $newFolderPath -Recurse
        Write-Host "> Pushing | $localFolderPath\$file `n to $newFolderPath"
    }
}

#endregion

#region Pull

function Files-Pull
{
    # Find the most recent folder at the remote location
    # Copy files from remote location into the local location (recursively)

    # Finds the folder with name showing it was most recently added, eg: 2017_12_30 over 2017_11_28 and so forth
    $newestFolder = Get-ChildItem $remoteFolderPath -Directory | Sort-Object -Property Name | Select -Last 1 | Select -ExpandProperty Name

    Foreach ($file in $fileNames)
    {
        Copy-Item "$remoteFolderPath\$newestFolder\$file" $localFolderPath -Recurse
        Write-Host "> Pulling | $remoteFolderPath\$newestFolder\$file `n to $localFolderPath"
    }
}

#endregion

#region Execute

if($mode -ceq 'push')
{
    Files-Push
}
elseif ($mode -ceq 'pull')
{
    Files-Pull
}

Write-Host 'End'

#endregion

#Requires -Version 3

$sysToolsListUri = "https://live.sysinternals.com/tools"
$commonProgramsSpecialFolder = [environment]::getFolderPath("CommonPrograms")

$blockList = @(
    "*.SYS" # won't download...maybe blocked by IIS/WebDAV?
    "*.CNT"
)


$sysWebRequest = [System.Net.WebRequest]::Create($sysToolsListUri)
$sysWebRequest.Method = "PROPFIND" #WebDAV list directory
$sysWebRequest.Headers['Depth'] = 1 # MUST be 1

$sysToolsList = [xml](New-Object System.IO.StreamReader (($sysWebRequest.getResponse()).GetResponseStream())).readToEnd()

function Set-Shortcut
{ # https://stackoverflow.com/a/9701907
    param ( 
        [string]$ShortcutPath, 
        [string]$TargetPath, 
        [string]$ArgumentsToTarget, 
        [string]$IconPath,
        [string]$Description
        )
    
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $TargetPath
    #$Shortcut.Arguments = $ArgumentsToTarget
    #$Shortcut.IconLocation = $IconPath
    $Shortcut.WorkingDirectory = '%HOMEDRIVE%%HOMEPATH%'
    $Shortcut.Description = $Description.trim()
    #WindowStyle = 3  #Maximized 7=Minimized  4=Normal
    #HotKey = "ALT+CTRL+F"
    $Shortcut.Save()
}

#function SyncWebDAVToFolder
$sysTools = $sysToolsList.DocumentElement.ChildNodes
forEach ($sysTool in $sysTools) #-parallel
{
    $sysToolLastModified = Get-Date $sysTool.propStat.prop.getLastModified
    $sysToolCreated = Get-Date $sysTool.propStat.prop.creationDate
    $sysToolFileName = $sysTool.propStat.prop.displayName
    $sysToolHref = $sysTool.href

    #Push-Location # set the function with a Begin and End block; push in the begin, pop in the end; get location from an argument

    if ($sysTool.propstat.prop.iscollection -ne "0")
    {}
    elseif (($sysToolFileName -notlike "*.sys") -and ($sysToolFileName -notlike "*.cnt")) #$blockList -notcontains $sysToolFileName)
    {
        if ((-NOT (Test-Path -PathType Leaf -Path $sysToolFileName)) -OR ((ls $sysToolFileName).LastWriteTime -lt $sysToolLastModified))
        {
            try {
                $sysToolWebRequest = Invoke-WebRequest -uri $sysToolHref -OutFile $sysToolFileName #-PassThru
                $sysToolFile = ls $sysToolFileName
                $sysToolFile.LastWriteTime = $sysToolLastModified
                $sysToolFile | Add-Member -NotePropertyName ETag -NotePropertyValue $sysTool.propstat.prop.getetag # Does this even work?
            }
            catch
            {
                $sysToolWebRequest = $_
                $sysToolWebRequest.Exception #.Message
                break
            }
        }
    }
}


#function createStartMenuShortCutsForSysInternals
#                if ($sysToolFileInfo = $sysToolFile.VersionInfo)
#                {
#                    $sysToolName = $sysToolFileInfo.ProductName -iReplace("SysInternals","")
#                    $sysToolDescription = $sysToolFileInfo.FileDescription -iReplace("SysInternals","") -iReplace("$($sysToolFileInfo.InternalName) -","")
#
#                    #Set-Shortcut `
#                    #    -ShortcutPath "$($commonProgramsSpecialFolder)\SysInternals\$($sysToolName.trim()).lnk" `
#                    #    -TargetPath $sysToolFileInfo.fileName `
#                    #    -Description $sysToolDescription.Trim() `
#
#                }


# https://stackoverflow.com/a/29002672
#$file="c:\temp\calc.lnk"
#$bytes = [System.IO.File]::ReadAllBytes($file)
#$bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 (0x15) bit 6 (0x20) ON (Use –bor to set RunAsAdministrator option and –bxor to unset)
#[System.IO.File]::WriteAllBytes($file, $bytes)


# Goto the directory of your File History
$Folder = Get-Location
# Choose which directory, where the files should be placed
$FolderCopyTo ="f:\temp\test\"

$DirGroups = Get-ChildItem $Folder -Name -attributes D -Recurse
$Folder = $Folder -replace "\\","\\"

Foreach ($DG in $DirGroups) {
    $Groups = Get-ChildItem -Force -File $DG | Group-Object -Property {($_.Name -replace " \(\d{4}_\d{2}_\d{2} \d{2}_\d{2}_\d{2} UTC\)","")}
    Foreach ($G in $Groups) {
        $fileToMove = $G | Select-Object -ExpandProperty Group | 
            Sort-Object Name -Descending | Select -First 1
        #$fileToMove | Select-Object FullName, {($_.Directory -Replace "$Folder\\","")}, {($_.Name -replace " \(\d{4}_\d{2}_\d{2} \d{2}_\d{2}_\d{2} UTC\)","")}
        
        $FileCopyFrom = $fileToMove.FullName
        #$FileCopyFrom
        
        $FileMoveTo = $fileToMove.Directory -Replace "$Folder\\",""
        $FileMoveTo = "$FolderCopyTo$FileMoveTo\$fileToMove"
        $FileMoveTo = $FileMoveTo -replace " \(\d{4}_\d{2}_\d{2} \d{2}_\d{2}_\d{2} UTC\)",""
        #$FileMoveTo

        $destinationFolder = $FileMoveTo.Replace($FileMoveTo.Split("\")[-1],"")

            if (!(Test-Path -path $destinationFolder)) {
                New-Item $destinationFolder -Type Directory
            }
       
        Copy-Item -Path "$FileCopyFrom" -Destination "$FileMoveTo" -recurse -container

    }
}

function Organize-Files {
    param(
        [string]$FolderPath
    )

 
    if (-not (Test-Path $FolderPath)) {
        Write-Host "Folder not found. Please enter a valid folder path."
        return
    }

 
    # Define a hashtable to map extensions to major types
    $MajorTypeMapping = @{
        "txt" = "TextFiles"
        "doc" = "TextFiles"
        "docx" = "TextFiles"
        "pdf" = "TextFiles"
		"jpg" = "ImageFiles"
		"png" = "ImageFiles"
		"jpeg" = "ImageFiles"
        "mp4" = "VideoFiles"
        "avi" = "VideoFiles"
        "mkv" = "VideoFiles"
        "mp3" = "MusicFiles"
        "wav" = "MusicFiles"
		"py" = "ScriptFiles"
		"ps1" = "ScriptFiles"
		"exe" = "ApplicationFiles"
		"ps" = "ScriptFiles"
        # Add more mappings here as needed
    }

 
    $OtherFilesFolder = Join-Path $FolderPath "OtherFiles"
    if (-not (Test-Path $OtherFilesFolder)) {
        New-Item -ItemType Directory -Path $OtherFilesFolder | Out-Null
    }

 
    $Files = Get-ChildItem -Path $FolderPath -File

 
    foreach ($File in $Files) {
        $Extension = $File.Extension.TrimStart('.')
        if ($Extension -ne '') {
            $FileType = $Extension.ToLower()
            if ($MajorTypeMapping.ContainsKey($FileType)) {
                $MajorType = $MajorTypeMapping[$FileType]
                $DestinationFolder = Join-Path $FolderPath $MajorType
                if (-not (Test-Path $DestinationFolder)) {
                    New-Item -ItemType Directory -Path $DestinationFolder | Out-Null
                }
                Move-Item -Path $File.FullName -Destination $DestinationFolder -ErrorAction SilentlyContinue
            }
            else {
                # Move files with unlisted extensions to "OtherFiles" folder
                Move-Item -Path $File.FullName -Destination $OtherFilesFolder -ErrorAction SilentlyContinue
            }
        }
    }

 
    Write-Host "File organization complete! Follow me for more automations ig: outsploiter"
}

 
# Prompt user for folder location
$FolderPath = Read-Host "Enter the folder location that needs to be organized:"

 
Organize-Files -FolderPath $FolderPath

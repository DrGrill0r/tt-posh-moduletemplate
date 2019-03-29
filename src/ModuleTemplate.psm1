<%
[string[]]$PLASTER_PARAM_DirectoryArray = $null
ForEach ( $option in $PLASTER_PARAM_DirectoryOptions ) {
    $PLASTER_PARAM_DirectoryArray += "`"$option`""
}
[string]$PLASTER_PARAM_DirectoryArrayString = $PLASTER_PARAM_DirectoryArray -join ", "
"`$cmdletDirectories = @($PLASTER_PARAM_DirectoryArrayString)"
%>

ForEach ($directory in $cmdletDirectories) {
    $directoryPath = Join-Path -Path $PSScriptRoot -ChildPath $directory

    if(Test-Path -Path $directoryPath) {
        Write-Verbose -Message "Importing from $directory"

        $cmdlets = Get-ChildItem -Path $directoryPath -Filter '*.ps1'

        ForEach ($cmdlet in $cmdlets) {
            Write-Verbose -Message "  Importing $($cmdlet.BaseName)"
            . $($cmdlet.FullName)
        }
    }
}
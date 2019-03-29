$ModuleManifestName = "<%=$PLASTER_PARAM_ModuleName%>.psd1"
$ModuleRootDirectory = Resolve-Path "$PSScriptRoot\..\"
$ModuleManifestPath = Join-Path -Path $ModuleRootDirectory -ChildPath $ModuleManifestName

#Import-Module $ModuleManifestPath -Force

Describe 'if module manifest' {
    
    It 'is present and basically correct' {
        ### ARRANGE, ACT & ASSERT
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not Be NullOrEmtpty
        $? | Should Be $true
    }

    ### ARRANGE
    . $PSScriptRoot\Get-FunctionDefinitions.ps1 -Force

    $ScriptsExportFolder = Join-Path -Path $ModuleRootDirectory -ChildPath 'Export'
    $scriptFilesToExport = Get-ChildItem -Path $ScriptsExportFolder -Filter '*.ps1' -Recurse

    ### ACT
    $functionsInExportDir = $scriptFilesToExport | ForEach-Object {
        Get-FunctionDefinitions -Path $_.FullName
    } | ForEach-Object { $_.Name }

    $numOfFunctionsInExportDir = $null

    if( $functionsInExportDir ) {
        $numOfFunctionsInExportDir = ($functionsInExportDir | Measure-Object).Count
    } Else {
        $numOfFunctionsInExportDir = 0
        $functionsInExportDir = @('')
    }

    $functionsInExportClauses = (Import-PowerShellDataFile $ModuleManifestPath).FunctionsToExport

    It "declares all $numOfFunctionsInExportDir functions from Export directory as exportable" {

        ### ASSERT
        $diffBetweenDirAndDataFile = Compare-Object -ReferenceObject $functionsInExportDir -DifferenceObject $functionsInExportClauses
        ($diffBetweenDirAndDataFile | Measure-Object).Count | Should Be 0
    }
}

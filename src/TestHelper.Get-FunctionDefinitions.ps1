<#
.SYNOPSIS
    Returns all Functions and Cmdlets from a given file.
.DESCRIPTION
    Uses the AST for parsing and tokenizing a PoSh Scriptfile in order to retrieve all functions
    defined within given file.
.PARAMETER Path
    Path to the file being analyzed.
#>
Function Get-FunctionDefinitions {
param(
    [string] $Path
)
    $scriptFile = $null

    if( Test-Path -Path $Path ) {
        $scriptFile = Resolve-Path $Path
    } Else {
        Write-Error "Invalid file path."
    }

    $tokens = $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile(
        $scriptFile,
        [ref]$tokens,
        [ref]$errors)
    
    $functionDefinitions = $ast.FindAll({
        param([System.Management.Automation.Language.Ast] $Ast)
    
        return $Ast -is [System.Management.Automation.Language.FunctionDefinitionAst] -and
        # Class methods have a FunctionDefinitionAst under them as well, but we don't want them.
        ($PSVersionTable.PSVersion.Major -lt 5 -or
        $Ast.Parent -isnot [System.Management.Automation.Language.FunctionMemberAst])
    
    }, $true)

    if ( $errors ) {
        $error | ForEach-Object {
            $_
        }

        Write-Error "Something went wrong while parsing."
    }

    return $functionDefinitions
}
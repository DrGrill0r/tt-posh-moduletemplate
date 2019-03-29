# TT PoSh Module Template

Lets you roll out your PowerShell modules faster. 

## How do I start?

  * Download or clone this repository to <DOWNLOADPATH>
  * Make sure you have Plaster installed (v1.1.3 or later), 
    see [Install Plaster](https://github.com/PowerShell/Plaster#Installation) for more details

```PowerShell
> Invoke-Plaster -TemplatePath <DOWNLOADPATH>\tt-posh-moduletemplate -Destination .\PoSh.Example.Module
```
  * Follow through the installation process

## What does it do?

Generates a basic PowerShell module project structure with basic unit testing functionality. 

```
.\POSH.GENERATED.EXAMPLE
    │   PoSh.Generated.Example.psd1
    │   PoSh.Generated.Example.psm1
    │   
    ├───.vscode
    │       settings.json
    │       
    ├───Export
    ├───Private
    └───Tests
            Get-FunctionDefinitions.ps1
            PoSh.Generated.Example.Tests.ps1
```

You can then Import the freshly generated module with `Import-Module PoSh.Generated.Example.psd1`.
The module automatically loads `PoSh.Generated.Example.psm1` which will dot-source every script file
located in `Export` and `Private`. Make sure to export all functions and cmdlets in the Export directory explicitly
by editing the module manifest accordingly.

If you have chosen support for Pester unit-testing you execute a basic sanity check of your module
manifest by typing `Invoke-Pester`.

## Why another Plaster template?

[Plaster](https://github.com/PowerShell/Plaster) is a template-based file and project generator written in PowerShell.
There are a lot of good [resources](https://powershellexplained.com/2017-05-27-Powershell-module-building-basics/) out
there on 
how to write solid [well structured PowerShell modules](https://www.red-gate.com/simple-talk/dotnet/net-tools/further-down-the-rabbit-hole-powershell-modules-and-encapsulation/).
However, most of the Plaster templates simply create a module manifest with default settings `FunctionsToExport = '*'`.
This results to cmdlets and functions [not being exported properly](https://mikefrobbins.com/2016/05/05/dont-use-default-manifest-settings-when-dot-sourcing-functions-in-ps1-files-from-a-powershell-script-module/),
especially when dot-sourcing script files.

This is a lightweight template encouraging a tidied-up project structure with sane default setttings.
If Pester is included, Unit-Tests will guard you against common mistakes wile setting up the module
manifest.
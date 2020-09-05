[![PowerShell Gallery - VMwareFever](https://img.shields.io/badge/PowerShell_Gallery-VMwareFever-0072C6.svg)](https://www.powershellgallery.com/packages/VMwareFever)
[![GitHub - Release](https://img.shields.io/github/release/claudiospizzi/VMwareFever.svg)](https://github.com/claudiospizzi/VMwareFever/releases)
[![AppVeyor - master](https://img.shields.io/appveyor/ci/claudiospizzi/VMwareFever/master.svg)](https://ci.appveyor.com/project/claudiospizzi/VMwareFever/branch/master)

# VMwareFever PowerShell Module

PowerShell Module with custom functions and cmdlets for VMware vSphere.

## Introduction

This is a personal PowerShell Module by Claudio Spizzi. It is used to manage
VMware vSphere, e.g. connecting or remote management.

## Features

* **Connect-VMware**  
  Connect to the VMware vCenter.

* **Open-VMwareVMConsole**  
  Open a VMware Console session to the target VM.

## Versions

Please find all versions in the [GitHub Releases] section and the release notes
in the [CHANGELOG.md] file.

## Installation

Use the following command to install the module from the [PowerShell Gallery],
if the PackageManagement and PowerShellGet modules are available:

```powershell
# Download and install the module
Install-Module -Name 'VMwareFever'
```

Alternatively, download the latest release from GitHub and install the module
manually on your local system:

1. Download the latest release from GitHub as a ZIP file: [GitHub Releases]
2. Extract the module and install it: [Installing a PowerShell Module]

## Requirements

The following minimum requirements are necessary to use this module, or in other
words are used to test this module:

* Windows PowerShell 5.1
* Windows 10

## Contribute

Please feel free to contribute by opening new issues or providing pull requests.
For the best development experience, open this project as a folder in Visual
Studio Code and ensure that the PowerShell extension is installed.

* [Visual Studio Code] with the [PowerShell Extension]
* [Pester], [PSScriptAnalyzer] and [psake] PowerShell Modules

[PowerShell Gallery]: https://www.powershellgallery.com/packages/VMwareFever
[GitHub Releases]: https://github.com/claudiospizzi/VMwareFever/releases
[Installing a PowerShell Module]: https://msdn.microsoft.com/en-us/library/dd878350

[CHANGELOG.md]: CHANGELOG.md

[Visual Studio Code]: https://code.visualstudio.com/
[PowerShell Extension]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
[Pester]: https://www.powershellgallery.com/packages/Pester
[PSScriptAnalyzer]: https://www.powershellgallery.com/packages/PSScriptAnalyzer
[psake]: https://www.powershellgallery.com/packages/psake

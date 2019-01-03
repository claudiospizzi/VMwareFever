<#
    .SYNOPSIS
        Connect to the VMware vCenter.

    .DESCRIPTION
        Use the VMware.PowerCLI module to establish a connection to the VMware
        vCenter.

    .PARAMETER ComputerName
        The VMware vCenter server.

    .PARAMETER Credential
        Username and password of the VMware vCenter. By default it will get the
        credential vault entry with the target name 'VMware vCenter Credential'.
#>
function Connect-VMware
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ComputerName,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.Credential()]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    # Import the VMware PowerCLI module, if not already done
    if ($null -eq (Get-Module -Name 'VMware.PowerCLI'))
    {
        Import-Module -Name 'VMware.PowerCLI' -Verbose:$false *> $null

        # Disable CEIP and ignore certificate warnings
        Set-PowerCLIConfiguration -Scope User -ParticipateInCeip $false -InvalidCertificateAction Ignore -Confirm:$false | Out-Null
    }

    if ($Global:DefaultVIServers.Count -gt 0)
    {
        # Return current connection
        $global:DefaultVIServers[0]
    }
    else
    {
        # Finally, connect to the VMware vCenter
        Connect-VIServer -Server $ComputerName -Credential $Credential
    }
}

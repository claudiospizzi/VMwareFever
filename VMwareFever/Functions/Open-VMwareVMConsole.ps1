<#
    .SYNOPSIS
        Open a VMware Console session to the target VM.

    .DESCRIPTION
        Use the VMware.PowerCLI module to aquire a session ticket to the VM and
        use this to open the VMware Remte Console.

    .PARAMETER VM
        The target VM.
#>
function Open-VMwareVMConsole
{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [VMware.VimAutomation.Types.VirtualMachine]
        $VM
    )

    begin
    {
        $viServiceInstance = Get-View -Id 'ServiceInstance'
        $viSessionManager = Get-View -Id $viServiceInstance.Content.SessionManager
    }

    process
    {
        # Define the vmrc:// url to the vm with a session token
        $vmrcUri = 'vmrc://clone:{0}@{1}/?moid={2}' -f $viSessionManager.AcquireCloneTicket(), $Global:DefaultVIServer.Name, $vm.ExtensionData.MoRef.Value

        Write-Verbose "Invoke $vmrcUri"

        # Open VMRC console
        Start-Process -FilePath $vmrcUri
    }
}

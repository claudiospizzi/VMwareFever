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
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [VMware.VimAutomation.Types.VirtualMachine]
        $VM
    )

    begin
    {
        $viServer = Connect-VMware

        $viServiceInstance = Get-View -Id 'ServiceInstance'
        $viSessionManager = Get-View -Id $viServiceInstance.Content.SessionManager
    }

    process
    {
        # Open VMRC console
        $vmrcUri = 'vmrc://clone:{0}@{1}/?moid={2}' -f $viSessionManager.AcquireCloneTicket(), $viServer.Name, $vm.ExtensionData.MoRef.Value
        Start-Process -FilePath $vmrcUri
    }
}

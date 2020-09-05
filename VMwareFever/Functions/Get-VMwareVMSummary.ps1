<#
    .SYNOPSIS
        Get the summary about a VM.

    .DESCRIPTION
        Use the VMware.PowerCLI module to get various VM infrormations and
        return them as an object.

    .PARAMETER Name
        The VM name.

    .PARAMETER DNSName
        The guest OS hostname.
#>
function Get-VMwareVMSummary
{
    param
    (
        [Parameter(Mandatory = $true, ParameterSetName = 'Name')]
        [System.String]
        $Name,

        [Parameter(Mandatory = $true, ParameterSetName = 'DNSName')]
        [System.String]
        $DNSName
    )

    $vmNames = @()

    if ($PSCmdlet.ParameterSetName -eq 'Name')
    {
        $vmNames += VMware.VimAutomation.Core\Get-View -ViewType VirtualMachine -Property 'Name' -Filter @{ 'Name' = $Name } | Select-Object -ExpandProperty 'Name'
    }

    if ($PSCmdlet.ParameterSetName -eq 'DNSName')
    {
        $vmNames += VMware.VimAutomation.Core\Get-View -ViewType VirtualMachine -Property 'Name' -Filter @{ 'Guest.HostName' = $DNSName } | Select-Object -ExpandProperty 'Name'
    }

    foreach ($vmName in $vmNames)
    {
        $vm     = VMware.VimAutomation.Core\Get-VM -Name $vmName
        $vmHost = VMware.VimAutomation.Core\Get-VMHost -ID $vm.VMHostId
        $disks  = $vm | VMware.VimAutomation.Core\Get-HardDisk
        $nics   = $vm | VMware.VimAutomation.Core\Get-NetworkAdapter

        $lastBoot = Get-Stat -Entity $vm -Stat 'sys.osuptime.latest' -Realtime -MaxSamples 1 | ForEach-Object { (Get-Date).AddSeconds(-1 * $_.Value) }

        $vmStorage = @()
        foreach ($disk in $disks)
        {
            # Parse the disk IOPS
            $diskIOPS = '{0,4} IOPS' -f $disk.ExtensionData.StorageIOAllocation.Limit
            if ($diskIOPS -eq '  -1 IOPS')
            {
                $diskIOPS = 'Unlimited'
            }

            # Get the disk datastore
            $datastore = Get-Datastore -Name $disk.Filename.TrimStart('[').Split(']')[0]

            $vmStorage += [PSCustomObject] @{
                PSTypeName     = 'VMwareFever.VMSummary.Storage'
                ControllerId   = $disk.ExtensionData.ControllerKey - 1000
                ControllerPort = $disk.ExtensionData.UnitNumber
                CapacityGB     = $disk.CapacityGB
                Datastore      = $datastore.Name
                LimitIOPS      = $diskIOPS
                StorageFormat  = $disk.StorageFormat
                Persistence    = $disk.Persistence
            } | Add-Member -MemberType 'ScriptMethod' -Name 'ToString' -Value { '[{0}:{1:00}] {2}, {3,4} GB, {4}, {5}, {6}' -f $this.ControllerId, $this.ControllerPort, $this.Datastore, $this.CapacityGB, $this.LimitIOPS, $this.StorageFormat, $this.Persistence } -Force -PassThru
        }

        $vmNetwork = @()
        foreach ($nic in $nics)
        {
            if ($nic.ConnectionState.Connected)
            {
                $nicConnected = 'Connected'
            }
            else
            {
                $nicConnected = 'Disconnected'
            }

            $vmNetwork += [PSCustomObject] @{
                PSTypeName     = 'VMwareFever.VMSummary.Network'
                ControllerId   = $nic.ExtensionData.ControllerKey - 100
                ControllerPort = $nic.ExtensionData.UnitNumber
                MacAddress     = $nic.MacAddress
                Network        = $nic.NetworkName
                Connected      = $nicConnected
            } | Add-Member -MemberType 'ScriptMethod' -Name 'ToString' -Value { '[{0}:{1:00}] {2}, {3}, {4}' -f $this.ControllerId, $this.ControllerPort, $this.MacAddress, $this.Network, $this.Connected } -Force -PassThru
        }

        [PSCustomObject] @{
            PSTypeName = 'VMwareFever.VMSummary'
            Name       = $vm.Name
            Host       = $vm.VMHost.Name
            Cluster    = $vmHost.Parent.Name
            DNSName    = $vm.ExtensionData.Guest.HostName
            OSName     = $vm.ExtensionData.Guest.GuestFullName
            Uptime     = '{0:%d} Day(s), {0:%h} Hour(s)' -f ([DateTime]::Now - $lastBoot)
            LastBoot   = $lastBoot
            PowerState = $vm.PowerState.ToString()
            Processor  = '{0} x {1}' -f ($vm.NumCpu / $vm.CoresPerSocket), $vm.CoresPerSocket
            Memory     = '{0} GB' -f $vm.MemoryGB
            Storage    = ($vmStorage | Sort-Object -Property 'ControllerId', 'ControllerPort') -join "`n"
            Network    = ($vmNetwork | Sort-Object -Property 'ControllerId', 'ControllerPort') -join "`n"
        }
    }
}

#Requires -RunAsAdministrator
Param(
    [Switch]$Online = $false
)

Function Get-NetAdapterVisibility
{
    Param(
        $Description = "*"
    )

    $navKey = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\*'

    Get-ItemProperty -Path $navKey -ErrorAction SilentlyContinue | 
    Where-Object { $_.DriverDesc -like $Description } |
    Select-Object DriverDesc, PSPath
}

Function Set-NetAdapterVisibility
{
    Param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        $PSPath,
        [switch]
        $ignoreNLA
    )

    Process
    {
        if ($ignoreNLA) {
            New-ItemProperty $PSPath -name '*NdisDeviceType' -propertytype dword -value 1 | Out-Null
        } else {
            Remove-ItemProperty $PSPath -name '*NdisDeviceType' 
}   }   }

if($true -eq $Online)
{
    Get-NetAdapterVisibility -Description "*Hamachi*" | Set-NetAdapterVisibility -ignoreNLA
}
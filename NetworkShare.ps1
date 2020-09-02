# fix Windows 10 ICS not working after reboot
# https://support.microsoft.com/en-us/help/4055559/ics-doesn-t-work-after-computer-or-service-restart-on-windows-10
[microsoft.win32.registry]::SetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\SharedAccess", "EnableRebootPersistConnection", 0x01)

# Enable IP Forwarding
# https://serverfault.com/questions/929081/how-can-i-enable-packet-forwarding-on-windows/929089#929089
Set-NetIPInterface -Forwarding Enabled
# Check IP Forwarding Status
Get-NetIPInterface | Select-Object ifIndex,InterfaceAlias,AddressFamily,ConnectionState,Forwarding | Sort-Object -Property IfIndex | Format-Table

# Change the Internet Connection Sharing (ICS) service Startup type to Automatic.
Set-Service SharedAccess -StartupType Automatic
# Start ICS service for now
Start-Service SharedAccess
# Check ICS service Status
Get-Service SharedAccess
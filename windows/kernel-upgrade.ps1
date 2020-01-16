# set -ux equivalent
Set-PSDebug -trace 1 -Strict

# Define sleep time
if ($args.count -gt 0) {
    $sleeptime = $args[0]
}
else {
    $sleeptime = 10
}

# Shutdown the VM
wsl --shutdown

# Local paths/info
$ssh_key = 'C:\Users\natec\Linux\id_ed25519'
$server_ip = Get-Content 'C:\Users\natec\Linux\.server_ip'
$wslkernel_destination = 'C:\Users\natec\Linux\kernel-4.19-clang'

# Remote path
$wslkernel_download = '/home/nathan/src/WSL2-Linux-Kernel/out.x86_64/arch/x86/boot/bzImage'

# Download the new kernel
Remove-Item -ErrorAction Ignore $wslkernel_destination
scp -i $ssh_key nathan@$server_ip`:$wslkernel_download $wslkernel_destination

# Start up the VM and print the version
Start-Sleep -Seconds $sleeptime
wsl -d Debian -- /usr/bin/batcat /proc/version

# If the distro fails to start, try again
if (!$?) {
    wsl --shutdown
    Start-Sleep -Seconds $sleeptime
    wsl -d Debian -- /usr/bin/batcat /proc/version
}
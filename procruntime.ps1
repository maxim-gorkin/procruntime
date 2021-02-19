param([string]$warning = $critical, [string]$critical= "", [string]$procname = "", [string]$cmdline = "", [string]$gtlt = "" )
$Status = 0
$warncount = 0
$critcount = 0
$procs = get-wmiobject win32_process | where ProcessName -match $procname | where commandline -match $cmdline | Select-Object -ExpandProperty ProcessId
foreach($proc in $procs) 
{
  if ($gtlt -eq 'gt')
  {
    $procdate = (New-TimeSpan -Start (Get-Process -Id $proc).StartTime).TotalMinutes
    if ($procdate -gt $warning)
    {
      $proccmdline = Get-WmiObject Win32_Process -Filter "ProcessId = '$proc'" | Select-Object CommandLine
      $procdate = [int]$procdate
      Write-Output "Process $proc - with $proccmdline is running $procdate minutes"
      $warncount = $warncount + 1
    }
    if ($procdate -gt $critical -And $critical -ne '')
    {
      $critcount = $critcount + 1
    }
  }
  elseif ($gtlt -eq 'lt')
  {
    $procdate = (New-TimeSpan -Start (Get-Process -Id $proc).StartTime).TotalMinutes
    if ($procdate -lt $warning)
    {
      $proccmdline = Get-WmiObject Win32_Process -Filter "ProcessId = '$proc'" | Select-Object CommandLine
      $procdate = [int]$procdate
      Write-Output "Process $proc - with $proccmdline is running $procdate minutes"
      $Status = 1
      $warncount = $warncount + 1
    }
    if ($procdate -lt $critical -And $critical -ne '')
    {
      $critcount = $critcount + 1
    }
  }
}

if  ($critcount -gt 0)
{
  $Status = 2
} 
elseif  ($warncount -gt 0)
{
  $Status = 1
} 

if ($Status -eq "2")
{
  Write-Host "CRITICAL:" $warncount "processes - warning/critical"
}
elseif ($Status -eq "1")
{
  Write-Host "WARNING:" $warncount "processes - warning"
}
else
{
  Write-Host "OK: 0 processes" 
}
exit $Status

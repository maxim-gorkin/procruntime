# procruntime
Monitoring Windows process run time (PowerShell/Nagios/OPSView)

The script was developed for OPSViewbut but should work with Nagios as well.

OPSView setup:

1. Add procruntime.ps1 in OPSview Agent script directory.
2. Add the line in opsview.ini:

procruntime = cmd /c echo scripts\procruntime.ps1 $ARG1$; exit($lastexitcode) | PowerShell.exe -command -

3. Create service check:

check_nrpe -H $SERVERIP$ -c procruntime -a '-warning 15 -critical 20 -procname python.exe -cmdline python-script.py -gtlt gt'

Example:

Command:	check_nrpe -H '12.23.45.67' -c procruntime -a '-warning 15 -critical 20 -procname python.exe -cmdline python-script.py -gtlt gt'

Monitored by:	opsview-collector-cluster

Hostname run on:	ops-coll-01

Return code:	2

Output:	Process 6612 - with @{CommandLine=C:\software\python\python.exe C:/Files/scripts/python-script.py --config C:/Users/ADMINI~1/python-script.yaml} is running 62253 minutes
CRITICAL: 1 processes - warning/critical

Keys:

-warning - munutes. Show warning alert if process/es are running more/less(depends of -gtlt) then X minutes.
-critical  - munutes. Show critical alert if process/es are running more/less(depends of -gtlt) then X minutes.
-procname - process name.
-cmdline - full all part command line.
-gtlt - greater than or less than/

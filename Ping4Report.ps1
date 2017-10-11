#include some edits here
param ([string]$network)

. ".\testport.ps1"
. "..\sendemail\sendo.ps1"
<#
 $cnt = 1
[System.Collections.ArrayList] $strarr_ip = @()
 
while($cnt -lt 255)
{
  $StrTmp = $network+[string]$cnt
  $strarr_ip.add($StrTmp)
  $cnt++  
}
#>

if(test-path 'log.txt')
{ 
   remove-item 'log.txt'
}

Out-File 'log.txt'

if(test-path "portlog.txt")
  { 
    remove-item "portlog.txt"
  }
  out-file "portlog.txt"


for($tmpcnt = 1; $tmpcnt -lt 255 ; $tmpcnt++)
{
  $StrIPTmp = $network+[string]$tmpcnt
  
    if(!(Test-Connection -cn  $StrIPTmp -count 1 -Quiet))
    { 
      write-host "ping failed on $StrIPTmp `n"
      "ping failed on $StrIPTmp `n" >> 'log.txt'     
    }
    else
    {
      write-host "successfully ping $StrIPTmp `n"
      "successfully ping $StrIPTmp `n" >> 'log.txt'
      scanport($StrIPTmp)
   }
 } #end for each

 #function sendOxley($emaildesti,$subject1,$body1,$attach3)
 #attach the log file
 $attach1 = (Get-Item -Path ".\" -Verbose).FullName+"\log.txt"
 sendoxley "justin.li2030@gmail.com"  "log"  "attached is log file" $attach1 
 #end while 1000



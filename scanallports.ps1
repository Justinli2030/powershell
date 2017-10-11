param ([string]$ip)

  $Computername = $ip

  if(Test-Path("scanallports.txt")){
   remove-item "scanallports.txt" 
   }
   Out-File("scanallports.txt")
   
  #Timeout in milliseconds
$TCPTimeout = 100
For($Item = 1; $Item -lt 65535; $item++){
  $TCPClient  = New-Object  -TypeName   System.Net.Sockets.TCPClient
  $AsyncResult  = $TCPClient.BeginConnect($Computername,$Item,$null,$null)
  $Wait = $AsyncResult.AsyncWaitHandle.WaitOne($TCPtimeout) 

  If ($Wait){
     Try{
        $Null  = $TCPClient.EndConnect($AsyncResult)
       }
       Catch{
         Write-Warning  $_
         $Issue  = $_.ToString()
       }
       Finally{
             $ps1 =  [pscustomobject]  @{
              Computername = $Computername
              Port =  $Item
              IsOpen =  $TCPClient.Connected
              Notes =  $Issue
               }
              echo $ps1
              echo $ps1 >> "scanallports.txt" #write to log
             }
  }Else{
             $ps1 =  [pscustomobject]  @{
              Computername = $Computername
              Port =  $Item
              IsOpen =  $TCPClient.Connected
              Notes =  'Timeout occurred connecting to port'
                               } 
             # echo $ps1
      } #end of Else
  $Issue  = $Null
  $TCPClient.Dispose()
  
 } # end of foreach


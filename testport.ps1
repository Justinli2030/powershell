function scanport($ip)
{
  $Computername = $ip
  [int[]]$Port  = 21,22,23,445,443,80,8080,8090,8088,111,389,3389
 
  #Timeout in milliseconds
$TCPTimeout = 100
ForEach ($Item  in $Port){
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
              echo $ps1 >> "portlog.txt" #write to log
             }
  }Else{
             $ps1 =  [pscustomobject]  @{
              Computername = $Computername
              Port =  $Item
              IsOpen =  $TCPClient.Connected
              Notes =  'Timeout occurred connecting to port'
                               } 
              echo $ps1
      } #end of Else
  $Issue  = $Null
  $TCPClient.Dispose()
  
 } # end of foreach
}

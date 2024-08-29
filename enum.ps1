function whost($a) {

    Write-Host -ForegroundColor Black $lines
    Write-Host -ForegroundColor Black " "$a 
    Write-Host -ForegroundColor Black $lines
}


Function Create_File {

    Write-Host "[+] Files started to be created" -ForegroundColor Green

    Start-Sleep -Seconds 5
    
    $filePath_Service = "C:\Users\Public\Documents\Servis_Enum.txt"
    $filePath_Process = "C:\Users\Public\Documents\Process_Enum.txt"
    $filePath_usr_group = "C:\Users\Public\Documents\User_and_Group.txt"
    $filePath_wireless = "C:\Users\Public\Documents\Wireless.txt"
    $filePath_network_info = "C:\Users\Public\Documents\Net_info.txt"
    $filePath_general_things = "C:\Users\Public\Documents\General.txt"

    

    try {
    New-Item -Path $filePath_Service -ItemType File -Force
    New-Item -Path $filePath_Process -ItemType File -Force
    New-Item -Path $filePath_usr_group -ItemType File -Force
    New-Item -Path $filePath_wireless -ItemType File -Force
    New-Item -Path $filePath_network_info -ItemType File -Force
    New-Item -Path $filePath_general_things -ItemType File -Force


    }
    catch {
        Write-Host "[-] File could not be created" -ForegroundColor Red
        return
    }

    Start-Sleep -Seconds 3

}

Function Wireless {

    Write-Host "[+] Wireless Enumeration Started " -ForegroundColor Green 

    Start-Sleep -Seconds 5

    $wireless_profile_name = netsh wlan show profiles | findstr "All User Profile"

    $profiles = netsh wlan show profiles

    $all_profile_name_for_password = $profiles | Select-String -Pattern "All User Profile" | ForEach-Object {
    $_.Line -replace "^\s+All User Profile\s+:\s+", ""
    }

    Add-Content -Path "C:\Users\Public\Documents\Wireless.txt" -Value $wireless_profile_name
    Add-Content -Path "C:\Users\Public\Documents\Wireless.txt" -Value "------------------------------------"
l


    foreach ($baran in $all_profile_name_for_password) {
        $wireless_password = netsh wlan show profiles name="$baran" key=clear | findstr  "Key Content"
        Add-Content -Path "C:\Users\Public\Documents\Wireless.txt" -Value $wireless_password
    }

     Write-Host "Wireless names and passwords are succesfully written to C:\Users\Public\Documents\Wireless.txt"

    

}
Function Network_Information {

    Write-Host "[+] Network Enumeration Started" -ForegroundColor Green 

    Start-Sleep 5

    $line = "-------------------------------------"

    $route_table = Get-NetRoute -AddressFamily IPv4
    Add-Content -Path "C:\Users\Public\Documents\Net_info.txt" -Value "Route Table"
    $route_table | ForEach-Object {
        Add-Content -Path "C:\Users\Public\Documents\Net_info.txt" -Value "$($_.DestinationPrefix) $($_.NextHop) $($_.RouteMetric) $($_.ifIndex)"
    }

    $ntstat = & netstat -ano
    Add-Content -Path "C:\Users\Public\Documents\Net_info.txt" -Value $line
    Add-Content -Path "C:\Users\Public\Documents\Net_info.txt" -Value "Netstat"
    Add-Content -Path "C:\Users\Public\Documents\Net_info.txt" -Value $ntstat
    Add-Content -Path "C:\Users\Public\Documents\Net_info.txt" -Value $line

    $IPv4 = Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' } | Select-Object -ExpandProperty IPAddress
    Add-Content -Path "C:\Users\Public\Documents\Net_info.txt" -Value "IP Address"
    Add-Content -Path "C:\Users\Public\Documents\Net_info.txt" -Value $IPv4

    Write-Host "Network Information are succesfully written to C:\Users\Public\Documents\Net_info.txt"
}



Function User_and_Group {
    Write-Host "[+] User and Group Enumeration Started" -ForegroundColor Green 

    Start-Sleep -Seconds 5

    $user = Get-LocalUser | Select-Object -ExpandProperty Name
    $group = Get-LocalGroup | Select-Object -ExpandProperty Name
    $username_and_gr = Get-LocalGroup | Select-Object -ExpandProperty Name
    $line = "------------------------------------"
    
    

    Add-Content -Path "C:\Users\Public\Documents\User_and_Group.txt" -Value $line
    Add-Content -Path "C:\Users\Public\Documents\User_and_Group.txt" -Value "Username:"
    Add-Content -Path "C:\Users\Public\Documents\User_and_Group.txt" -Value $user 
    Add-Content -Path "C:\Users\Public\Documents\User_and_Group.txt" -Value $line
    Add-Content -Path "C:\Users\Public\Documents\User_and_Group.txt" -Value "Group:"
    Add-Content -Path "C:\Users\Public\Documents\User_and_Group.txt" -Value  $group
    Add-Content -Path "C:\Users\Public\Documents\User_and_Group.txt" -Value $line

    foreach ($groupName in $username_and_gr) {
    $groupMembers = Get-LocalGroupMember $groupName
    
    Add-Content -Path "C:\Users\Public\Documents\User_and_Group.txt" -Value  "Group: $groupName"
    
    foreach ($member in $groupMembers) {
        Add-Content -Path "C:\Users\Public\Documents\User_and_Group.txt" -Value " Member: $($member.Name)"
    }
    
    }
    
    Write-Host "User and Group names are succesfully written to C:\Users\Public\Documents\User_and_Group.txt"

}


Function Serv{

        Write-Host "[+] Service Enumeration started" -ForegroundColor Green

        Start-Sleep -Seconds 5

        $get_serv = Get-Service | Where-Object { $_.Status -eq 'Running' } | Select-Object -ExpandProperty Name

    foreach ($Service in $get_serv) {
        try {
            Add-Content -Path "C:\Users\Public\Documents\Servis_Enum.txt" -Value $Service 
        }
        catch {
            Write-Host "[-] $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-Host "Service names are succesfully written to C:\Users\Public\Documents\Servis_Enum.txt"

}

Function Proc{

    Write-Host "[+] Process Enumeration started" -ForegroundColor Green 

    Start-Sleep -Seconds 5

    $get_proc = Get-Process | Select-Object -ExpandProperty ProcessName

    foreach ($procs in $get_proc){
        try {
            Add-Content -Path "C:\Users\Public\Documents\Process_Enum.txt" -Value $procs
        }
        catch {
             Write-Host "[-] $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    Write-Host "Process names are succesfully written to C:\Users\Public\Documents\Process_Enum.txt"


}

Function important_things {

    Write-Host "[+] General Enumeration started" -ForegroundColor Green 

    Start-Sleep -Seconds 5

    $last_downloaded_app = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*").DisplayName
    $line = "---------------------------"

    $about_computer = systeminfo | Select-String "Host Name","OS Version","System Type","System Directory"

    Add-Content -Path "C:\Users\Public\Documents\General.txt" -Value "Last Downloaded Application"
    Add-Content -Path "C:\Users\Public\Documents\General.txt" -Value $line
    Add-Content -Path "C:\Users\Public\Documents\General.txt" -Value $last_downloaded_app
    Add-Content -Path "C:\Users\Public\Documents\General.txt" -Value $line
        Add-Content -Path "C:\Users\Public\Documents\General.txt" -Value "Computer Information"


    foreach ($computer in $about_computer){
        Add-Content -Path "C:\Users\Public\Documents\General.txt" -Value $computer
    }

    Write-Host "General enumeration output succesfully written to C:\Users\Public\Documents\General.txt"
    


}

Function Run {
    whost "
    ******************************************************************
    ******************************************************************
    **                Windows Enumeration Script (WSC)              **
    **                    Created by: spAce                         **    
    **                                                              **
    **                                                              **
    ******************************************************************
    ******************************************************************"
    Create_File
    User_and_Group
    Serv
    Proc
    Wireless
    Network_Information
    important_things
}

Run


# Created by spAce 
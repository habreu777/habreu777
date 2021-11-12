<#
When creating a new user we need to add a spacial HR/ADP code as an attribute.

I find that it takes a long time searching for users with / withour the code set
and having to add the code to the correct location. So, as a coder, I created this
script to address this.

see if you can improve it to do other things, and share with me.

Thanks

Hector Abreu
githun@habreu777

 #>

#loop to check if entered user name is valid
Do {
clear-host
#enter samaccountname or full name of User (full name needs to be an exact match, not case sensitive)
$name = Read-Host "Name of user to test if ADP Associate ID is set"


$User = $(try {Get-ADUser $Name} catch {$null})

#check if user was found and output the result
If ($user) {write-host $name, " found"
Get-ADUser -identity $user -properties homedirectory, extensionAttribute1 | where {$_.homedirectory -ne $null} | ft Name, extensionAttribute1 | Out-Null

} Else {
#if user entered was not found then display a list of AD users without their ADP code set.
clear-host
write-host $name, " was not found"
write-host""
write-host "Give me a minute while I put together a list of users with their ADP code not yet set..."
Get-ADUser -filter * -properties homedirectory, extensionAttribute1 | where {$_.Enabled -eq $True -And $_.SamAccountName -notlike "*admin*" -And $_.SamAccountName -notlike "career*"  -And $_.SamAccountName -notlike "*templat*" -And $_.SamAccountName -notlike "*helpd*" -and $_.homedirectory -ne $null -And $_.extensionAttribute1 -eq $null} | ft Name

#module to manage the adp code
function Show-Menu {
    param (
        [string]$Title = 'ADP Associate ID Manager'
    )
    #Clear-Host
     
    Write-Host "================ $Title ================"
    
    Write-Host "1: Press '1' to add ADP Associate ID to a user."
    Write-Host "2: Press '2' to remove ADP Associate ID from a user."
    Write-Host "q: Press 'Q' to quit."
}

do
 {
    Show-Menu
    $selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    '1' {
          $getuser  = Read-Host "Name of user to set ADP Associate ID for: "
          $adpcode = read-host "Enter ADP code for ", $getuser
          #$ThisUser = Get-ADUser -Identity $getuser -Properties extensionAttribute1
          Set-ADUser –Identity $getuser -add @{"extensionattribute1"="$adpcode"}
    
 } '2' {
         $getuser  = Read-Host "Name of user to clear ADP Associate ID for "
         $ThisUser = Get-ADUser -Identity $getuser -Properties extensionAttribute1
         Set-ADUser –Identity $thisuser -Clear "extensionattribute1" 
     
    } '3' {
      'Godd bye'
    }
    }
    pause
 }
 until ($selection -eq 'q')
exit


}

#end loop if user exists, otherwise go to top and try again
}Until ($user)

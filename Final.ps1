#This function saves Computer name, time, version, processes grouped by session ids and open sockets to a desired txt file.
#

function Save-SurveyFile(){
    #Asks user for txt file path
    param([Parameter(Mandatory=$true)] $OutputFile)

    #Getting computer name
    $name = $env:COMPUTERNAME
    #Getting date and time
    $time = Get-Date
    #Getting windows version name
    $version = gwmi win32_operatingsystem | % caption

    # Getting session ids
    $sessionIds = get-process | Select-Object -Expand SI -uniq
    $sessions = @()
    $sep = "############################"

    #Looping though session ids
    foreach ($id in $sessionIds){
        $sessions += $sep
        $sessions += "Session Number $id"
        # Getting processes filtered by session ids and saving it to an array
        $sessions += $(get-process | Where-Object {$_.SI -match $id})
      }

    #Getting open sockets
    $openSockets = netstat -a -o -n

    #Saving all info to a file
    echo $name $sep $time $sep $version $sep $sessions $sep $openSockets > $OutputFile

}

#This function gets the hashes of all files in a given directory and saves it in a txt file named "Hash.txt" in the same directory
function Hash-Directory(){
#Asks the user for a directory
    param([Parameter(Mandatory=$true)] $Dir)

#Loop the directory files
    $hashes = @()
    Get-ChildItem $Dir | Foreach-Object {
    #Getting the file hash
        $hashes += Get-FileHash $_.FullName
    }
    
    #Saves all the hases to "Hash.txt file"
    echo $hashes > $Dir\hash.txt
}

#This function entertain the user by giving him a math problem
function Play-Math(){
    #Asks the user for maximum range
    param([Parameter(Mandatory=$true)] $MaximumNumber)
    
    echo "Before you answer make sure the volume is up"

    #Generate the qeustion
    $numberOne = Get-Random -Maximum $MaximumNumber
    $numberTwo = Get-Random -Maximum $MaximumNumber
    $answer = Read-Host "Whats $numberOne + $numberTwo ?" 
    

    #Checks is answer is correct
    if ($answer -eq ($numberOne + $numberTwo)){
        (new-object -com SAPI.SpVoice).speak(“Hurray, thats correct!”)
    }
    else{
        (new-object -com SAPI.SpVoice).speak(“No, loser.”)
    }

}
#lmi

if (-not (test-path env:LMIDEPLOYID)) 
{ 
    $env:LMIDEPLOYID = '01_7xa4jho24dqv5v4bfjhwasvsds7nyyrfb7fyb'
}

#tsji  DEPLOYID=01_gz162dh20kht8x39r8v2qawrm0ulqy248olpw

$lmimsiurl = "https://secure.logmein.com/logmein.msi"
$lmimsifile = "$env:temp\LogMeIn.msi"

Start-Service BITS
Import-Module BitsTransfer

Start-BitsTransfer -Source $lmimsiurl -Destination $lmimsifile -TransferType Download


#TODO read the description from the registry to pre-populate... dunno how to do going forward since no sync...


msiexec.exe /i "$lmimsifile" /qn "DEPLOYID=$env:LMIDEPLOYID" INSTALLMETHOD=5 FQDNDESC=1



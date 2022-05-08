function touch($myfile){ #touch
    if(Test-Path $myfile){
        Set-ItemProperty $myfile LastWriteTime (Get-Date)
        Get-Item $myfile
    }else{
        New-Item $myfile -type file
    }
}
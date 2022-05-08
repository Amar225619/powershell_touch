function touch($myfile){ #touch w/ NewFile Extension
    if(Test-Path $myfile){
        Set-ItemProperty $myfile LastWriteTime (Get-Date)
        Get-Item $myfile
    }else{
        $extlist=@{}
        if(-not(Test-Path "~/PwshNew/")){New-Item "~/PwshNew/" -type Directory}
        Get-ChildItem "~/PwshNew/" | ForEach-Object {$extlist.Add( ($_.Extension).Trim(".").ToUpper(), $_)}
        $ext=([System.IO.Path]::GetExtension($myfile)).Trim(".").ToUpper()
        $Template = $extlist.($ext)
        if ($null -eq $Template) {
            New-Item $myfile -type file
        } else {
            Copy-Item -Path ($Template).FullName -Destination $myfile -Recurse
            Set-ItemProperty $myfile LastWriteTime (Get-Date)
            Get-Item $myfile
        } 
    }
}
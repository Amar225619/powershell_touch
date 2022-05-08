# Alternative codes
## Primitive
The most simple (just for one-liner) Edition.  
Almost all of 'touch' samples in internet are like this one.  
It returns FileInfo|DirectoryInfo(or those array), ie. avail for pipeline.
### primitive.psm1
```
function touch($myfile){ #touch
    if(Test-Path $myfile){
        Set-ItemProperty $myfile LastWriteTime (Get-Date)
        Get-Item $myfile
    }else{
        New-Item $myfile -type file
    }
}
```
## Single File Edition (No-Switch)
Supports "Template Function".  
Single File Edition.  
No switches.  
Actually, This version is useful enough, because FileName supports wild-card(*) by powershell's default.  
### touch-single.psm1
```
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
```
## No Document Edition
The final source code has become too long due to the long description.  
Many users, including myself, will not need a descriptive text.  
Except for the help documentation, this code is exactly the same as the source code at the root.  
This version enables almost the same switchs as the touch command on FreeBSD, and accepts multiple target files.  
### NoDocument.psm1
```
function Touch_Item(){
    enum StampTarget {
        LastWriteTime = 0
        LastAccessTime = 1
    }
    $Recurse = $false
    $StampTarget = [StampTarget]'LastWriteTime'
    $DoNotCreate = $false
    $TargetFiles = @()
    $TargetRecrs = @()
    $i=0
    while($i -lt $args.count){
        $arg = $args[$i]
        if($arg -match "^-"){
            if($arg.ToUpper() -eq '-RECURSE'){
                $Recurse = $true
            }else{
                :labelFor for ($j=1; $j -lt $arg.length; $j++){
                    switch -CaseSensitive ($arg[$j]){
#                       'A' {{$AdjustStr=$args[$i+1];$i++};$DoNotCreate=$true;Break labelFor}
                        'a' {$StampTarget = [StampTarget]'LastAccessTime'}
                        'c' {$DoNotCreate = $true}
#                       'h' {$SymbolicLink = $true}
                        'm' {$StampTarget = [StampTarget]'LastWriteTime'}
                        'r' {if(-not($args[$i+1] -match "^-")){$ReferenceFile=$args[$i+1];$i++};Break labelFor}
                        't' {if(-not($args[$i+1] -match "^-")){[String]$TimeLiteral=$args[$i+1];$i++};Break labelFor}
                        'd' {if(-not($args[$i+1] -match "^-")){[String]$TimeLiteral=$args[$i+1];$i++};Break labelFor}
                    }
                }
            }
        }else{
            $TargetFiles += $arg
        }
        $i++
    }
    $TargetDate = Get-Date
    if($null -ne $TimeLiteral){
        if($TimeLiteral -match "^\d{8,12}(\.\d{1,2})?$"){
            if(-not(($p=$TimeLiteral.IndexOf('.'))+1)){$p=$TimeLiteral.Length}
            $tStr=( $TimeLiteral.Substring(0,$p-8)+"/"+             # [CC[YY]]
                    $TimeLiteral.Substring($p-8,2)+"/"+             # MM
                    $TimeLiteral.Substring($p-6,2)+" "+             # DD
                    $TimeLiteral.Substring($p-4,2)+":"+             # hh
                    $TimeLiteral.Substring($p-2).Replace('.',':'))  # mm[.SS]
            if($tStr -match "^\/"){$tStr = (Get-Date).Year.ToString() + $tStr}
            $TargetDate = Get-Date($tStr)
        }else{
            $TargetDate = Get-Date($TimeLiteral)
        }
    }
    if($null -ne $ReferenceFile){
        if($null -ne ($Ref = Get-ItemProperty $ReferenceFile)){
            $TargetDate = $Ref.$StampTarget
        }
    }
    foreach($myfile in $TargetFiles){
        if(Test-Path $myfile){
            Set-ItemProperty $myfile $StampTarget ($TargetDate)
            $FItem = Get-Item $myfile
            if($Recurse -And $FItem.PSIsContainer){$TargetRecrs+=(Get-ChildItem $FItem -Recurse | ForEach-Object {$_.FullName})}
            Get-Item $FItem
        }elseif(-not($DoNotCreate)){
            $TemplateList=@{}
            $TemplateFolder = "~/PwshNew/"
            if(-not(Test-Path $TemplateFolder)){New-Item $TemplateFolder -type Directory}
            Get-ChildItem $TemplateFolder | ForEach-Object {$TemplateList.Add( ($_.Extension).Trim(".").ToUpper(), $_)}
            $ext=([System.IO.Path]::GetExtension($myfile)).Trim(".").ToUpper()
            $Template = $TemplateList.($ext)
            if ($null -eq $Template) {
                $FItem = New-Item $myfile -type file
                if($null -ne $FItem){
                    Set-ItemProperty $FItem $StampTarget ($TargetDate)
                    Get-Item $FItem
                }
            } else {
                Copy-Item -Path ($Template).FullName -Destination $myfile -Recurse
                $FItem = Get-Item $myfile
                if($null -ne $FItem){
                    Set-ItemProperty $FItem $StampTarget ($TargetDate)
                    if($FItem.PSIsContainer){$TargetRecrs+=(Get-ChildItem $FItem -Recurse | ForEach-Object {$_.FullName})}
                    Get-Item $FItem
                }
            } 
        }
    } 
    foreach($myfile in $TargetRecrs){
        $FItem = Get-Item $myfile
        if($null -ne $FItem){
            Set-ItemProperty $FItem $StampTarget ($TargetDate)
            Get-Item $FItem
        }
    }
}
Set-Alias touch Touch_Item

Export-ModuleMember -Function Touch_Item

Export-ModuleMember -Alias touch
```
## More Information
There is my wiki site:["www.kumechannel.net/wiki/"](https://www.kumechannel.net/wiki/win/powershell/touch) that scribbles the details of this program creation (Japanese only).  Please refer to it if you like.  
このプログラムのコーディングの経緯を殴り書きしたサイトがあります（日本語のみ）。よろしければ、参考にしてください。
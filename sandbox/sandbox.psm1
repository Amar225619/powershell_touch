#####################################

function flagtest(){
    enum StampTarget {
        Nothing = 0
        CreationTime       = 1
        LastAccessTime     = 2
        Create_And_Access  = 3
        LastWriteTime      = 4
        Create_And_Write   = 6
        Access_And_Write   = 6
        All                = 7
#       UTC                = 8
#       CreationTimeUtc    = 9
#       LastAccessTimeUtc  = 10
#       U_Creat_And_Access = 11
#       LastWriteTimeUtc   = 12
#       U_Creat_And_Write  = 13
#       U_Access_And_Write = 14
#       U_All              = 15
        
    }
    $DefaultTimeStamp = [StampTarget]'Access_And_Write'
    $myTarget = $DefaultTimeStamp

    $myTarget
    if([StampTarget]$f=([StampTarget]'LastWriteTime' -band $myTarget)){
        $f
    }
    if([StampTarget]$f=([StampTarget]'LastAccessTime' -band $myTarget)){
        $f
    }

}


function paramstest(){
    [CmdletBinding()]
    [OutputType([Object[]])] 
    Param(
        [Parameter(Mandatory=$false)]
        [switch]$a,
        [switch]$c,
        [switch]$m,
        [string]$r,
        [string]$t, 
        [string]$d,
        [switch]$Recurse,
        [Parameter(Mandatory=$false,Position=0,ValueFromRemainingArguments=$true,ValueFromPipeline=$true)]
        $FileNames
    ) 

    begin{
        #confilict check
            # a & m
            # r & t & d
        #isdate
        if(0 -lt $d.Length){
            if($d -match "^\d{8,12}(\.\d{1,2})?$"){
                write-host "Not Yet"
            }else{
                write-host "NOT Match"
                Throw "-d function"
            }
        }
    }
    process{
                
        #    $args
        Write-Host "a : $a "
        Write-Host "c : $c "
        Write-Host "m : $m "
        Write-Host "r : $r "
        Write-Host "t : $t "
        Write-Host "d : $d "
#        Write-Host "FileNames/Type : "+($FileNames).gettype().tostring()
        Write-Host "FileNames : "
        $FileNames
        
    }

}


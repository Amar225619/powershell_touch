# powershell_touch
'touch' command works on PowerShell.  
## MAMES:
```
function : touch_item()
alias    : touch
```
## TESTED VERSIONS:
```
PowerShell         : 7.2.3     (Windows10 ja-JP)
Windows PowerShell : 5.1.19041 (Windows10 ja-JP)
```
## USAGE
```
PS > cd ~/Documents/[Windows]PowerShell/Modules # If Moodule Folder not-exist, Make it.
PS > git clone https://github.com/masahiro-kume/powershell_touch.git
...... Restart Powershell
```
## 使い方
```
PS > cd ~/Documents/[Windows]PowerShell/Modules # Moodule フォルダがない場合は作成してください
PS > git clone https://github.com/masahiro-kume/powershell_touch.git
...... Powershellを再立ち上げしてください
```
## DESCRIPTION:

    [SYNOPSIS]
        UNIX 'touch' command with some extensions

        Touch_Item [-acm] [-r file] [(-t)|(-d) '[[CC]YY]MMDDhhmm[.SS]'|'Windows-DateTime-String'] [-Recurse] file ...

           returns FileInfo/DirectoryInfo(Array) not boolean(0|1).
           makes NewFiles with specifed Extension from the template folder.
           supports [-Recurse] Action into SubFolders.

    [DESCRIPTION]
    Imitated to  https://www.freebsd.org/cgi/man.cgi?query=touch
    But, some default actions are differnt from 'touch', so read carefully who are familiar with UNIX/Linux commands.
        * Returns FileInfo|DirectoryInfo(or those array), but not boolean(0|1).
        * Returns $null when nothing did (or everything errors).
        * -A and -h switches are not supported.
        * Rewrites ONLY modification times (LastWriteTime) by default.
        * Creates NOT-ZERO-LENGTH files if new files's extension matches templates' extension.
        * Windows-DateTime-String
            is allowed any string that can be parsed by Get-Date() such as '61Jun25' and/or '2022-05-07T17:17:00' &c.
        * Works with Wild-Card(*).
        * Creates new Directory. (template directories must be prepared)
        * Recurse action is avalable.
        * If some errors occur in action, basically those are ignored,
            and shows each inline-commandlet's error message.

     The touch utility sets the	modification and access times of files. 
     If any file does not exist, it is created with default permissions.
     '~/PwshNew' is a special folder that contains 'Template.EXT's.
     Put blank data files such as 'Template.xlsx' as templates in that folder.
 
     By default, Touch_Item changes only modification times.
     The -a and -m flags may be used to select the access time (LastAccessTime) or the modification time (LastWriteTime) individually.
     Selecting both is not available. (the latest switch has priority).
     By default, the timestamps are set to the current time.
     The -d and -t flags expliitly specify a different time, and the -r flag specifies to set the times those of the specified file.


     The following options are available:

     -a      Change the access time (LastAccessTime) of the file.
             The modification time of the file is not changed.
             The -m flag is not available if this flag setted.

     -c      Do not create the file if it does not exist.

     -d      Change the access and modification	times to the specified datetime instead of the current time of day.
             The argument is of the form Datetime-string which is parsable by Get-Date commandlet.
             A string such as "YYYY-MM-DDThh:mm:SS[.frac][z]" is also available, but [t] option cannot work,
             where the letters represent the following:
                YYYY                At least four decimal digits representing the year.
                MM, DD, hh, mm, SS  As with -t time.
                T                   The letter T or a space is the time designator.
                [.frac]             An optional fraction, consisting of a period followed by one or more digits.
                                    The comma will not work. (depens on The Culture of windows environment)
                [z]                 An optional letter Z indicating the time is in UTC.
                                    Otherwise, the time is assumed to be in local time.
             This flag accepts "[[CC]YY]MMDDhhmm[.SS]" style, so this flag is completely same as -t. 

     -h      This flag is not supported in Touch_Item. (ignored)
             If the file is a symbolic link,
             Touch_Item changes the times of the file that the link points to, rather than the symbolic-link itself.
             (The same result occurs between in FreeBSD and Windows.)
             To implement this option is very complicated in Windows File System, so ommited in this version.

     -m      Change the modification time (LastWriteTime) of the file.
             The access time of the file is not changed.
             When this flag setted, the -a flag is set to $false.

     -r      Use the access and modifications times from the specified file instead of the current time of day.

     -t      Change the access and modification times to the specified time instead of the current time of day.
             The argument is of the form "[[CC]YY]MMDDhhmm[.SS]" where each pair of letters represents the following:
               CC      The first two digits of the year (the century).
               YY      The second two digits of the year.
                       "YYCC" interpretation is different from 'touch' -t.
                       It depens on Get-Date operation. (9 or 999 &c are available in Get-Date.)
               MM      The month of the year, from 01 to 12.
               DD      the day of the month, from 01 to 31.
               hh      The hour of the day, from 00 to 23.
               mm      The minute of the hour, from 00 to 59.
               SS      The second of the minute, from 00 to 60.
             If the "CC" and "YY" letter pairs are not specified, the values default to the current year.
             If the "SS" letter pair is not specified, the value defaults to 0.
             Inner conversion of date-string uses "YYYY/MM/DD hh:mm:SS" format. (Slash and Space separating)
             This flag accepts Datetime-string, so this flag is completely same as -d. 

    [EXIT STATUS]
     The Touch_Item exits with FileInfo|DirectoryInfo( or those array) on success,
     and errors in action are ignored,
     and if nothing did exit with $null.

    [EXAMPLES]

    PS > Touch_Item [String]FileName
    Basic Usage:
        Modifys LastWriteTime of the File to Current time.
        If File is not exists, NewFile with length=0 will be created.    
    
    PS > Touch_Item FileName FileName ...
    Plural Files:
        Supports plural files.
     
    PS > Touch_Item *.tmp
    Wild-card:
        Supports Wild-card.
    
    PS > Touch_Item FileName.EXT
    Create files with templates:
        If SOMENAME.EXT exists in ~/PwshNew Folder, Creates a new file from a template file.
        This option is useful when blank data file is not 0-length such as 'NewFile.xlsx'.
        If the template is a folder, the new folder copied form template with it's structure,
        and works into child items recursively.
    
    PS > Touch_Item FileName.EXT | ii
    Returns FileInfo:
        Invoke-item with application related extension of new file.
        'Touch_Item NewFile.xlsx | ii' invokes Microsoft(R) Excel for example.
    
    PS > Touch_Item -a FileName
    LastAccessTime:
        Changes LastAccessTime instead of LastWriteTime.
    
    PS > Touch_Item -c FileName
    Not-Creation Option:
        Not Creat a new file even if it is not exists.
    
    PS > Touch_Item -d 'YYYY-MM-DDThh:mm:ss' FileName
    Specifies datetime instead of current time:
        Date string is acceptable in various description.
        See DESCRIPTION in detail.
        Same behavior with -t flag. 
    
    PS > Touch_Item -t '[[CC]YY]MMDDhhmm[.SS]' FileName
    Specifies datetime instead of current time:
        Date string is acceptable in various description.
        See DESCRIPTION in detail.
        Same behavior with -d flag. 
    
    PS > Touch_Item -r ReferenceFile FileName
    Specifies datetime instead of current time:
        The datetime is read from the refernse file.
    
    PS > Touch_Item -Recurse FolderName
    Recurse action into folders:
        If the target item(s) were [Container], Touch_Item works to child items. 
## 説明：  

    [概要]
        UNIXの「touch」コマンドに似せた関数（PowerShell的に機能拡張）

        Touch_Item [-acm] [-r file] [（-t）|（-d）'[[CC] YY] MMDDhhmm [.SS]' |'Windows-DateTime-String'][-Recurse]file。 ..

           * FileInfo または DirectoryInfo（配列）を返します。UNIX-touchの0または1ではありません。
           * テンプレートフォルダにある同じ拡張子を持つファイルを新規ファイルとしてコピーします。
           * サブフォルダへの[-Recurse]アクションをサポートします。

    [説明]
    https://www.freebsd.org/cgi/man.cgi?query=touchに寄せて作ってあります。
    ただし、一部のデフォルトのアクションは「touch」とは異なるため、UNIX/Linuxコマンドに精通している人は注意深く読んでください。
        * FileInfo | DirectoryInfo（またはそれらの配列）を返しますが、boolean（0 | 1）は返しません。
        * 何もしなかった場合（またはすべてがエラー時）に$nullを返します。
        * -Aおよび-hスイッチはサポートされていません。
        * デフォルトでは更新日時（LastWriteTime）のみを書き換えます。
        * 新しいファイルの拡張子がテンプレートの拡張子と一致する場合、長さが０ではないファイルを作成します。
        * Windows-DateTime-文字列
            '61Jun25'や'2022-05-07T17：17：00'などのGet-Dateでパース可能な任意の文字列が許可されています。
        * ワイルドカード（*）で動作します。
        * 新しいディレクトリを作成します。 （ディレクトリのテンプレートを準備する必要があります）
        * 再帰アクションが利用可能です。
        * 動作中にエラーが発生した場合、基本的にそれらは無視されます。
            （インラインの各コマンドレットのエラーメッセージを表示します。）
    
     この関数は、ファイルの更新日時とアクセス日時を設定します。
     ファイルが存在しない場合は、デフォルトの権限で作成されます。
     '~/PwshNew'は、「テンプレート.EXT」などのテンプレートを含むフォルダです。
     'Template.xlsx'などの空白のデータファイルをテンプレートとしてそのフォルダーに配置します。
 
     デフォルトでは、Touch_Itemは更新日時のみを変更します。
     -aフラグと-mフラグを使用して、アクセス日時（LastAccessTime）または更新日時（LastWriteTime）を個別に選択できます。
     両方を選択することはできません。 （最後のスイッチが優先されます）。
     デフォルトでは、タイムスタンプは現在の時刻に設定されています。
     -dフラグと-tフラグは明示的に異なる時刻を指定し、-rフラグは指定されたファイルの時刻を設定するように指定します。


     次のオプションを使用できます。

     -a ファイルのアクセス日時（LastAccessTime）を変更します。
             ファイルの更新日時は変更されません。
             このフラグが設定されている場合、-mフラグは使用できません。

     -c ファイルが存在しない場合は作成しません。

     -d アクセス日時と更新日時を、現在の時刻ではなく、指定された日時に変更します。
             引数は、Get-Dateコマンドレットで解析可能なDatetime-stringの形式です。
             「YYYY-MM-DDThh:mm:SS[.frac][z]」などの文字列も使用できますが、[t]オプションは機能しません。
             ここで、文字は次のことを表します。
                YYYY                  年を表す少なくとも4桁の10進数。
                MM、DD、hh、mm、SS     -tと同様。
                T                     文字「T」またはスペースは時間指定子です。
                [.frac]               ピリオドとそれに続く1桁以上の数字で構成されるオプションの分数。
                                      カンマは機能しません。 （Windows環境のカルチャーに依存します）
                [z]                   時刻がUTCであることを示すオプションの文字Z。
                                      それ以外の場合、時刻は現地時間であると見なされます。
             このフラグは「[[CC]YY]MMDDhhmm[.SS]」の文字列を受け入れるため、このフラグは「-t」と完全に同じです。

     -h      このフラグはTouch_Itemではサポートされていません。 （無視されます）
             対象のファイルがシンボリックリンクの場合、Touch_-Itemは、シンボリックリンク自体ではなく、
             リンクが指すファイルの時間を変更します。（FreeBSDとWindowsで同じ動きをします。）
             このオプションを実装することは、Windowsのファイルシステムでは非常に複雑であるため、このバージョンでは省略されています。

     -m      ファイルの更新日時（LastWriteTime）を変更します。
             ファイルのアクセス日時は変更されません。
             このフラグが設定されると、-aフラグは$falseに設定されます。

     -r      現在の時刻ではなく、参照されるファイルのアクセス日時または更新日時を使用します。

     -t      アクセス日時と更新日時を、現在の時刻ではなく、指定した時刻に変更します。
             引数の形式は「[[CC]YY]MMDDhhmm[.SS]」で、文字の各ペアは次のことを表します。
               CC      年（世紀）の最初の2桁。
                       YY年の2番目の2桁。
                       「YYCC」の解釈は「touch」-tとは異なります。
                       Get-Date操作に依存します。 （9または999＆cはGet-Dateで使用できます。）
               MM      01から12まで(月)
               DD      01から31まで(日)
               hh      00から23まで(時)
               mm      00から59まで(分)
               SS      00から60まで(秒)
             「CC」と「YY」の文字のペアが指定されていない場合、値はデフォルトで現在の年になります。
             「SS」文字ペアが指定されていない場合、値はデフォルトで0になります。
             日付文字列の内部変換では、「'YYYY/MM/DD hh:mm:SS」形式が使用されます。 （スラッシュとスペースで分離）
             このフラグはDatetime-stringを受け入れるため、このフラグは-dと完全に同じです。

    [終了ステータス]
     Touch_Itemは、成功するとFileInfoまたはDirectoryInfo（またはそれらの配列）で終了します。
     動作中のエラーは無視されます。
     何もせず終了した場合は$nullを返します。

    [コマンド例]
    PS > Touch_Item [String]ファイル名
    基本的な使用法：
        ファイルのLastWriteTimeを現在の時刻に変更します。
        ファイルが存在しない場合、長さ0の新しいファイルが作成されます。
    
    PS > Touch_Item ファイル名 ファイル名 ...
    複数ファイル：
        複数のファイルをサポートします。
    
    PS > Touch_Item *.tmp
    ワイルドカード：
        ワイルドカードをサポートします。
    
    PS > Touch_Item FleName.EXT
    テンプレートを使用してファイルを作成します。
        SOMENAME.EXTが~/PwshNewフォルダーに存在する場合、テンプレートファイルから新しいファイルを作成します。
        このオプションは、新規のデータファイルが「NewFile.xlsx」のように長さが0でない場合に役立ちます。
        テンプレートがフォルダの場合、新しいフォルダはその構造でテンプレートをコピーし、フォルダ内を再帰的に処理します。
    
    PS > Touch_Item FileName.EXT | ii
    この関数はFileInfoを返すので、パイプライン処理が可能です：
        新しいファイルのアプリケーション関連の拡張子をもとにアプリをインボーク出来ます。
        例えば、'PS > Touch_Item NewFile.xlsx| ii'は、マイクロソフトエクセルExcelを呼び出します。
    
    PS > Touch_Item -a ファイル名
    LastAccessTime：
        LastWriteTimeの代わりにLastAccessTimeを変更します。
    
    PS > Touch-Item -c ファイル名
    非作成オプション：
        存在しない場合でも、新しいファイルを作成しません。
    
    PS > Touch-Item -d'YYYY-MM-DDThh:mm:ss' ファイル名
    現在の時刻の代わりに日時を指定します。
        日付文字列は、さまざまな様式で受け入れ可能です。
        詳細については、[説明]を参照してください。
        -tフラグを使用した場合と同じ動作をします。
    
    PS > Touch-Item -t'[[CC]YY]MMDDhhmm[.SS]' ファイル名
    現在の時刻の代わりに日時を指定します。
        日付文字列は、さまざまな様式で受け入れ可能です。
        詳細については、[説明[を参照してください。
        -dフラグを使用した場合と同じ動作をします。
    
    PS > Touch-Item -r 参照ファイル名 ファイル名
    現在の時刻の代わりに日時を指定します。
        日時は参照ファイルから読み取られます。
    
    PS > Touch-Item -Recurse フォルダ名
    フォルダ内を再帰的に処理します。

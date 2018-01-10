@echo off
title Secure File Encrypter
::Set Global Variables
setlocal  ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
set "version=1.0.4"
set "debug="
set "translator=.translator"
set "transpath=relative"
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxywz0123456789"
set "charnum=16"
set "encryption=yes"
set "hide=yes"
set "tmpfile=.tmp"
set "encode=yes"
set "settings=.settings"
set "encryptedmsg=ENCRYPTEDFILES"
set "code=xhfaj46qyih2k50uid9t6qwg"
set "excpt="
::-----------------------------------------------------------------------------------------------
::dirty code
set "nullchecker="
if exist %settings% (
	for /f "tokens=1,2 delims==" %%a in ('find "debug=" %settings% ^| findstr debug=') do (set "debug=%%b")
	for /f "tokens=1,2 delims==" %%a in ('find "translator=" %settings% ^| findstr translator=') do (set "translator=%%b")
	for /f "tokens=1,2 delims==" %%a in ('find "transpath=" %settings% ^| findstr transpath=') do (set "transpath=%%b")
	for /f "tokens=1,2 delims==" %%a in ('find "chars=" %settings% ^| findstr chars=') do (set "chars=%%b")
	for /f "tokens=1,2 delims==" %%a in ('find "charnum=" %settings% ^| findstr charnum=') do (set "charnum=%%b")
	for /f "tokens=1,2 delims==" %%a in ('find "encryption=" %settings% ^| findstr encryption=') do (set "encryption=%%b")
	for /f "tokens=1,2 delims==" %%a in ('find "hide=" %settings% ^| findstr hide=') do (set "hide=%%b")
	for /f "tokens=1,2 delims==" %%a in ('find "tmpfile=" %settings% ^| findstr tmp=') do (set "tmpfile=%%b")
	for /f "tokens=1,2 delims==" %%a in ('find "encode=" %settings% ^| findstr encode=') do (set "encode=%%b")
	for /f "tokens=1,2 delims==" %%a in ('find "excpt=" %settings% ^| findstr excpt=') do (set "excpt=%%b")
) else (call :settings)
if "%debug%" equ "yes" (echo:Debug is enabled. & @echo on & pause)
if "%1" equ "/settings" (call :settings %2 iwascalled & exit /b)
if "%1" equ "/?"  %extd% /speak "Secure File Encrypter version %ver%" 2
set "error=0"
::-----------------------------------------------------------------------------------------------
if "%~3" neq "" (
  >&2 echo ERROR: Too many arguments
  exit /b 1
)
::-----------------------------------------------------------------------------------------------
if /i "%~1" equ "/s" (set "switch=/s") else if /i "%~1" equ "/u" (set "switch=/u") else if "%~1" neq "" set "filter=%~1"
if /i "%~2" equ "/s" (set "switch=/s") else if /i "%~2" equ "/u" (set "switch=/u") else if "%~2" neq "" (
  if defined filter (
    >&2 echo ERROR: Only one filter allowed
    exit /b 1
  ) else set "filter=%~2"
)
if "%filter:~0,1%" equ "/" (
  >&2 echo ERROR: Invalid switch %filter%
  exit /b 1
)
:: scan for repeating switch
if /i "%~1" equ "/s" if /i "%~2" equ "/s" echo: Multiple switch %1 detected & exit /b 1
if /i "%~1" equ "/u" if /i "%~2" equ "/u" echo: Multiple switch %1 detected & exit /b 1

:: Determine source and if /S switch not specified
set "src="
if not defined switch for /f "eol=: delims=" %%F in ("%filter%") do set "src=%%~dpF"
set "errorlevel=0"
if defined filter (
	echo %filter% | findstr ^:^\ > nul 2>&1
	if %errorlevel%==0 (
		if not exist %filter%  ( echo Invalid location %filter% & exit /b 1
		) else set "src=%filter%\"
	)
)
if "%src%"=="*\" ( set "src=%cd%\" ) 
if not defined src set "src=%cd%\"

:: Parsing Switches
if "%switch%" equ "/u" (call :recovery &exit /b) 
if "%switch%" equ "/s" (
	set "param=all" & set "options=/a-d-h /b /s" & set "optiond=/ad /b /s"
) else (
	set "param=gen" & set "options=/a-d-h /b"
)
::-----------------------------------------------------------------------------------------------
if exist %translator% (
	%extd% /speak "Warning!!. This Destination is already Encrypted. if you want to proceed, you need to decrypt the files first. Please enter yes, to proceed." 3
	echo Enter yes if you want to continue:
	set /p ans=
	if "!ans!" equ "yes" (echo:Recovering files.. & call :recovery error & if "!error!" neq "0" exit /b) else (exit /b)
)
if "%encode%" equ "yes" (echo:Enter your AES key & %extd% /inputbox "AES Encoding" "Enter your AES key. Note! Keep your key safe. " "%code%" & set "code=!result!" & echo:Encrypting..)
::-----------------------------------------------------------------------------------------------
::MAIN
call :charCount myResult %chars% 
set "charR=%myResult%"
if "%param%"=="all" (
	for /f "eol=: delims=" %%x in ('dir %optiond% "%filter%" 2^>nul ^| sort /r') do (call :reName nullchecker "%%x")
	for /f "eol=: delims=" %%x in ('dir %options% "%filter%" 2^>nul') do (call :reName nullchecker "%%x")
	
)
if "%param%"=="gen" (
	for /f "eol=: delims=" %%x in ('dir %options% "%filter%" 2^>nul') do (call :reName nullchecker "%%x")
)
if "%nullchecker%" equ "" (echo:Nothing to Encrypt. Is directory empty^^!?) else (
	call :flip
	if "%hide%" equ "yes" (call :hide)
)
endlocal
exit /b

::-----------------------------------------------------------------------------------------------
::SUBROUTINES
:reName <path & name>
::---------------------Rename Files
setlocal
set "src=%2" & set "src=!src:"=!"
call :exceptions msg "%src%"
if "%msg%" equ "hit" exit /b
set "_path=%~dp2" & set "_old=%~nx2"
:ren
set "%errorlevel%=0"
call :randomNameGenerator _name
if exist "%_path%%_name%" goto :ren
::encodes & renames
if "%encode%" equ "yes" (
	if not exist "%_path%%_old%\" (
		call :endecode "%src%" "!_name!" "encode"
		) else (ren "%_path%%_old%" "%_name%")
) else (
	::renames
	ren "%_path%%_old%" "%_name%"
)
::saves the record
call :saveRecord "%_name%" "%src%"
if "%debug%" equ "yes" pause
( endlocal
	set %~1=ok
)
exit /b

:exceptions <path & name>
::----------------------execptions
setlocal
set "msg="
set "this=%~nx0" & set "this=!this:.cmd=!.exe"
for %%x in (!this! %translator% %excpt% %settings% %tmpfile%) do if "%~nx2" equ "%%x" (set "msg=hit")
if "%msg%" equ "" set "msg=null"
( endlocal
	set %~1=%msg%
)
if "%debug%" equ "yes" pause
exit /b
:randomNameGenerator <randomName>
::---------------------Generate Random Names
setlocal EnableDelayedExpansion
set "_name="
for /l %%N in (1 1 %charnum%) do (
  set /a I=!random!%%%charR%
  for %%I in (!I!) do set "_name=!_name!!chars:~%%I,1!"
)
( endlocal
	set "%~1=%_name%"
)
if "%debug%" equ "yes" pause
exit /b

:charCount <resultVar> <stringVar>
::---------------------CharCount
setlocal
set "temp_str=%2"
set "str_len=0"
:lp
if defined temp_str (
set temp_str=%temp_str:~1%
set /A str_len += 1
goto lp )
( endlocal
	set "%~1=%str_len%"
)
if "%debug%" equ "yes" pause
exit /b

:saveRecord <new_name> <path>
::----------------------Save Records to translator
setlocal EnableDelayedExpansion
set "src=%~dp2" & set "old=%~nx2" & set "old=!old:"=!"
set "newname=%1" & set "newname=!newname:"=!"
set "s_path=%src%%newname%"
set "bitname=%newname:~4%"
::Check for encryption header if written
if not exist %translator% (call :runOnce)
if "%transpath%" equ "full" (
	if "%encryption%" equ "yes" (call :encrypt s_path "%s_path%" & call :encrypt old "%old%")
	echo:!bitname!^|^|!old!^|^|!s_path!>>%translator%
)
if "%transpath%" equ "relative" (
	set "clipPath=!s_path:%cd%\=!"
	if "%encryption%" equ "yes" (call :encrypt clipPath "!clipPath!" & call :encrypt old "%old%")
	echo:!bitname!^|^|!old!^|^|!clipPath!>>%translator%
)
endlocal
if "%debug%" equ "yes" pause
exit /b

:recovery
setlocal EnableDelayedExpansion
set "trans_hide=" & set "trans_encrypt="
if not exist %translator% echo:Translation file not found^^!? & exit /b
for /f "tokens=1,2 delims==" %%a in ('find "encrypted" %translator% ^| findstr encrypted') do (set "trans_encrypt=%%b")
for /f "tokens=1,2 delims==" %%a in ('find "encode" %translator% ^| findstr encode') do (set "trans_encode=%%b")
for /f "tokens=1,2 delims==" %%a in ('find "hidden" %translator% ^| findstr hidden') do (set "trans_hide=%%b")
if "%trans_encode%" equ "yes" (for /f "tokens=1,2 delims==" %%a in ('find "key" %translator% ^| findstr key') do (call :decrypt trans_key %%b))
:keycheck
if "%trans_encode%" equ "yes" (
	echo:Enter your AES key 
	%extd% /inputbox "AES Encoding" "Enter your AES key." "%code%" 
	if "!result!" equ "%trans_key%" (set "code=!result!" & echo:Key Accepted & echo:Please wait while I recover the files..) else (echo:Wrong key!!! & goto :keycheck)
)

if "%trans_hide%" equ "yes" (attrib -s -h %translator% & attrib -s -h %settings%) & if exist %encryptedmsg% (del /f /q %encryptedmsg%)
if "%trans_encrypt%"=="yes" ( 
	for /f "skip=4 tokens=1,2,3 delims=||" %%a in (%translator%) do (
		call :decrypt path_ "%%c"
		call :decrypt name_ "%%b"
		if not exist "!path_!" (set "error=1") else (
			if "%trans_hide%" equ "yes" (attrib -s -h "!path_!")
			if "%trans_encode%" equ "yes" (
				if not exist "!path_!\" (
					call :endecode "!path_!" "!name_!" "decode"
				)else (ren "!path_!" "!name_!")
			) else (ren "!path_!" "!name_!")
			if "!errorlevel!" neq "0" (set "error=1")
		)
	)
) else (
	for /f "skip=4 tokens=1,2,3 delims=||" %%a in (%translator%) do (
		if not exist "%%c" (set "error=1") else (
			if "%trans_hide%" equ "yes" (attrib -s -h "%%c")
			if "%trans_encode%" equ "yes" (
				if not exist "%%c\" (
					call :endecode "%%c" "%%b" "decode"
				)else (ren "%%c" "%%b")
			) else (ren "%%c" "%%b")
		)
	)
)
if "%error%" neq "0" (echo:Errors were found during recovery^^!? Contact Christian Arvin ^(naitsirhc.uriel@gmail.com^) & %extd% /speak "Errors were found during Recovery. Please Contact Christian Arvin, for help." 2) else (del /q /f %translator%)
( endlocal
	set %~1=%error%
)
if "%debug%" equ "yes" pause
exit /b

:endecode <Target Newname>
setlocal ENABLEDELAYEDEXPANSION
set "_path=%~dp1"
set "_cname=%~nx1"
set "_cname=!_cname:"=!"
set "_oname=%2"
set "_oname=!_oname:"=!"
set "option=%3"
set "option=!option:"=!"
if "!option!" equ "encode" (
	%extd% /aesencode "!_path!!_cname!" "!_path!!_oname!" "%code%"
) else if "!option!" equ "decode" (
	%extd% /aesdecode "!_path!!_cname!" "!_path!!_oname!" "%code%"
)
if exist "!_path!!_oname!" del /f /q "!_path!!_cname!"
endlocal
exit /b



:encrypt <out> <input>
::------------------------Encrypt
setlocal  ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
(set "CHAR[_A]=6l")
(set "CHAR[_B]=6m")
(set "CHAR[_C]=6n")
(set "CHAR[_D]=7o")
(set "CHAR[_E]=7p")
(set "CHAR[_F]=7q")
(set "CHAR[_G]=8r")
(set "CHAR[_H]=8s")
(set "CHAR[_I]=8t")
(set "CHAR[_J]=9u")
(set "CHAR[_K]=9v")
(set "CHAR[_L]=9w")
(set "CHAR[_M]=0x")
(set "CHAR[_N]=0y")
(set "CHAR[_O]=0z")
(set "CHAR[_P]=aa")
(set "CHAR[_Q]=ab")
(set "CHAR[_R]=ac")
(set "CHAR[_S]=bd")
(set "CHAR[_T]=be")
(set "CHAR[_U]=bf")
(set "CHAR[_V]=cg")
(set "CHAR[_W]=ch")
(set "CHAR[_X]=ci")
(set "CHAR[_Y]=dj")
(set "CHAR[_Z]=dk")
(set "CHAR[a]=el")
(set "CHAR[b]=em")
(set "CHAR[c]=en")
(set "CHAR[d]=fo")
(set "CHAR[e]=fp")
(set "CHAR[f]=fq")
(set "CHAR[g]=gr")
(set "CHAR[h]=gs")
(set "CHAR[i]=gt")
(set "CHAR[j]=hu")
(set "CHAR[k]=hv")
(set "CHAR[l]=hw")
(set "CHAR[m]=ix")
(set "CHAR[n]=iy")
(set "CHAR[o]=iz")
(set "CHAR[p]=j0")
(set "CHAR[q]=j1")
(set "CHAR[r]=j2")
(set "CHAR[s]=k3")
(set "CHAR[t]=k4")
(set "CHAR[u]=k5")
(set "CHAR[v]=l6")
(set "CHAR[w]=l7")
(set "CHAR[x]=l8")
(set "CHAR[y]=m9")
(set "CHAR[z]=ma")
(set "CHAR[0]=mb")
(set "CHAR[1]=nc")
(set "CHAR[2]=nd")
(set "CHAR[3]=ne")
(set "CHAR[4]=of")
(set "CHAR[5]=og")
(set "CHAR[6]=oh")
(set "CHAR[7]=pi")
(set "CHAR[8]=pj")
(set "CHAR[9]=pk")
(set "CHAR[`]=ql")
(set "CHAR[-]=qm")
(set "CHAR[=]=qn")
(set "CHAR[~]=ro")
(set "CHAR[!]=rp")
(set "CHAR[@]=rq")
(set "CHAR[#]=sr")
(set "CHAR[$]=ss")
(set "CHAR[%]=st")
(set "CHAR[&]=tu")
(set "CHAR[*]=tv")
(set "CHAR[(]=tw")
(set "CHAR[)]=ux")
(set "CHAR[_]=uy")
(set "CHAR[+]=uz")
(set "CHAR[^]=v0")
(set "CHAR[{]=v1")
(set "CHAR[}]=v2")
(set "CHAR[|]=w3")
(set "CHAR[[]=w4")
(set "CHAR[]]=w5")
(set "CHAR[\]=x6")
(set "CHAR[;]=x7")
(set "CHAR[']=x8")
(set "CHAR[,]=y9")
(set "CHAR[.]=ya")
(set "CHAR[/]=yb")
(set "CHAR[<]=zc")
(set "CHAR[>]=zd")
(set "CHAR[?]=ze")
(set "CHAR[ ]=ag")

set "Encrypt2=%2"
set "Encrypt2=!Encrypt2:"=!"
set "EncryptOut="
:enc2
set char=%Encrypt2:~0,1%
set Encrypt2=%Encrypt2:~1%
::Scans for Caps
for %%x in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
	if "%%x" equ "%char%" (set "char=_%char%")
)
if "%char%" equ ":" (set EncryptOut=%EncryptOut%zf) else (
	set EncryptOut=%EncryptOut%!CHAR[^%char%]!
)
if not "%Encrypt2%"=="" goto enc2
( endlocal
	set "%~1=%EncryptOut%"
)
if "%debug%" equ "yes" pause
exit /b

:decrypt <out> <input>
::------------------------Decrypt
setlocal  ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
(set "CHAR[6l]=A")
(set "CHAR[6m]=B")
(set "CHAR[6n]=C")
(set "CHAR[7o]=D")
(set "CHAR[7p]=E")
(set "CHAR[7q]=F")
(set "CHAR[8r]=G")
(set "CHAR[8s]=H")
(set "CHAR[8t]=I")
(set "CHAR[9u]=J")
(set "CHAR[9v]=K")
(set "CHAR[9w]=L")
(set "CHAR[0x]=M")
(set "CHAR[0y]=N")
(set "CHAR[0z]=O")
(set "CHAR[aa]=P")
(set "CHAR[ab]=Q")
(set "CHAR[ac]=R")
(set "CHAR[bd]=S")
(set "CHAR[be]=T")
(set "CHAR[bf]=U")
(set "CHAR[cg]=V")
(set "CHAR[ch]=W")
(set "CHAR[ci]=X")
(set "CHAR[dj]=Y")
(set "CHAR[dk]=Z")
(set "CHAR[el]=a")
(set "CHAR[em]=b")
(set "CHAR[en]=c")
(set "CHAR[fo]=d")
(set "CHAR[fp]=e")
(set "CHAR[fq]=f")
(set "CHAR[gr]=g")
(set "CHAR[gs]=h")
(set "CHAR[gt]=i")
(set "CHAR[hu]=j")
(set "CHAR[hv]=k")
(set "CHAR[hw]=l")
(set "CHAR[ix]=m")
(set "CHAR[iy]=n")
(set "CHAR[iz]=o")
(set "CHAR[j0]=p")
(set "CHAR[j1]=q")
(set "CHAR[j2]=r")
(set "CHAR[k3]=s")
(set "CHAR[k4]=t")
(set "CHAR[k5]=u")
(set "CHAR[l6]=v")
(set "CHAR[l7]=w")
(set "CHAR[l8]=x")
(set "CHAR[m9]=y")
(set "CHAR[ma]=z")
(set "CHAR[mb]=0")
(set "CHAR[nc]=1")
(set "CHAR[nd]=2")
(set "CHAR[ne]=3")
(set "CHAR[of]=4")
(set "CHAR[og]=5")
(set "CHAR[oh]=6")
(set "CHAR[pi]=7")
(set "CHAR[pj]=8")
(set "CHAR[pk]=9")
(set "CHAR[ql]=`")
(set "CHAR[qm]=-")
(set "CHAR[qn]==")
(set "CHAR[ro]=~")
(set "CHAR[rp]=!")
(set "CHAR[rq]=@")
(set "CHAR[sr]=#")
(set "CHAR[ss]=$")
(set "CHAR[st]=%")
(set "CHAR[tu]=&")
(set "CHAR[tv]=*")
(set "CHAR[tw]=(")
(set "CHAR[ux]=)")
(set "CHAR[uy]=_")
(set "CHAR[uz]=+")
(set "CHAR[v0]=^")
(set "CHAR[v1]={")
(set "CHAR[v2]=}")
(set "CHAR[w3]=|")
(set "CHAR[w4]=[")
(set "CHAR[w5]=]")
(set "CHAR[x6]=\")
(set "CHAR[x7]=;")
(set "CHAR[x8]='")
(set "CHAR[y9]=,")
(set "CHAR[ya]=.")
(set "CHAR[yb]=/")
(set "CHAR[zc]=<")
(set "CHAR[zd]=>")
(set "CHAR[ze]=?")
(set "CHAR[zf]=:")
(set "CHAR[ag]= ")

set Decrypt2=%2
set Decrypt2=!Decrypt2:"=!
set "DecryptOut="
:dc2
set "char=%Decrypt2:~0,2%"
set "Decrypt2=%Decrypt2:~2%"
set "DecryptOut=%DecryptOut%!CHAR[%char%]!"
if not "%Decrypt2%"=="" goto dc2
( endlocal
	set "%~1=%DecryptOut%"
)
if "%debug%" equ "yes" pause
exit /b

:runOnce <encryption header>
setlocal
if "%encryption%" equ "yes" (echo:encrypted=yes>%translator%) else (echo:encrypted=no>%translator%)
if "%encode%" equ "yes" (echo:encode=yes>>%translator%) else (echo:encode=no>>%translator%)
if "%hide%" equ "yes" (echo:hidden=yes>>%translator%) else (echo:hidden=no>>%translator%)
if "%encode%" equ "yes" (call :encrypt ecode %code% & echo:key=!ecode!>>%translator%) else (echo:key=>>%translator%)
endlocal
exit /b

:flip <Translate file>
setlocal ENABLEDELAYEDEXPANSION
set "count=1000000000"
if not exist %translator% echo:Translation file not found^^!? & exit /b
for /f "tokens=1,2,3 delims==||" %%a in (%translator%) do (set /a "count+=1" & if "%%a" equ "encrypted" (echo:y^|^|%%a==%%b>>%tmpfile%) else if "%%a" equ "hidden" (echo:z^|^|%%a==%%b>>%tmpfile%) else if "%%a" equ "encode" (echo:x^|^|%%a==%%b>>%tmpfile%) else if "%%a" equ "key" (echo:w^|^|%%a==%%b>>%tmpfile%) else (echo:!count!^|^|%%a^|^|%%b^|^|%%c>>%tmpfile%))
del /f /q %translator%
for /f "tokens=1,2,3,4 delims==||" %%a in ('find /v "*" %tmpfile% ^| sort /r') do (if "%%b" equ "encrypted" (echo:%%b=%%c>>%translator%) else if "%%b" equ "hidden" (echo:%%b=%%c>>%translator%) else if "%%b" equ "encode" (echo:%%b=%%c>>%translator%) else if "%%b" equ "key" (echo:%%b=%%c>>%translator%) else if  "%%c" neq "" (echo:%%b^|^|%%c^|^|%%d>>%translator%))
del /f /q %tmpfile%
endlocal
if "%debug%" equ "yes" pause
exit /b

:hide
setlocal EnableDelayedExpansion
for /f "skip=3 tokens=1,2,3 delims=||" %%a in (%translator%) do (
	if "%encryption%" equ "yes" ( call :decrypt s %%c & set "_target=!s!" ) else (set "_target=%%c")
	call :hide_ !_target!
)
attrib +s +h %translator% & attrib +s +h %settings%
echo.This folder Contains Encrypted Files>%encryptedmsg%
endlocal
if "%debug%" equ "yes" pause
exit /b

:hide_
setlocal
set "_target=%~nx1"
for /f "tokens=1 delims=" %%x in ('dir /s /b') do (
	set "d_path=%%~nxx"
	if "!d_path!" equ "!_target!" (
		attrib +s +h "%%x"
	)
)
endlocal
exit /b
:settings
setlocal
if exist %settings% attrib -s -h %settings%
if "%1" equ "full" (
	(echo:Full Settings - Secure File Encrypter ^(c^) Christian Arvin ^| naitsirhc.uriel@gmail.com
	echo.
	echo:#default: empty
	echo:debug=%debug%
	echo.
	echo:#default: .translator
	echo:translator=%translator%
	echo.
	echo:#default: relative options: relative or full 
	echo:transpath=%transpath%
	echo.
	echo:#default: ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
	echo:chars=%chars%
	echo.
	echo:#default: 16
	echo:charnum=%charnum%
	echo.
	echo:#default: yes
	echo:encryption=%encryption%
	echo.
	echo:#default: yes
	echo:encode=%encode%
	echo.
	echo:#default: yes
	echo:hide=%hide%
	echo.
	echo:#default: nothing, separate entry with spaces
	echo:excpt=%excpt%
	echo.
	echo:#default: .tmp
	echo:tmp=%tmpfile%) > %settings%
) else (
	(echo:Settings - Secure File Encrypter ^(c^) Christian Arvin ^| naitsirhc.uriel@gmail.com
	echo.
	echo:#default: relative options: relative or full 
	echo:transpath=%transpath%
	echo.
	echo:#default: ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
	echo:chars=%chars%
	echo.
	echo:#default: 16
	echo:charnum=%charnum%
	echo.
	echo:#default: yes
	echo:encryption=%encryption%
	echo.
	echo:#default: yes
	echo:encode=%encode%
	echo.
	echo:#default: yes
	echo:hide=%hide%
	echo.
	echo:#default: nothing, separate entry with spaces
	echo:excpt=%excpt%) > %settings%
)
if "%hide%" equ "yes" (if "%2" neq "iwascalled" (attrib +s +h %settings%))
endlocal
if "%debug%" equ "yes" pause
exit /b

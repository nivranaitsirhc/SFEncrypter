@echo on
setlocal  ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
call :encrypt "name" "%1"
echo !name!
pause
call :decrypt "de" "!name!"
echo !de!
exit /b
:encrypt <out> <input>
::------------------------Encrypt
setlocal  ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
(set "CHAR[a]=nd")
(set "CHAR[b]=me")
(set "CHAR[c]=of")
(set "CHAR[d]=pg")
(set "CHAR[e]=qh")
(set "CHAR[f]=ri")
(set "CHAR[g]=sj")
(set "CHAR[h]=tk")
(set "CHAR[i]=uk")
(set "CHAR[j]=vl")
(set "CHAR[k]=wm")
(set "CHAR[l]=xn")
(set "CHAR[m]=yo")
(set "CHAR[n]=zp")
(set "CHAR[o]=1q")
(set "CHAR[p]=2r")
(set "CHAR[q]=3s")
(set "CHAR[r]=4t")
(set "CHAR[s]=5u")
(set "CHAR[t]=6v")
(set "CHAR[u]=7w")
(set "CHAR[v]=8x")
(set "CHAR[w]=9y")
(set "CHAR[x]=0z")
(set "CHAR[y]=a1")
(set "CHAR[z]=b2")
(set "CHAR[0]=c3")
(set "CHAR[1]=d4")
(set "CHAR[2]=e5")
(set "CHAR[3]=f6")
(set "CHAR[4]=g7")
(set "CHAR[5]=h8")
(set "CHAR[6]=i9")
(set "CHAR[7]=j0")
(set "CHAR[8]=ka")
(set "CHAR[9]=lb")
(set "CHAR[0]=mc")
(set "CHAR[`]=nd")
(set "CHAR[-]=oe")
(set "CHAR[=]=pf")
(set "CHAR[~]=qg")
(set "CHAR[!]=rh")
(set "CHAR[@]=si")
(set "CHAR[#]=tj")
(set "CHAR[$]=uk")
(set "CHAR[%]=vl")
(set "CHAR[&]=wm")
(set "CHAR[*]=xn")
(set "CHAR[(]=yo")
(set "CHAR[)]=zp")
(set "CHAR[_]=1q")
(set "CHAR[+]=2r")
(set "CHAR[[]=3s")
(set "CHAR[]]=4t")
(set "CHAR[\]=5u")
(set "CHAR[;]=6v")
(set "CHAR[']=7w")
(set "CHAR[,]=8x")
(set "CHAR[.]=9y")
(set "CHAR[/]=0z")
(set "CHAR[{]=a1")
(set "CHAR[}]=b2")
(set "CHAR[|]=c3")
(set "CHAR[<]=d4")
(set "CHAR[>]=e5")
(set "CHAR[?]=f6")

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
if "%char%" equ ":" (set EncryptOut=%EncryptOut%zo) else (
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
(set "CHAR[5k]=a")
(set "CHAR[6l]=b")
(set "CHAR[7m]=c")
(set "CHAR[8n]=d")
(set "CHAR[9o]=e")
(set "CHAR[ap]=f")
(set "CHAR[bq]=g")
(set "CHAR[cr]=h")
(set "CHAR[ds]=i")
(set "CHAR[et]=j")
(set "CHAR[fu]=k")
(set "CHAR[gv]=l")
(set "CHAR[hw]=m")
(set "CHAR[ix]=n")
(set "CHAR[jy]=o")
(set "CHAR[kz]=p")
(set "CHAR[la]=q")
(set "CHAR[mj]=r")
(set "CHAR[nk]=s")
(set "CHAR[ol]=t")
(set "CHAR[pm]=u")
(set "CHAR[qn]=v")
(set "CHAR[ro]=w")
(set "CHAR[s0]=x")
(set "CHAR[t1]=y")
(set "CHAR[u2]=z")
(set "CHAR[v3]=0")
(set "CHAR[w4]=1")
(set "CHAR[x5]=2")
(set "CHAR[y6]=3")
(set "CHAR[z7]=4")
(set "CHAR[08]=5")
(set "CHAR[19]=6")
(set "CHAR[2a]=7")
(set "CHAR[3b]=8")
(set "CHAR[4c]=9")
(set "CHAR[5d]=`")
(set "CHAR[6e]=-")
(set "CHAR[7f]==")
(set "CHAR[8g]=~")
(set "CHAR[9h]=!")
(set "CHAR[ai]=@")
(set "CHAR[bj]=#")
(set "CHAR[ck]=$")
(set "CHAR[dl]=%")
(set "CHAR[em]=&")
(set "CHAR[fn]=*")
(set "CHAR[go]=(")
(set "CHAR[hp]=)")
(set "CHAR[ia]=_")
(set "CHAR[jb]=+")
(set "CHAR[kc]=[")
(set "CHAR[ld]=]")
(set "CHAR[me]=;")
(set "CHAR[nf]='")
(set "CHAR[og]=,")
(set "CHAR[ph]=.")
(set "CHAR[qi]=/")
(set "CHAR[rj]=\")
(set "CHAR[sk]={")
(set "CHAR[tl]=}")
(set "CHAR[um]=|")
(set "CHAR[vn]=<")
(set "CHAR[wo]=>")
(set "CHAR[xp]=?")
(set "CHAR[yq]=^")
(set "CHAR[sz]=A")
(set "CHAR[t9]=B")
(set "CHAR[u8]=C")
(set "CHAR[v5]=D")
(set "CHAR[w6]=E")
(set "CHAR[x3]=F")
(set "CHAR[y2]=G")
(set "CHAR[z1]=H")
(set "CHAR[a4]=I")
(set "CHAR[b7]=J")
(set "CHAR[d0]=K")
(set "CHAR[ea]=L")
(set "CHAR[hb]=M")
(set "CHAR[ic]=N")
(set "CHAR[jd]=O")
(set "CHAR[ke]=P")
(set "CHAR[lf]=Q")
(set "CHAR[mg]=R")
(set "CHAR[nh]=S")
(set "CHAR[iq]=T")
(set "CHAR[rj]=U")
(set "CHAR[ks]=V")
(set "CHAR[lt]=W")
(set "CHAR[vm]=X")
(set "CHAR[9n]=Y")
(set "CHAR[6o]=Z")
(set "CHAR[zo]=:")

set Decrypt2=%2
set Decrypt2=!Decrypt2:"=!
set "DecryptOut="
:dc2
set "char=%Decrypt2:~0,2%"
set "Decrypt2=%Decrypt2:~2%"
set "DecryptOut=%DecryptOut%!CHAR[%char%]!"
if not "%Decrypt2%"=="" goto dc2
echo:"%DecryptOut%"
( endlocal
	set "%~1=%DecryptOut%"
)
if "%debug%" equ "yes" pause
exit /b

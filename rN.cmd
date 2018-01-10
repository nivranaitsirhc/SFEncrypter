@Echo Off
REM Note
REM I've modified it so you can easily specify the length, and add or remove characters without having to change any other part of the code.
REM For example, you might not want to use both 0 and O (zero and Uppercase O), or 1 and l (one and lowercase L).
REM You can use punctuation except for these characters:
REM ! % ^ & < >
REM You can use ^ and %, but must enter them in the _Alphanumeric variable twice as ^^ or %%. However, if you want to use the result (_RndAlphaNum) later in the batch file (other than Echoing to the screen), they might require special handling.
REM You can even use a space, as long as it's not the last character in the string. If it ends up as the last character in the generated string though, it will not be used, so you would only have 7 characters.

::Source=http://superuser.com/questions/349474/how-do-you-make-a-letter-password-generator-in-batch
Setlocal EnableDelayedExpansion
Set _RNDLength=16
Set _Alphanumeric=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
Set _Str=%_Alphanumeric%987654321

:_LenLoop
echo %_str%
echo %_Len%
echo:----------------------------
IF NOT "%_Str:~18%"=="" SET _Str=%_Str:~9%& SET /A _Len+=9 & GOTO :_LenLoop
SET _tmp=%_Str:~9,1%
SET /A _Len=_Len+_tmp
Set _count=0
SET _RndAlphaNum=
echo %_str%
echo %_tmp%
echo %_len%
echo:----------------------------
:_loop
Set /a _count+=1
SET _RND=%Random%
Set /A _RND=_RND%%%_Len%
SET _RndAlphaNum=!_RndAlphaNum!!_Alphanumeric:~%_RND%,1!
echo !_count! %_RNDLength%
echo %_RND% %_Len%
echo %_RndAlphaNum%
echo:----------------------------
If !_count! lss %_RNDLength% goto _loop
Echo Random string is !_RndAlphaNum!
exit /b
@echo off
call :ss s
echo %s%
exit /b

:ss
setlocal
set %1=boo
REM Set %1 to set the returning value
exit /b
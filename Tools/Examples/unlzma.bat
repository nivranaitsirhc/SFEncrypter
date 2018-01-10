@echo off

%extd% /browseforfile "Select a ZIP file" "" "LZMA (*.lzma)|*.lzma"

if "%result%"=="" (exit) else (set file="%result%")

%extd% /savefiledialog "Save file as" "MyZipfile" "All Files (*.*)|*.*"

if "%result%"=="" (exit) else (set folder="%result%")

%extd% /unlzma %file% %folder%
echo:%extd% /unlzma %file% %folder%
pause
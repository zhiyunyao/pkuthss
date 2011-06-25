@echo off

set GS=gswin32c
set GSOPTS=-q -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite
set WIDTHOPT=-dDEVICEWIDTHPOINTS=
set HEIGHTOPT=-dDEVICEHEIGHTPOINTS=
set OUTPUTOPT=-sOutputFile=

if "%1"=="" goto pdf
if "%1"=="clean" (goto clean) else (goto usage)

:pdf
%GS% %GSOPTS% %WIDTHOPT%400 %HEIGHTOPT%400 %OUTPUTOPT%pkulogo.pdf -f pkulogo.ps
%GS% %GSOPTS% %WIDTHOPT%525 %HEIGHTOPT%150 %OUTPUTOPT%pkuword.pdf -f pkuword.ps
goto end

:clean
del pkulogo.pdf pkuword.pdf
goto end

:usage
echo %0 [pdf] [clean]

:end


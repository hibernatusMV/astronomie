@echo OFF
REM APF - Astrophotography Folder
REM Batchdatei zum erzeugen eines neuen Ordners inkl. Unterordner fueÅr astrofotografische Aufnahmen
REM Copyright: Marcus Vasi

setlocal ENABLEEXTENSIONS

set /A ERROR_FOLDER_EXISTS=1
set /A ERROR_NO_OBJECT=2

REM Aufnahmedatum und Name des fotografierten Objekts eingeben.
REM Fuer jedes Objekt wird ein neuer Unterordner, im Ordner mit Datum, angelegt
echo APF - Astrophotography Folder
echo Abbruch mit [Q]uit
echo.
set /p USERDATE=Bitte das Aufnahmedatum (Format YYYYMMDD) eingeben. Leer [aktuelles Datum]:

if /i "%USERDATE%" equ "Q" goto :cancel

if [%USERDATE%]==[] (
    REM Aktuelles Datum holen und formatieren YYYYMMDD
    set ARCHIVENAME=%DATE:~6,4%%DATE:~3,2%%DATE:~0,2%
) else (
    REM Vom Benutzer eingegebenes Datum verwenden
    set ARCHIVENAME=%USERDATE%
)

echo verwendetes Aufnahmedatum: %ARCHIVENAME%
echo.
set /p OBJECT=Bitte Objektname eingeben:
if /i "%OBJECT%" equ "Q" goto :cancel

REM Objektname wurde nicht angegeben. Meldung!
if [%OBJECT%]==[] goto NoObject

echo verwendeter Objektname: %OBJECT%
echo.

REM Unterordner fuer Struktur Datum\Objektname definieren
set SUBFOLDERS="Biasframe" ^
               "Darkframe" ^
               "Flatframe" ^
               "Lightframe" ^
               "Trash" ^
               "Output"

REM Erzeuge Ordnerstruktur, wenn Datum\Objektname noch nicht existiert
REM Ansonsten gib eine Meldung raus, das die Struktur schon existiert
if not exist "%ARCHIVENAME%\%OBJECT%" (
    goto createFolders
) else (
    goto folderExists
)

:NoObject
echo Kein Objektname angegeben. Abbruch!
pause
exit %ERROR_NO_OBJECT%

:folderExists
echo Ordner %ARCHIVENAME%\%OBJECT% existiert schon. Abbruch!
pause
exit %ERROR_FOLDER_EXISTS%

:createFolders
REM Ordner Datum\Objektname mit definierter Unterordnerstruktur anlegen
for %%i in (%SUBFOLDERS%) do md "%ARCHIVENAME%\%OBJECT%\%%~i"
if %ERRORLEVEL% NEQ 0 (
    REM Ein Fehler ist waehrend des anlegens der Orderstruktur aufgetreten
    echo Ordnerstruktur %ARCHIVENAME%\%OBJECT% wurde nicht angelegt. Abbruch!
    pause
    exit %ERRORLEVEL%
) else (
    echo Ordnerstruktur %ARCHIVENAME%\%OBJECT% wurde angelegt.
    pause
    exit %ERRORLEVEL%
)

:cancel
REM Benutzer hat Programm beendet
echo.
echo APF wurde beendet!
pause
exit 0
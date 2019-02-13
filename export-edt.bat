@chcp 65001

set VERSION=8.3.12.1567

set EDT_PROJECT_VERSION=8.3.12
set EDT_VERSION=1.10

set WORKSPACE=%~dp0workspace
set SRC_FOLDER=%~dp0src
set PROJECT_PATH=%~dp0edt-project
set VALIDATION_RESULT=%~dp0edt-result.out
set PLATFORM=c:\Program Files\1cv8\%VERSION%\bin\1cv8.exe

set RING_OPTS=-Dfile.encoding=UTF-8 -Dosgi.nl=ru

rd /S /Q "%WORKSPACE%"
md  "%WORKSPACE%"
rd /S /Q "%PROJECT_PATH%"
DEL "%VALIDATION_RESULT%"

ECHO Создание проекта в EDT %date% - %time%

call ring edt@%EDT_VERSION% workspace import --workspace-location "%WORKSPACE%" --configuration-files "%SRC_FOLDER%" --project "%PROJECT_PATH%" --version %EDT_PROJECT_VERSION%

ECHO Проект в EDT создан %date% - %time%
ECHO Error level: %ERRORLEVEL% 

if %ERRORLEVEL% NEQ 0 exit %ERRORLEVEL%

ECHO Проверка проекта в EDT %date% - %time%

call ring edt@%EDT_VERSION% workspace validate --workspace-location "%WORKSPACE%" --file "%VALIDATION_RESULT%" --project-list "%PROJECT_PATH%"

ECHO Проверка завершена %date% - %time%
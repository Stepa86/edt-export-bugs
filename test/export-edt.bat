@chcp 65001

set EDT_PROJECT_VERSION=8.3.12
set EDT_VERSION=1.10

set WORKSPACE=%~dp0workspace
set SRC=%~dp0src
set PROJECT_PATH=%~dp0edt-project
set EDT_VALIDATION_RESULT=%~dp0edt-result.out

set RING_OPTS=-Dfile.encoding=UTF-8 -Dosgi.nl=ru

rd /S /Q "%WORKSPACE%"
md  "%WORKSPACE%"
rd /S /Q "%PROJECT_PATH%"
DEL "%EDT_VALIDATION_RESULT%"

ECHO Создание проекта в EDT %date% - %time%

call ring edt@%EDT_VERSION% workspace import --workspace-location "%WORKSPACE%" --configuration-files "%SRC%" --project "%PROJECT_PATH%" --version %EDT_PROJECT_VERSION%

ECHO Проект в EDT создан %date% - %time%
ECHO Error level: %ERRORLEVEL% 

if %ERRORLEVEL% NEQ 0 exit %ERRORLEVEL%

ECHO Проверка проекта в EDT %date% - %time%

call ring edt@%EDT_VERSION% workspace validate --workspace-location "%WORKSPACE%" --file "%EDT_VALIDATION_RESULT%" --project-list "%PROJECT_PATH%"

ECHO Проверка завершена %date% - %time%
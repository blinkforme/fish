@echo on
set WORKPATH=%~dp0

:update_cfg
cd /d E:\by-tool
git pull
cd /d E:\tool
git pull
cd tool
set PY27_HOME=D:\python2.7\python.exe
%PY27_HOME% excel_export2.py abbey_ddz

:update
cd /d %WORKPATH%
git fetch
git pull

:export
call .\export_cmd.bat

:publish
cd /d %WORKPATH%
set NODE="D:\nvm\v10.9.0\node.exe"
set GULP_JS="D:\LayaAirIDE2.4.0\resources\app\node_modules\gulp\bin\gulp.js"
set GULP_ARGS=--gulpfile=%WORKPATH%abbey/.laya/publish_cmd.js
set PLATFORM_ARGS="--config web.json"
%NODE% %GULP_JS% %GULP_ARGS% %PLATFORM_ARGS%


pause

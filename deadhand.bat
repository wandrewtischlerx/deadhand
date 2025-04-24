@echo off
chcp 65001 > nul
title Compactador Seguro WinRAR - Versão Final Corrigida

:: =============================================
:: CONFIGURAÇÃO INICIAL
:: =============================================
:: Verifica se o WinRAR está instalado
set "winrar_path="
for %%i in (
  "%ProgramFiles%\WinRAR\WinRAR.exe"
  "%ProgramFiles(x86)%\WinRAR\WinRAR.exe"
  "%ProgramW6432%\WinRAR\WinRAR.exe"
) do if exist "%%~i" set "winrar_path=%%~i"

if not defined winrar_path (
  echo [ERRO] WinRAR não encontrado.
  echo        Instale o WinRAR primeiro.
  pause
  exit /b 1
)

:: =============================================
:: SOLICITAÇÃO DA SENHA
:: =============================================
:get_password
set "senha="
set /p "senha=Digite a senha (minimo 8 caracteres): "
set "senha=%senha: =%"
if "%senha%"=="" (
  echo [ERRO] A senha não pode ser vazia!
  goto get_password
)
if "%senha:~7%"=="" (
  echo [ERRO] A senha deve ter pelo menos 8 caracteres!
  goto get_password
)

:confirm_password
set "confirme="
set /p "confirme=Confirme a senha: "
set "confirme=%confirme: =%"
if not "%senha%"=="%confirme%" (
  echo [ERRO] As senhas não coincidem!
  goto confirm_password
)

:: =============================================
:: COMPACTAÇÃO DAS PASTAS (CORREÇÃO PARA ESPAÇOS)
:: =============================================
set "contador=0"
cd /d "%USERPROFILE%\Desktop"

for /d %%d in (*) do (
  echo.
  echo Processando: "%%~nxd"...
  
  set "nome_arquivo=%%~nxd"
  set "nome_arquivo=!nome_arquivo:.= !"
  set "nome_arquivo=!nome_arquivo:.rar=!"
  
  :: Executa o WinRAR com tratamento especial para caminhos com espaços
  "%winrar_path%" a -r -ep1 -hp"%senha%" -m5 -df "%%~nxd.rar" "%%~d"
  
  if exist "%%~nxd.rar" (
    set /a "contador+=1"
    echo [SUCESSO] "%%~nxd.rar" criado com sucesso.
  ) else (
    echo [FALHA] Erro ao compactar "%%~nxd".
  )
)

:: =============================================
:: RESULTADO FINAL
:: =============================================
echo.
echo ========================================
echo RESUMO DA OPERAÇÃO:
echo Pastas compactadas: %contador%
echo Senha utilizada: %senha%
echo ========================================
echo ATENÇÃO: Esta senha é necessária para extrair os arquivos!
pause
FROM mcr.microsoft.com/powershell
ENV PSModulePath ./Modules
COPY . ./Modules/ShowDemo
RUN pwsh -c "New-Item -Path /root/.config/powershell/Microsoft.PowerShell_profile.ps1 -Value 'Import-Module ShowDemo' -Force"


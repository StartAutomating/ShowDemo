FROM mcr.microsoft.com/powershell
COPY . ./usr/local/share/powershell/Modules/ShowDemo
RUN pwsh -c "New-Item -Path /root/.config/powershell/Microsoft.PowerShell_profile.ps1 -Value 'Import-Module ShowDemo' -Force"


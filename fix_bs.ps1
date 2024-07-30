Get-ScheduledTask -TaskPath "\Microsoft\Windows\Windows Defender\" | Stop-ScheduledTask
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Windows Defender\" | Disable-ScheduledTask

Stop-Process -ErrorAction SilentlyContinue -Name AdobeCollabSync
Move-Item -ErrorAction SilentlyContinue -Force "C:\Program Files\Adobe\Acrobat DC\Acrobat\AdobeCollabSync.exe" "C:\Program Files\Adobe\Acrobat DC\Acrobat\AdobeCollabSync_.exe"

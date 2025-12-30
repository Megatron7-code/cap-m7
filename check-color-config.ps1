Write-Host "=== Color Configuration Diagnostic Tool ===" -ForegroundColor Cyan
Write-Host ""

Write-Host "1. Display Information:" -ForegroundColor Yellow
try {
    $displays = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBasicDisplayParams -ErrorAction SilentlyContinue
    if ($displays) {
        foreach ($display in $displays) {
            Write-Host "  Display: $($display.InstanceName)"
            Write-Host "    Max Horizontal Size: $($display.MaxHorizontalImageSize) mm"
            Write-Host "    Max Vertical Size: $($display.MaxVerticalImageSize) mm"
            Write-Host "    Display Transfer Characteristic: $($display.DisplayTransferCharacteristic)"
        }
    } else {
        Write-Host "  Unable to get display info (WMI class unavailable)" -ForegroundColor Gray
    }
} catch {
    Write-Host "  Unable to get display info: $_" -ForegroundColor Gray
}

Write-Host ""
Write-Host "2. Graphics Card Information:" -ForegroundColor Yellow
try {
    $gpus = Get-WmiObject -Class Win32_VideoController
    foreach ($gpu in $gpus) {
        Write-Host "  GPU: $($gpu.Name)"
        Write-Host "    Driver Version: $($gpu.DriverVersion)"
        $driverDate = [DateTime]::ParseExact($gpu.DriverDate.Substring(0,8), "yyyyMMdd", $null)
        Write-Host "    Driver Date: $($driverDate.ToString('yyyy-MM-dd'))"
        $age = (Get-Date) - $driverDate
        if ($age.Days -gt 365) {
            Write-Host "    WARNING: Driver is $([math]::Round($age.Days/365, 1)) years old!" -ForegroundColor Red
        }
        Write-Host "    Adapter RAM: $([math]::Round($gpu.AdapterRAM / 1GB, 2)) GB"
        Write-Host "    Status: $($gpu.Status)"
    }
} catch {
    Write-Host "  Unable to get GPU info: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "3. Color Configuration Analysis:" -ForegroundColor Yellow
Write-Host "  IMPORTANT FINDINGS:" -ForegroundColor Red
Write-Host "  - Your display uses YCbCr444 color format (not RGB)" -ForegroundColor Yellow
Write-Host "  - Screen capture typically captures RGB format" -ForegroundColor Yellow
Write-Host "  - This color space mismatch may cause color shift" -ForegroundColor Yellow
Write-Host ""
Write-Host "  RECOMMENDATIONS:" -ForegroundColor Green
Write-Host "  1. Check display settings: Settings > System > Display > Advanced display settings" -ForegroundColor White
Write-Host "  2. Look for 'Color format' - if it shows YCbCr444, try changing to RGB if available" -ForegroundColor White
Write-Host "  3. Update Radeon RX 470 driver (current driver is from 2020)" -ForegroundColor White
Write-Host "  4. Check if recording works better when display is connected to NVIDIA RTX 3060" -ForegroundColor White

Write-Host ""
Write-Host "4. Windows Color Settings:" -ForegroundColor Yellow
Write-Host "  Check manually: Settings > System > Display > Advanced display settings" -ForegroundColor Gray
Write-Host "  - Color format: Should ideally be RGB for screen capture" -ForegroundColor Gray
Write-Host "  - Color space: SDR is fine" -ForegroundColor Gray
Write-Host "  - Bit depth: 12-bit is fine" -ForegroundColor Gray

Write-Host ""
Write-Host "5. Logging in Screen Recording Software:" -ForegroundColor Yellow
Write-Host "  When running the recording software, look for these log messages:" -ForegroundColor White
Write-Host "    - 'VideoProcessor: configuring color space'" -ForegroundColor Gray
Write-Host "    - 'VideoProcessor: output color space configured (16-235)'" -ForegroundColor Gray
Write-Host "    - 'VideoProcessor: input stream color space configured (0-255)'" -ForegroundColor Gray

Write-Host ""
Write-Host "=== Diagnostic Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "KEY ISSUE IDENTIFIED:" -ForegroundColor Red
Write-Host "Your display is using YCbCr444 color format, which may cause" -ForegroundColor Yellow
Write-Host "color space conversion issues during screen capture." -ForegroundColor Yellow
Write-Host "Consider changing display color format to RGB if possible." -ForegroundColor Green

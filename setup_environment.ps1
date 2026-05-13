# Antigravity Environment Setup Script

# 1. Define Paths
$flutterPath = "C:\tools\flutter\bin"
$dartPath = "C:\tools\dart-sdk\bin"
$androidHome = "C:\Android\sdk"

# 2. Update Current Session
$env:ANDROID_HOME = $androidHome
$env:Path = "$flutterPath;$dartPath;$env:Path"

Write-Host "✅ Current session updated with Flutter and Dart paths." -ForegroundColor Green

# 3. Permanent Fix (User Environment)
Write-Host "Attempting to update User PATH permanently..." -ForegroundColor Cyan

$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPaths = @($flutterPath, $dartPath)
$updatedPath = $currentPath

foreach ($path in $newPaths) {
    if ($currentPath -notlike "*$path*") {
        $updatedPath = "$path;$updatedPath"
        Write-Host "Adding $path to User PATH..."
    } else {
        Write-Host "$path already in PATH."
    }
}

if ($updatedPath -ne $currentPath) {
    [Environment]::SetEnvironmentVariable("Path", $updatedPath, "User")
    Write-Host "✅ User PATH updated permanently! Please restart your terminal/IDE for changes to take effect." -ForegroundColor Green
} else {
    Write-Host "No permanent changes needed." -ForegroundColor Yellow
}

# 4. Verify
Write-Host "`nVerifying installation..."
& flutter --version
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Flutter is now accessible!" -ForegroundColor Green
} else {
    Write-Host "❌ Still unable to find flutter. Please check the paths manually." -ForegroundColor Red
}

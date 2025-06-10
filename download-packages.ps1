# ===================================================================
# OFFLINE PACKAGE DOWNLOADER FOR .NET 8 MVC EXAMS
# ===================================================================
# This script downloads all NuGet packages needed for multi-project
# MVC applications to a local folder for offline exam use.
# ===================================================================

param(
    [string]$DownloadPath = ".\ExamPackages",
    [switch]$Force
)

Write-Host "🔌 Starting Offline Package Download Setup..." -ForegroundColor Green
Write-Host "📁 Download Path: $DownloadPath" -ForegroundColor Yellow

# Create download directory
if (-not (Test-Path $DownloadPath)) {
    New-Item -ItemType Directory -Path $DownloadPath -Force | Out-Null
    Write-Host "✅ Created directory: $DownloadPath" -ForegroundColor Green
} elseif ($Force) {
    Remove-Item -Path "$DownloadPath\*" -Recurse -Force
    Write-Host "🧹 Cleaned existing packages (Force mode)" -ForegroundColor Yellow
}

# Define all packages with exact versions
$packages = @(
    # Core Entity Framework
    @{ Name = "Microsoft.EntityFrameworkCore"; Version = "8.0.16" },
    @{ Name = "Microsoft.EntityFrameworkCore.Design"; Version = "8.0.16" },
    @{ Name = "Microsoft.EntityFrameworkCore.SqlServer"; Version = "8.0.16" },
    @{ Name = "Microsoft.EntityFrameworkCore.Tools"; Version = "8.0.16" },
    
    # Identity & Authentication  
    @{ Name = "Microsoft.AspNetCore.Identity.EntityFrameworkCore"; Version = "8.0.16" },
    @{ Name = "Microsoft.AspNetCore.Identity.UI"; Version = "8.0.16" },
    @{ Name = "Microsoft.AspNetCore.Authentication.Google"; Version = "8.0.16" },
    @{ Name = "Microsoft.AspNetCore.Authentication.Facebook"; Version = "8.0.16" },
    @{ Name = "Microsoft.AspNetCore.Authentication.OpenIdConnect"; Version = "8.0.16" },
    
    # API & Swagger
    @{ Name = "Swashbuckle.AspNetCore"; Version = "6.4.0" },
    @{ Name = "Microsoft.AspNetCore.OpenApi"; Version = "8.0.16" },
    
    # Development Tools
    @{ Name = "Microsoft.VisualStudio.Web.CodeGeneration.Design"; Version = "8.0.16" },
    @{ Name = "Microsoft.AspNetCore.Diagnostics.EntityFrameworkCore"; Version = "8.0.16" },
    
    # Identity Server (Optional but included)
    @{ Name = "Duende.IdentityServer"; Version = "7.0.7" },
    @{ Name = "Duende.IdentityServer.AspNetIdentity"; Version = "7.0.7" },
    
    # Bonus packages (commonly needed in exams)
    @{ Name = "AutoMapper"; Version = "12.0.1" },
    @{ Name = "AutoMapper.Extensions.Microsoft.DependencyInjection"; Version = "12.0.1" },
    @{ Name = "Serilog.AspNetCore"; Version = "8.0.0" },
    @{ Name = "FluentValidation.AspNetCore"; Version = "11.3.0" },
    
    # Additional helpful packages
    @{ Name = "Microsoft.AspNetCore.Authentication.JwtBearer"; Version = "8.0.16" },
    @{ Name = "System.IdentityModel.Tokens.Jwt"; Version = "7.1.2" },
    @{ Name = "Microsoft.AspNetCore.Authorization"; Version = "8.0.16" },
    @{ Name = "Microsoft.Extensions.Configuration.Json"; Version = "8.0.16" },
    @{ Name = "Microsoft.Extensions.DependencyInjection"; Version = "8.0.16" }
)

Write-Host "📦 Total packages to download: $($packages.Count)" -ForegroundColor Cyan

$successCount = 0
$failCount = 0

foreach ($package in $packages) {
    $packageName = $package.Name
    $version = $package.Version
    
    Write-Host "📥 Downloading: $packageName v$version" -ForegroundColor White
    
    try {
        # Download package using nuget.exe
        $result = & nuget install $packageName -Version $version -OutputDirectory $DownloadPath -NoCache -DirectDownload 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ Success: $packageName" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "   ❌ Failed: $packageName - $result" -ForegroundColor Red
            $failCount++
        }
    }
    catch {
        Write-Host "   ❌ Error downloading $packageName : $($_.Exception.Message)" -ForegroundColor Red
        $failCount++
    }
}

Write-Host ""
Write-Host "📊 DOWNLOAD SUMMARY" -ForegroundColor Magenta
Write-Host "===================" -ForegroundColor Magenta
Write-Host "✅ Successful: $successCount" -ForegroundColor Green
Write-Host "❌ Failed: $failCount" -ForegroundColor Red
Write-Host "📁 Location: $DownloadPath" -ForegroundColor Yellow

if ($successCount -gt 0) {
    Write-Host ""
    Write-Host "🎯 CONFIGURE NUGET SOURCE?" -ForegroundColor Green
    $fullPath = Resolve-Path $DownloadPath
    Write-Host "📁 Package location: $fullPath" -ForegroundColor Yellow
    
    $response = Read-Host "Do you want to configure NuGet to use this local source? (y/N)"
    
    if ($response -match '^[Yy]') {
        Write-Host ""
        Write-Host "⚙️  Configuring NuGet source..." -ForegroundColor Cyan
        
        # Remove existing source if it exists (to avoid conflicts)
        & nuget sources Remove -name "LocalExamPackages" 2>$null
        
        # Add the new source
        $result = & nuget sources add -name "LocalExamPackages" -source "$fullPath" 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Successfully configured LocalExamPackages source!" -ForegroundColor Green
            Write-Host ""
            Write-Host "🔍 Verifying configuration..." -ForegroundColor Cyan
            & nuget sources list | Select-String "LocalExamPackages" -A 1
            Write-Host ""
            Write-Host "🚀 You're all set! During exam, use:" -ForegroundColor Green
            Write-Host "   Install-Package PackageName -Version X.X.X -Source LocalExamPackages" -ForegroundColor Gray
        } else {
            Write-Host "❌ Failed to configure NuGet source: $result" -ForegroundColor Red
            Write-Host "💡 Manual command:" -ForegroundColor Yellow
            Write-Host "   nuget sources add -name `"LocalExamPackages`" -source `"$fullPath`"" -ForegroundColor Gray
        }
    } else {
        Write-Host ""
        Write-Host "⏭️  Skipped NuGet configuration. Manual setup:" -ForegroundColor Yellow
        Write-Host "   nuget sources add -name `"LocalExamPackages`" -source `"$fullPath`"" -ForegroundColor Gray
        Write-Host ""
        Write-Host "🔍 To verify later:" -ForegroundColor White  
        Write-Host "   nuget sources list" -ForegroundColor Gray
    }
}

if ($failCount -gt 0) {
    Write-Host ""
    Write-Host "⚠️  Some packages failed to download. Check your internet connection" -ForegroundColor Yellow
    Write-Host "   and try running the script again with -Force flag." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🚀 Setup complete! You're ready for offline exams." -ForegroundColor Green
Write-Host "   Check EXAM_OFFLINE_SETUP.md for detailed usage instructions." -ForegroundColor Gray 
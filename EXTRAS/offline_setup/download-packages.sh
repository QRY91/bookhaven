#!/bin/bash
# ===================================================================
# OFFLINE PACKAGE DOWNLOADER FOR .NET 8 MVC EXAMS (BASH VERSION)
# ===================================================================
# This script downloads all NuGet packages needed for multi-project
# MVC applications to a local folder for offline exam use.
# 
# NOTE: For Windows users, the PowerShell version (download-packages.ps1)
# is recommended as it uses nuget.exe directly for more reliable downloads.
# ===================================================================

DOWNLOAD_PATH="${1:-./ExamPackages}"
FORCE="${2:-false}"

echo "🔌 Starting Offline Package Download Setup..."
echo "📁 Download Path: $DOWNLOAD_PATH"

# Check if we're on Windows and suggest PowerShell
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    echo ""
    echo "⚠️  WINDOWS DETECTED: For best results, consider using PowerShell:"
    echo "   PowerShell: .\download-packages.ps1"
    echo "   This bash version may have issues with package downloading on Windows."
    echo ""
    echo -n "Continue with bash version anyway? (y/N): "
    read continue_response
    if [[ ! "$continue_response" =~ ^[Yy] ]]; then
        echo "👍 Recommended! Run this instead:"
        echo "   .\download-packages.ps1"
        exit 0
    fi
    echo ""
fi

# Create download directory
if [ ! -d "$DOWNLOAD_PATH" ]; then
    mkdir -p "$DOWNLOAD_PATH"
    echo "✅ Created directory: $DOWNLOAD_PATH"
elif [ "$FORCE" = "true" ] || [ "$FORCE" = "--force" ]; then
    rm -rf "$DOWNLOAD_PATH"/*
    echo "🧹 Cleaned existing packages (Force mode)"
fi

# Define packages array
declare -a packages=(
    # Core Entity Framework
    "Microsoft.EntityFrameworkCore:8.0.16"
    "Microsoft.EntityFrameworkCore.Design:8.0.16"
    "Microsoft.EntityFrameworkCore.SqlServer:8.0.16"
    "Microsoft.EntityFrameworkCore.Tools:8.0.16"
    
    # Identity & Authentication
    "Microsoft.AspNetCore.Identity.EntityFrameworkCore:8.0.16"
    "Microsoft.AspNetCore.Identity.UI:8.0.16"
    "Microsoft.AspNetCore.Authentication.Google:8.0.16"
    "Microsoft.AspNetCore.Authentication.Facebook:8.0.16"
    "Microsoft.AspNetCore.Authentication.OpenIdConnect:8.0.16"
    
    # API & Swagger
    "Swashbuckle.AspNetCore:6.4.0"
    "Microsoft.AspNetCore.OpenApi:8.0.16"
    
    # Development Tools
    "Microsoft.VisualStudio.Web.CodeGeneration.Design:8.0.16"
    "Microsoft.AspNetCore.Diagnostics.EntityFrameworkCore:8.0.16"
    
    # Identity Server
    "Duende.IdentityServer:7.0.7"
    "Duende.IdentityServer.AspNetIdentity:7.0.7"
    
    # Bonus packages
    "AutoMapper:12.0.1"
    "AutoMapper.Extensions.Microsoft.DependencyInjection:12.0.1"
    "Serilog.AspNetCore:8.0.0"
    "FluentValidation.AspNetCore:11.3.0"
    
    # Additional helpful packages
    "Microsoft.AspNetCore.Authentication.JwtBearer:8.0.16"
    "System.IdentityModel.Tokens.Jwt:7.1.2"
    "Microsoft.AspNetCore.Authorization:8.0.16"
    "Microsoft.Extensions.Configuration.Json:8.0.16"
    "Microsoft.Extensions.DependencyInjection:8.0.16"
)

echo "📦 Total packages to download: ${#packages[@]}"

success_count=0
fail_count=0

for package_info in "${packages[@]}"; do
    IFS=':' read -r package_name version <<< "$package_info"
    
    echo "📥 Downloading: $package_name v$version"
    
    # Create a temporary directory for this package
    temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Create a temporary project file
    cat > temp.csproj << EOF
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="$package_name" Version="$version" />
  </ItemGroup>
</Project>
EOF
    
    # Create packages folder inside temp directory
    packages_dir="$temp_dir/packages"
    mkdir -p "$packages_dir"
    
    # Restore packages to the temp packages folder
    if dotnet restore --packages "$packages_dir" >/dev/null 2>&1; then
        # Copy the downloaded package to our target directory
        if [ -d "$packages_dir" ] && [ "$(ls -A "$packages_dir" 2>/dev/null)" ]; then
            cp -r "$packages_dir"/* "$DOWNLOAD_PATH/" 2>/dev/null || true
            echo "   ✅ Success: $package_name"
            ((success_count++))
        else
            echo "   ❌ Failed: $package_name (no packages found)"
            ((fail_count++))
        fi
    else
        echo "   ❌ Failed: $package_name (restore failed)"
        ((fail_count++))
    fi
    
    cd - >/dev/null
    rm -rf "$temp_dir"
done

echo ""
echo "📊 DOWNLOAD SUMMARY"
echo "==================="
echo "✅ Successful: $success_count"
echo "❌ Failed: $fail_count"
echo "📁 Location: $DOWNLOAD_PATH"

if [ $success_count -gt 0 ]; then
    echo ""
    echo "🎯 CONFIGURE NUGET SOURCE?"
    FULL_PATH=$(realpath "$DOWNLOAD_PATH")
    echo "📁 Package location: $FULL_PATH"
    
    echo -n "Do you want to configure NuGet to use this local source? (y/N): "
    read response
    
    if [[ "$response" =~ ^[Yy] ]]; then
        echo ""
        echo "⚙️  Configuring NuGet source..."
        
        # Remove existing source if it exists (to avoid conflicts)
        dotnet nuget remove source LocalExamPackages >/dev/null 2>&1
        
        # Add the new source
        if dotnet nuget add source "$FULL_PATH" --name LocalExamPackages >/dev/null 2>&1; then
            echo "✅ Successfully configured LocalExamPackages source!"
            echo ""
            echo "🔍 Verifying configuration..."
            dotnet nuget list source | grep -A 1 "LocalExamPackages"
            echo ""
            echo "🚀 You're all set! During exam, use:"
            echo "   dotnet add package PackageName --version X.X.X --source LocalExamPackages"
        else
            echo "❌ Failed to configure NuGet source"
            echo "💡 Manual command:"
            echo "   dotnet nuget add source \"$FULL_PATH\" --name LocalExamPackages"
        fi
    else
        echo ""
        echo "⏭️  Skipped NuGet configuration. Manual setup:"
        echo "   dotnet nuget add source \"$FULL_PATH\" --name LocalExamPackages"
        echo ""
        echo "🔍 To verify later:"
        echo "   dotnet nuget list source"
    fi
fi

if [ $fail_count -gt 0 ]; then
    echo ""
    echo "⚠️  Some packages failed to download. Check your internet connection"
    echo "   and try running the script again with --force flag."
fi

echo ""
echo "🚀 Setup complete! You're ready for offline exams."
echo "   Check EXAM_OFFLINE_SETUP.md for detailed usage instructions." 
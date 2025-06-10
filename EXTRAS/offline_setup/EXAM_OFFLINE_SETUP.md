# 🔌 Offline Package Setup for Exams

_"Because exams without internet are the stuff of nightmares"_

## 🎯 Purpose

This setup creates a **local NuGet repository** with all packages needed for multi-project MVC applications. Perfect for offline exam environments where internet access is restricted.

**📁 How it works:** The script creates an `ExamPackages` folder in your current directory, downloads all necessary packages there, then configures NuGet to use this local folder as a package source. Much cleaner than system-wide installation!

## 📦 One-Time Setup (Do This BEFORE the Exam)

### Step 1: Run the Package Download Script

**Windows PowerShell:**

```powershell
# Navigate to your desired setup location (e.g., your project folder)
cd C:\path\to\your\project

# Run the download script (creates ExamPackages folder here)
.\download-packages.ps1
```

**Windows Command Prompt / Git Bash:**

```bash
# Navigate to your desired setup location (e.g., your project folder)
cd /c/path/to/your/project

# Run the download script (creates ExamPackages folder here)
./download-packages.sh
```

### Step 2: Configure Local NuGet Source

**✨ The script handles this automatically!**

When the download completes, you'll see:

```
🎯 CONFIGURE NUGET SOURCE?
📁 Package location: C:\full\path\to\your\project\ExamPackages
Do you want to configure NuGet to use this local source? (y/N):
```

**Just press `Y` and Enter** - the script does everything for you!

**Manual Configuration (if needed):**

```powershell
# If the automatic setup fails, use this command:
nuget sources add -name "LocalExamPackages" -source "C:\path\to\your\ExamPackages"

# Verify configuration
nuget sources list
```

## 🚀 During the Exam (Offline Usage)

### Install Packages from Local Repository

**In Package Manager Console:**

```powershell
# Install packages from local source
Install-Package Microsoft.AspNetCore.Identity.EntityFrameworkCore -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.EntityFrameworkCore -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.EntityFrameworkCore.Design -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.EntityFrameworkCore.SqlServer -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.EntityFrameworkCore.Tools -Version 8.0.16 -Source LocalExamPackages

# For Authentication (if needed)
Install-Package Microsoft.AspNetCore.Authentication.Google -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.AspNetCore.Authentication.Facebook -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.AspNetCore.Authentication.OpenIdConnect -Version 8.0.16 -Source LocalExamPackages

# For API projects
Install-Package Swashbuckle.AspNetCore -Version 6.4.0 -Source LocalExamPackages
Install-Package Microsoft.AspNetCore.OpenApi -Version 8.0.16 -Source LocalExamPackages

# For scaffolding
Install-Package Microsoft.VisualStudio.Web.CodeGeneration.Design -Version 8.0.16 -Source LocalExamPackages

# For Identity Server (if needed)
Install-Package Duende.IdentityServer -Version 7.0.7 -Source LocalExamPackages
Install-Package Duende.IdentityServer.AspNetIdentity -Version 7.0.7 -Source LocalExamPackages
```

**Alternative - Using .NET CLI:**

```bash
# Install from local source
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore --version 8.0.16 --source LocalExamPackages
dotnet add package Microsoft.EntityFrameworkCore --version 8.0.16 --source LocalExamPackages
# ... etc for other packages
```

## 📋 Complete Package List

### Core Entity Framework Packages

- **Microsoft.EntityFrameworkCore** (8.0.16)
- **Microsoft.EntityFrameworkCore.Design** (8.0.16)
- **Microsoft.EntityFrameworkCore.SqlServer** (8.0.16)
- **Microsoft.EntityFrameworkCore.Tools** (8.0.16)

### Identity & Authentication

- **Microsoft.AspNetCore.Identity.EntityFrameworkCore** (8.0.16)
- **Microsoft.AspNetCore.Identity.UI** (8.0.16)
- **Microsoft.AspNetCore.Authentication.Google** (8.0.16)
- **Microsoft.AspNetCore.Authentication.Facebook** (8.0.16)
- **Microsoft.AspNetCore.Authentication.OpenIdConnect** (8.0.16)

### API & Swagger

- **Swashbuckle.AspNetCore** (6.4.0)
- **Microsoft.AspNetCore.OpenApi** (8.0.16)

### Development Tools

- **Microsoft.VisualStudio.Web.CodeGeneration.Design** (8.0.16)
- **Microsoft.AspNetCore.Diagnostics.EntityFrameworkCore** (8.0.16)

### Identity Server (Optional)

- **Duende.IdentityServer** (7.0.7)
- **Duende.IdentityServer.AspNetIdentity** (7.0.7)

### Bonus Packages (Commonly Needed)

- **AutoMapper** (12.0.1)
- **AutoMapper.Extensions.Microsoft.DependencyInjection** (12.0.1)
- **Serilog.AspNetCore** (8.0.0)
- **FluentValidation.AspNetCore** (11.3.0)

## 🔧 Quick Project Templates

### Basic MVC Project (.csproj)

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.AspNetCore.Diagnostics.EntityFrameworkCore" Version="8.0.16" />
    <PackageReference Include="Microsoft.AspNetCore.Identity.EntityFrameworkCore" Version="8.0.16" />
    <PackageReference Include="Microsoft.AspNetCore.Identity.UI" Version="8.0.16" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="8.0.16" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="8.0.16" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="8.0.16" />
    <PackageReference Include="Microsoft.VisualStudio.Web.CodeGeneration.Design" Version="8.0.16" />
  </ItemGroup>
</Project>
```

### API Project (.csproj)

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.AspNetCore.OpenApi" Version="8.0.16" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="8.0.16" />
    <PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="8.0.16" />
    <PackageReference Include="Swashbuckle.AspNetCore" Version="6.4.0" />
  </ItemGroup>
</Project>
```

## 🆘 Emergency Commands

### If You Need to Start Over

```bash
# Delete everything and start fresh
rm -rf bin/ obj/
dotnet clean
dotnet restore --source LocalExamPackages
dotnet build
```

### Verify Local Packages Work

```bash
# Test that packages are available locally
nuget list -source LocalExamPackages
# or
dotnet package search Microsoft.EntityFrameworkCore --source LocalExamPackages
```

### Reset NuGet Sources (If Messed Up)

```powershell
# Remove all sources and re-add
nuget sources Remove -name LocalExamPackages
nuget sources add -name "LocalExamPackages" -source "C:\full\path\to\your\ExamPackages"
```

## ⚠️ Troubleshooting

### Package Not Found

1. Check if the package is in your local folder: `.\ExamPackages`
2. Verify the source is configured: `nuget sources list`
3. Try clearing NuGet cache: `dotnet nuget locals all --clear`

### Version Conflicts

- Use exact version numbers as shown above
- If conflicts arise, use `--force` flag: `Install-Package PackageName -Force`

### Build Errors

1. Clean solution: `dotnet clean`
2. Restore from local: `dotnet restore --source LocalExamPackages`
3. Rebuild: `dotnet build`

## 📚 Exam Strategy

### Before Starting Your Project

1. ✅ Verify local packages work with a test project
2. ✅ Have this document open for reference
3. ✅ Know the exact package versions by heart
4. ✅ Practice the Install-Package commands

### During Implementation

1. **Start with project structure** - Create solution and projects first
2. **Add packages immediately** - Don't code without proper packages
3. **Use templates above** - Copy-paste the .csproj contents
4. **Test build frequently** - Don't let package issues accumulate

### Emergency Backup Plan

If local packages fail:

1. Copy entire `BookHaven` project as template
2. Rename namespaces and classes
3. Modify domain models to match exam requirements
4. Leverage existing working configuration

---

**Remember**: Practice this setup at least once before the exam. Murphy's Law guarantees that whatever can go wrong will go wrong during an exam! 🎯

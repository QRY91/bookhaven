# 🚨 EXAM CHEAT SHEET - Quick Reference

## 🔌 Essential Offline Package Commands

### Before Exam (One-time setup)

```powershell
# Download packages and configure automatically
.\download-packages.ps1
# When prompted, press 'Y' to configure NuGet source automatically!
```

### During Exam - Package Installation

```powershell
# Core packages (copy-paste these)
Install-Package Microsoft.AspNetCore.Identity.EntityFrameworkCore -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.EntityFrameworkCore -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.EntityFrameworkCore.Design -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.EntityFrameworkCore.SqlServer -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.EntityFrameworkCore.Tools -Version 8.0.16 -Source LocalExamPackages
Install-Package Microsoft.VisualStudio.Web.CodeGeneration.Design -Version 8.0.16 -Source LocalExamPackages

# For API projects
Install-Package Swashbuckle.AspNetCore -Version 6.4.0 -Source LocalExamPackages
Install-Package Microsoft.AspNetCore.OpenApi -Version 8.0.16 -Source LocalExamPackages
```

## 🏗️ Quick Project Setup

### Solution Structure

```bash
dotnet new sln -n ExamProject
dotnet new mvc -n ExamProject.MVC
dotnet new webapi -n ExamProject.Api
dotnet new classlib -n ExamProject.Shared
dotnet sln add **/*.csproj
```

### Essential .csproj Template (MVC)

```xml
<PackageReference Include="Microsoft.AspNetCore.Identity.EntityFrameworkCore" Version="8.0.16" />
<PackageReference Include="Microsoft.EntityFrameworkCore.Design" Version="8.0.16" />
<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="8.0.16" />
<PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="8.0.16" />
<PackageReference Include="Microsoft.VisualStudio.Web.CodeGeneration.Design" Version="8.0.16" />
```

## ⚡ Essential Commands

### Database

```bash
dotnet ef migrations add InitialCreate
dotnet ef database update
dotnet ef database drop --force  # If you need to start over
```

### Scaffolding

```bash
# Identity pages
dotnet aspnet-codegenerator identity -dc YourContext --files "Account.Login;Account.Register"

# Controller
dotnet aspnet-codegenerator controller -name EntityController -m Entity -dc YourContext --relativeFolderPath Controllers --useDefaultLayout
```

### Build & Run

```bash
dotnet clean
dotnet build
dotnet run
```

## 🔑 Authentication Setup (Copy-Paste)

### Program.cs Identity Configuration

```csharp
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options => {
    options.SignIn.RequireConfirmedAccount = false;
    options.Password.RequireDigit = true;
    options.Password.RequireLowercase = true;
    options.Password.RequireUppercase = true;
    options.Password.RequireNonAlphanumeric = true;
    options.Password.RequiredLength = 8;
    options.User.RequireUniqueEmail = true;
    options.User.AllowedUserNameCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._@+";
}).AddEntityFrameworkStores<YourDbContext>()
  .AddDefaultTokenProviders();
```

### DbContext Template

```csharp
public class YourDbContext : IdentityDbContext<ApplicationUser>
{
    public YourDbContext(DbContextOptions<YourDbContext> options) : base(options) { }

    public DbSet<YourEntity> YourEntities { get; set; }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
        // Configure relationships here
    }
}
```

## 🆘 Emergency Fixes

### Package Issues

```powershell
# Reset NuGet sources
nuget sources Remove -name LocalExamPackages
nuget sources add -name "LocalExamPackages" -source "C:\full\path\to\ExamPackages"

# Force reinstall
Install-Package PackageName -Force -Source LocalExamPackages
```

### Build Issues

```bash
# Nuclear option - start fresh
rm -rf bin/ obj/
dotnet clean
dotnet restore --source LocalExamPackages
dotnet build
```

### Authentication Issues

- Check: Email as username in ApplicationUser creation
- Check: `options.SignIn.RequireConfirmedAccount = false`
- Check: No duplicate `AddDefaultIdentity` and `AddIdentity`

## 📝 Domain Model Template

```csharp
public class YourEntity
{
    public int Id { get; set; }

    [Required]
    [StringLength(100)]
    public string Name { get; set; } = string.Empty;

    public string Description { get; set; } = string.Empty;

    [DataType(DataType.Currency)]
    public decimal Price { get; set; }

    public DateTime CreatedDate { get; set; } = DateTime.Now;

    public bool IsActive { get; set; } = true;

    // Foreign Key
    public int CategoryId { get; set; }
    public virtual Category? Category { get; set; }

    // Collection
    public virtual ICollection<RelatedEntity>? RelatedItems { get; set; }
}
```

## 🎯 Exam Strategy

1. **Read requirements twice** - Understand domain
2. **Setup solution structure first** - Get architecture right
3. **Install packages immediately** - Don't code without them
4. **Create models in Shared project** - Start with domain
5. **Setup DbContext and migrations** - Get data layer working
6. **Configure authentication** - Identity setup
7. **Scaffold controllers/views** - UI layer
8. **Test frequently** - Build after each major step

---

**💡 Remember**: If all else fails, copy BookHaven project and modify it to match exam requirements!

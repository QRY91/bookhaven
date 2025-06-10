# ===================================================================
# BOOKHAVEN TRANSFORMATION WIZARD
# ===================================================================
# Interactive script to transform BookHaven into any exam scenario
# Prompts user for mappings and does all the find/replace magic
# ===================================================================

param(
    [string]$SourcePath = ".",
    [string]$TargetPath = "",
    [switch]$Force
)

Write-Host "🚀 BookHaven Transformation Wizard" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green
Write-Host ""

# Function to get user input with default
function Get-UserInput {
    param(
        [string]$Prompt,
        [string]$Default = ""
    )
    
    if ($Default) {
        $input = Read-Host "$Prompt [$Default]"
        if ([string]::IsNullOrWhiteSpace($input)) {
            return $Default
        }
        return $input
    } else {
        return Read-Host $Prompt
    }
}

# Function to show scenario suggestions
function Show-ScenarioSuggestions {
    Write-Host "💡 Common Exam Scenarios:" -ForegroundColor Cyan
    Write-Host "   1. Restaurant (PxlEats): Restaurant → MenuItem → FoodType" -ForegroundColor Gray
    Write-Host "   2. Hotel (PxlStay): Hotel → Room → RoomType" -ForegroundColor Gray
    Write-Host "   3. E-Learning (PxlLearn): Instructor → Course → Level" -ForegroundColor Gray
    Write-Host "   4. Library (PxlLibrary): Author → Book → Genre" -ForegroundColor Gray
    Write-Host "   5. Inventory (PxlStock): Supplier → Product → ProductType" -ForegroundColor Gray
    Write-Host "   6. Events (PxlEvents): Venue → Event → EventType" -ForegroundColor Gray
    Write-Host ""
}

# Get transformation details from user
Write-Host "📋 Let's set up your transformation..." -ForegroundColor Yellow
Write-Host ""

Show-ScenarioSuggestions

$projectName = Get-UserInput "Enter new project name (e.g., PxlEats, PxlStay)" "PxlEats"
$entity1New = Get-UserInput "Author will become" "Restaurant"
$entity2New = Get-UserInput "Book will become" "MenuItem" 
$entity3New = Get-UserInput "Category will become (optional)" "FoodType"

# Determine target path
if ([string]::IsNullOrWhiteSpace($TargetPath)) {
    $TargetPath = "../$projectName"
}

Write-Host ""
Write-Host "🎯 Transformation Summary:" -ForegroundColor Green
Write-Host "   Project: BookHaven → $projectName" -ForegroundColor White
Write-Host "   Entity1: Author → $entity1New" -ForegroundColor White
Write-Host "   Entity2: Book → $entity2New" -ForegroundColor White
if ($entity3New -ne "Category") {
    Write-Host "   Entity3: Category → $entity3New" -ForegroundColor White
}
Write-Host "   Target: $TargetPath" -ForegroundColor White
Write-Host ""

$confirm = Get-UserInput "Continue with transformation? (y/N)" "N"
if ($confirm -notmatch '^[Yy]') {
    Write-Host "❌ Transformation cancelled." -ForegroundColor Red
    exit 0
}

Write-Host ""
Write-Host "🚀 Starting transformation..." -ForegroundColor Green

# Check if target exists
if (Test-Path $TargetPath) {
    if ($Force) {
        Write-Host "🧹 Removing existing target directory..." -ForegroundColor Yellow
        Remove-Item -Path $TargetPath -Recurse -Force
    } else {
        Write-Host "❌ Target directory already exists: $TargetPath" -ForegroundColor Red
        Write-Host "   Use -Force to overwrite or choose a different name." -ForegroundColor Gray
        exit 1
    }
}

try {
    # Step 1: Copy source to target
    Write-Host "📁 Copying BookHaven to $TargetPath..." -ForegroundColor Cyan
    Copy-Item -Path $SourcePath -Destination $TargetPath -Recurse -Force
    
    # Step 2: Rename solution and project files
    Write-Host "📝 Renaming solution and project files..." -ForegroundColor Cyan
    
    # Rename solution file
    $oldSln = Get-ChildItem -Path $TargetPath -Name "*.sln" | Select-Object -First 1
    if ($oldSln) {
        $newSln = $oldSln -replace "BookHaven", $projectName
        Rename-Item -Path "$TargetPath\$oldSln" -NewName $newSln
    }
    
    # Rename project directories
    $projectDirs = @("BookHaven.MVC", "BookHaven.Shared", "BookHaven.OrderApi", "BookHaven.IdentityServer")
    foreach ($dir in $projectDirs) {
        $oldPath = "$TargetPath\$dir"
        if (Test-Path $oldPath) {
            $newDir = $dir -replace "BookHaven", $projectName
            $newPath = "$TargetPath\$newDir"
            Rename-Item -Path $oldPath -NewName $newDir
            
            # Rename .csproj files inside
            $oldCsproj = "$newPath\$dir.csproj"
            if (Test-Path $oldCsproj) {
                $newCsproj = "$newPath\$newDir.csproj"
                Rename-Item -Path $oldCsproj -NewName "$newDir.csproj"
            }
        }
    }
    
    # Step 3: Global content replacement
    Write-Host "🔄 Performing global find/replace operations..." -ForegroundColor Cyan
    
    # Get all relevant files
    $files = Get-ChildItem -Path $TargetPath -Recurse -Include "*.cs", "*.csproj", "*.sln", "*.cshtml", "*.json" | 
             Where-Object { $_.FullName -notmatch "\\bin\\|\\obj\\|\\Migrations\\|\\.git\\" }
    
    $totalFiles = $files.Count
    $processedFiles = 0
    
    foreach ($file in $files) {
        $processedFiles++
        Write-Progress -Activity "Transforming files" -Status "Processing $($file.Name)" -PercentComplete (($processedFiles / $totalFiles) * 100)
        
        try {
            $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
            $originalContent = $content
            
            # Replace project names
            $content = $content -replace "BookHaven", $projectName
            
            # Replace entity names (be careful with order and word boundaries)
            $content = $content -replace "\bAuthor\b", $entity1New
            $content = $content -replace "\bBook\b", $entity2New
            
            if ($entity3New -ne "Category") {
                # Only replace Category in specific contexts to avoid breaking system classes
                $content = $content -replace "\bCategory\b(?=\s*[{;,)\]])", $entity3New
                $content = $content -replace "\bCategories\b", "$($entity3New)s"
            }
            
            # Pluralization fixes
            $content = $content -replace "\b$($entity1New)s\b", "$($entity1New)s"
            $content = $content -replace "\b$($entity2New)s\b", "$($entity2New)s"
            
            # Only write if content changed
            if ($content -ne $originalContent) {
                Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            }
        }
        catch {
            Write-Warning "Failed to process file: $($file.FullName) - $($_.Exception.Message)"
        }
    }
    
    Write-Progress -Activity "Transforming files" -Completed
    
    # Step 4: Rename model files
    Write-Host "📂 Renaming model files..." -ForegroundColor Cyan
    
    $modelsPath = "$TargetPath\$projectName.Shared\Models"
    if (Test-Path $modelsPath) {
        $authorFile = "$modelsPath\Author.cs"
        $bookFile = "$modelsPath\Book.cs"
        
        if (Test-Path $authorFile) {
            Rename-Item -Path $authorFile -NewName "$entity1New.cs"
        }
        
        if (Test-Path $bookFile) {
            Rename-Item -Path $bookFile -NewName "$entity2New.cs"
        }
    }
    
    # Step 5: Rename controller files
    Write-Host "🎮 Renaming controller files..." -ForegroundColor Cyan
    
    $controllersPath = "$TargetPath\$projectName.MVC\Controllers"
    if (Test-Path $controllersPath) {
        $authorsController = "$controllersPath\AuthorsController.cs"
        $booksController = "$controllersPath\BooksController.cs"
        
        if (Test-Path $authorsController) {
            Rename-Item -Path $authorsController -NewName "$($entity1New)sController.cs"
        }
        
        if (Test-Path $booksController) {
            Rename-Item -Path $booksController -NewName "$($entity2New)sController.cs"
        }
    }
    
    # Step 6: Rename view directories
    Write-Host "👁️ Renaming view directories..." -ForegroundColor Cyan
    
    $viewsPath = "$TargetPath\$projectName.MVC\Views"
    if (Test-Path $viewsPath) {
        $authorsViews = "$viewsPath\Authors"
        $booksViews = "$viewsPath\Books"
        
        if (Test-Path $authorsViews) {
            Rename-Item -Path $authorsViews -NewName "$($entity1New)s"
        }
        
        if (Test-Path $booksViews) {
            Rename-Item -Path $booksViews -NewName "$($entity2New)s"
        }
    }
    
    # Step 7: Clean up old migrations
    Write-Host "🧹 Cleaning up old migrations..." -ForegroundColor Cyan
    
    $migrationsPath = "$TargetPath\$projectName.MVC\Migrations"
    if (Test-Path $migrationsPath) {
        Remove-Item -Path $migrationsPath -Recurse -Force
    }
    
    # Step 8: Generate basic working SeedData
    Write-Host "📊 Generating basic working seed data..." -ForegroundColor Cyan
    
    $seedDataPath = "$TargetPath\$projectName.MVC\Data\SeedData.cs"
    if (Test-Path $seedDataPath) {
        $seedTemplate = @"
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using $projectName.Shared.Models;

namespace $projectName.MVC.Data;

public static class SeedData
{
    public static async Task Initialize(IServiceProvider serviceProvider)
    {
        using var context = new ApplicationDbContext(
            serviceProvider.GetRequiredService<DbContextOptions<ApplicationDbContext>>());

        var userManager = serviceProvider.GetRequiredService<UserManager<ApplicationUser>>();
        var roleManager = serviceProvider.GetRequiredService<RoleManager<IdentityRole>>();

        // Seed Roles
        if (!await roleManager.RoleExistsAsync("Admin"))
        {
            await roleManager.CreateAsync(new IdentityRole("Admin"));
        }
        if (!await roleManager.RoleExistsAsync("User"))
        {
            await roleManager.CreateAsync(new IdentityRole("User"));
        }

        // Seed Admin User
        const string adminEmail = "admin@$($projectName.ToLower()).com";
        const string adminPassword = "Admin123!";

        var adminUser = await userManager.FindByEmailAsync(adminEmail);
        if (adminUser == null)
        {
            adminUser = new ApplicationUser
            {
                UserName = adminEmail,
                Email = adminEmail,
                EmailConfirmed = true
            };
            await userManager.CreateAsync(adminUser, adminPassword);
            await userManager.AddToRoleAsync(adminUser, "Admin");
        }

        // Seed Categories
        if (!context.Categories.Any())
        {
            var categories = new[]
            {
                new Category { Name = "Type A", Description = "First category type" },
                new Category { Name = "Type B", Description = "Second category type" },
                new Category { Name = "Type C", Description = "Third category type" }
            };
            context.Categories.AddRange(categories);
            await context.SaveChangesAsync();
        }

        // Seed $($entity1New)s
        if (!context.$($entity1New)s.Any())
        {
            var providers = new[]
            {
                new $entity1New { Name = "Provider One", Email = "provider1@example.com" },
                new $entity1New { Name = "Provider Two", Email = "provider2@example.com" }
            };
            context.$($entity1New)s.AddRange(providers);
            await context.SaveChangesAsync();
        }

        // Seed $($entity2New)s
        if (!context.$($entity2New)s.Any())
        {
            var category1 = context.Categories.First();
            var category2 = context.Categories.Skip(1).First();
            var provider1 = context.$($entity1New)s.First();
            var provider2 = context.$($entity1New)s.Skip(1).First();

            var items = new[]
            {
                new $entity2New { Title = "Item One", Description = "First item", Price = 10.99m, $($entity1New)Id = provider1.Id, CategoryId = category1.Id },
                new $entity2New { Title = "Item Two", Description = "Second item", Price = 15.99m, $($entity1New)Id = provider1.Id, CategoryId = category2.Id },
                new $entity2New { Title = "Item Three", Description = "Third item", Price = 20.99m, $($entity1New)Id = provider2.Id, CategoryId = category1.Id }
            };
            context.$($entity2New)s.AddRange(items);
            await context.SaveChangesAsync();
        }
    }
}
"@
        Set-Content -Path $seedDataPath -Value $seedTemplate -Encoding UTF8
    }
    
    # Step 9: Configure multi-project startup profiles
    Write-Host "🚀 Configuring multi-project startup profiles..." -ForegroundColor Cyan
    
    # Create Properties folder for Visual Studio launch profiles
    $propertiesPath = "$TargetPath\Properties"
    if (!(Test-Path $propertiesPath)) {
        New-Item -Path $propertiesPath -ItemType Directory -Force | Out-Null
    }
    
    # Create launchSettings.json for the solution
    $launchSettingsPath = "$propertiesPath\launchSettings.json"
    $launchSettings = @{
        profiles = [ordered]@{
            "$projectName (Multi-Project)" = [ordered]@{
                commandName = "Project"
                launchBrowser = $true
                applicationUrl = "https://localhost:7234;http://localhost:5234"
                environmentVariables = [ordered]@{
                    ASPNETCORE_ENVIRONMENT = "Development"
                }
            }
        }
    }
    
    $launchSettingsJson = $launchSettings | ConvertTo-Json -Depth 4
    Set-Content -Path $launchSettingsPath -Value $launchSettingsJson -Encoding UTF8
    
    # Create .vscode configuration for VS Code users
    $vscodePath = "$TargetPath\.vscode"
    if (!(Test-Path $vscodePath)) {
        New-Item -Path $vscodePath -ItemType Directory -Force | Out-Null
    }
    
    # Create compound launch configuration
    $vscodeConfig = [ordered]@{
        version = "0.2.0"
        configurations = @(
            [ordered]@{
                name = "$projectName.IdentityServer"
                type = "coreclr"
                request = "launch"
                preLaunchTask = "build"
                program = "`${workspaceFolder}/$projectName.IdentityServer/bin/Debug/net8.0/$projectName.IdentityServer.dll"
                args = @()
                cwd = "`${workspaceFolder}/$projectName.IdentityServer"
                env = [ordered]@{
                    ASPNETCORE_ENVIRONMENT = "Development"
                    ASPNETCORE_URLS = "https://localhost:5001"
                }
                sourceFileMap = [ordered]@{
                    "/Views" = "`${workspaceFolder}/Views"
                }
            }
            [ordered]@{
                name = "$projectName.OrderApi"
                type = "coreclr"
                request = "launch"
                preLaunchTask = "build"
                program = "`${workspaceFolder}/$projectName.OrderApi/bin/Debug/net8.0/$projectName.OrderApi.dll"
                args = @()
                cwd = "`${workspaceFolder}/$projectName.OrderApi"
                env = [ordered]@{
                    ASPNETCORE_ENVIRONMENT = "Development"
                    ASPNETCORE_URLS = "https://localhost:7232"
                }
            }
            [ordered]@{
                name = "$projectName.MVC"
                type = "coreclr"
                request = "launch"
                preLaunchTask = "build"
                program = "`${workspaceFolder}/$projectName.MVC/bin/Debug/net8.0/$projectName.MVC.dll"
                args = @()
                cwd = "`${workspaceFolder}/$projectName.MVC"
                env = [ordered]@{
                    ASPNETCORE_ENVIRONMENT = "Development"
                    ASPNETCORE_URLS = "https://localhost:7234"
                }
                serverReadyAction = [ordered]@{
                    action = "openExternally"
                    pattern = "\\bNow listening on:\\s+(https?://\\S+)"
                }
            }
        )
        compounds = @(
            [ordered]@{
                name = "Launch All $projectName Services"
                configurations = @(
                    "$projectName.IdentityServer"
                    "$projectName.OrderApi"
                    "$projectName.MVC"
                )
            }
        )
    }
    
    $vscodeConfigJson = $vscodeConfig | ConvertTo-Json -Depth 5
    Set-Content -Path "$vscodePath\launch.json" -Value $vscodeConfigJson -Encoding UTF8
    
    # Create tasks.json for VS Code build task
    $tasksConfig = [ordered]@{
        version = "2.0.0"
        tasks = @(
            [ordered]@{
                label = "build"
                command = "dotnet"
                type = "process"
                args = @("build")
                options = [ordered]@{
                    cwd = "`${workspaceFolder}"
                }
                group = [ordered]@{
                    kind = "build"
                    isDefault = $true
                }
                presentation = [ordered]@{
                    echo = $true
                    reveal = "silent"
                    focus = $false
                    panel = "shared"
                    showReuseMessage = $true
                    clear = $false
                }
                problemMatcher = "`$msCompile"
            }
        )
    }
    
    $tasksConfigJson = $tasksConfig | ConvertTo-Json -Depth 4
    Set-Content -Path "$vscodePath\tasks.json" -Value $tasksConfigJson -Encoding UTF8
    
    Write-Host ""
    Write-Host "🚀 Making project ready to run..." -ForegroundColor Green
    
    # Ask if user wants automatic setup
    $autoSetup = Get-UserInput "Do you want to automatically create migration and build? (Y/n)" "Y"
    
    if ($autoSetup -match '^[Yy]|^$') {
        Push-Location $TargetPath
        
        try {
            # Step 10: Create migration
            Write-Host "📦 Creating migration..." -ForegroundColor Cyan
            $migrationResult = & dotnet ef migrations add Initial --project "$projectName.MVC" 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "   ✅ Migration created successfully" -ForegroundColor Green
                
                # Step 11: Update database
                Write-Host "💾 Updating database..." -ForegroundColor Cyan
                $dbResult = & dotnet ef database update --project "$projectName.MVC" 2>&1
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "   ✅ Database updated successfully" -ForegroundColor Green
                    
                    # Step 12: Build project
                    Write-Host "🔨 Building project..." -ForegroundColor Cyan
                    $buildResult = & dotnet build 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host "   ✅ Project built successfully" -ForegroundColor Green
                        Write-Host ""
                        Write-Host "🎉 PROJECT IS READY TO RUN! 🎉" -ForegroundColor Green
                        Write-Host ""
                        Write-Host "🚀 To start your application:" -ForegroundColor Yellow
                        Write-Host "   Visual Studio: Open solution and press F5 (multi-project startup configured)" -ForegroundColor Gray
                        Write-Host "   VS Code: Open folder and run 'Launch All $projectName Services' compound" -ForegroundColor Gray
                        Write-Host "   Command line: dotnet run --project $projectName.MVC" -ForegroundColor Gray
                        Write-Host ""
                        Write-Host "🌐 Then visit: https://localhost:7234" -ForegroundColor Cyan
                        Write-Host "📧 Login with: admin@$($projectName.ToLower()).com / Admin123!" -ForegroundColor Cyan
                    } else {
                        Write-Host "   ❌ Build failed. Check the output above." -ForegroundColor Red
                        Write-Host $buildResult
                    }
                } else {
                    Write-Host "   ❌ Database update failed. Check the output above." -ForegroundColor Red
                    Write-Host $dbResult
                }
            } else {
                Write-Host "   ❌ Migration creation failed. Check the output above." -ForegroundColor Red
                Write-Host $migrationResult
            }
        }
        finally {
            Pop-Location
        }
    } else {
        Write-Host ""
        Write-Host "✅ Transformation completed successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host "🎯 Next Steps:" -ForegroundColor Yellow
        Write-Host "   1. cd $TargetPath" -ForegroundColor Gray
        Write-Host "   2. dotnet ef migrations add Initial --project $projectName.MVC" -ForegroundColor Gray
        Write-Host "   3. dotnet ef database update --project $projectName.MVC" -ForegroundColor Gray
        Write-Host "   4. dotnet build" -ForegroundColor Gray
        Write-Host "   5. dotnet run --project $projectName.MVC" -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host "📝 To customize for your specific scenario:" -ForegroundColor Cyan
    Write-Host "   • Update SeedData.cs with domain-specific data" -ForegroundColor Gray
    Write-Host "   • Modify entity properties to match business requirements" -ForegroundColor Gray
    Write-Host "   • Add validation rules and business logic" -ForegroundColor Gray
    
} catch {
    Write-Host ""
    Write-Host "❌ Transformation failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 You may need to clean up the target directory and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🎉 Happy coding! Your transformed project is ready." -ForegroundColor Green 
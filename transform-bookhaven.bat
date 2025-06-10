@echo off
setlocal enabledelayedexpansion

:: ===================================================================
:: BOOKHAVEN TRANSFORMATION WIZARD (BATCH VERSION)
:: ===================================================================
:: Simple batch file alternative for transforming BookHaven
:: ===================================================================

echo.
echo 🚀 BookHaven Transformation Wizard (Batch Version)
echo ===================================================
echo.

:: Show scenario suggestions
echo 💡 Common Exam Scenarios:
echo    1. Restaurant (PxlEats): Restaurant → MenuItem → FoodType
echo    2. Hotel (PxlStay): Hotel → Room → RoomType  
echo    3. E-Learning (PxlLearn): Instructor → Course → Level
echo    4. Library (PxlLibrary): Author → Book → Genre
echo    5. Inventory (PxlStock): Supplier → Product → ProductType
echo    6. Events (PxlEvents): Venue → Event → EventType
echo.

:: Get user input
set /p "projectName=Enter new project name (e.g., PxlEats): "
if "%projectName%"=="" set "projectName=PxlEats"

set /p "entity1New=Author will become: "
if "%entity1New%"=="" set "entity1New=Restaurant"

set /p "entity2New=Book will become: "
if "%entity2New%"=="" set "entity2New=MenuItem"

set /p "entity3New=Category will become (optional): "
if "%entity3New%"=="" set "entity3New=FoodType"

set "targetPath=..\%projectName%"

echo.
echo 🎯 Transformation Summary:
echo    Project: BookHaven → %projectName%
echo    Entity1: Author → %entity1New%
echo    Entity2: Book → %entity2New%
echo    Entity3: Category → %entity3New%
echo    Target: %targetPath%
echo.

set /p "confirm=Continue with transformation? (y/N): "
if /i not "%confirm%"=="y" (
    echo ❌ Transformation cancelled.
    pause
    exit /b 0
)

echo.
echo 🚀 Starting transformation...

:: Check if target exists
if exist "%targetPath%" (
    echo ❌ Target directory already exists: %targetPath%
    echo    Please remove it first or choose a different name.
    pause
    exit /b 1
)

:: Copy BookHaven to target
echo 📁 Copying BookHaven to %targetPath%...
xcopy /E /I /Q . "%targetPath%" >nul

:: Use PowerShell for the heavy lifting (find/replace operations)
echo 🔄 Running PowerShell transformation script...
powershell.exe -ExecutionPolicy Bypass -Command ^
    "$targetPath = '%targetPath%'; " ^
    "$projectName = '%projectName%'; " ^
    "$entity1New = '%entity1New%'; " ^
    "$entity2New = '%entity2New%'; " ^
    "$entity3New = '%entity3New%'; " ^
    "$files = Get-ChildItem -Path $targetPath -Recurse -Include '*.cs', '*.csproj', '*.sln', '*.cshtml' | Where-Object { $_.FullName -notmatch '\\bin\\|\\obj\\|\\Migrations\\' }; " ^
    "foreach ($file in $files) { " ^
        "$content = Get-Content -Path $file.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue; " ^
        "if ($content) { " ^
            "$originalContent = $content; " ^
            "$content = $content -replace 'BookHaven', $projectName; " ^
            "$content = $content -replace '\\bAuthor\\b', $entity1New; " ^
            "$content = $content -replace '\\bBook\\b', $entity2New; " ^
            "if ($entity3New -ne 'Category') { $content = $content -replace '\\bCategory\\b(?=\\s*[{;,)\\]])', $entity3New; $content = $content -replace '\\bCategories\\b', ($entity3New + 's'); }; " ^
            "if ($content -ne $originalContent) { Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline; }; " ^
        "} " ^
    "}; " ^
    "Write-Host 'File transformation completed.' -ForegroundColor Green;"

:: Rename files and directories
echo 📂 Renaming files and directories...

:: Rename solution file
for %%f in ("%targetPath%\*.sln") do (
    set "newName=%%~nf"
    set "newName=!newName:BookHaven=%projectName%!"
    ren "%%f" "!newName!.sln"
)

:: Rename project directories
if exist "%targetPath%\BookHaven.MVC" ren "%targetPath%\BookHaven.MVC" "%projectName%.MVC"
if exist "%targetPath%\BookHaven.Shared" ren "%targetPath%\BookHaven.Shared" "%projectName%.Shared"
if exist "%targetPath%\BookHaven.OrderApi" ren "%targetPath%\BookHaven.OrderApi" "%projectName%.OrderApi"
if exist "%targetPath%\BookHaven.IdentityServer" ren "%targetPath%\BookHaven.IdentityServer" "%projectName%.IdentityServer"

:: Rename .csproj files
for /r "%targetPath%" %%f in (BookHaven*.csproj) do (
    set "file=%%~nf"
    set "newFile=!file:BookHaven=%projectName%!"
    ren "%%f" "!newFile!.csproj"
)

:: Rename model files
if exist "%targetPath%\%projectName%.Shared\Models\Author.cs" ren "%targetPath%\%projectName%.Shared\Models\Author.cs" "%entity1New%.cs"
if exist "%targetPath%\%projectName%.Shared\Models\Book.cs" ren "%targetPath%\%projectName%.Shared\Models\Book.cs" "%entity2New%.cs"

:: Rename controller files
if exist "%targetPath%\%projectName%.MVC\Controllers\AuthorsController.cs" ren "%targetPath%\%projectName%.MVC\Controllers\AuthorsController.cs" "%entity1New%sController.cs"
if exist "%targetPath%\%projectName%.MVC\Controllers\BooksController.cs" ren "%targetPath%\%projectName%.MVC\Controllers\BooksController.cs" "%entity2New%sController.cs"

:: Rename view directories
if exist "%targetPath%\%projectName%.MVC\Views\Authors" ren "%targetPath%\%projectName%.MVC\Views\Authors" "%entity1New%s"
if exist "%targetPath%\%projectName%.MVC\Views\Books" ren "%targetPath%\%projectName%.MVC\Views\Books" "%entity2New%s"

:: Clean up migrations
if exist "%targetPath%\%projectName%.MVC\Migrations" rmdir /s /q "%targetPath%\%projectName%.MVC\Migrations"

:: Generate basic seed data
echo 📊 Generating basic working seed data...
set "PROJECT_NAME_LOWER=%projectName%"
call :toLowerCase PROJECT_NAME_LOWER
powershell -ExecutionPolicy Bypass -Command ^
    "$seedDataPath = '%targetPath%\\%projectName%.MVC\\Data\\SeedData.cs'; " ^
    "if (Test-Path $seedDataPath) { " ^
        "$seedTemplate = @'`n" ^
        "using Microsoft.AspNetCore.Identity;`n" ^
        "using Microsoft.EntityFrameworkCore;`n" ^
        "using %projectName%.Shared.Models;`n`n" ^
        "namespace %projectName%.MVC.Data;`n`n" ^
        "public static class SeedData`n" ^
        "{`n" ^
        "    public static async Task Initialize(IServiceProvider serviceProvider)`n" ^
        "    {`n" ^
        "        using var context = new ApplicationDbContext(`n" ^
        "            serviceProvider.GetRequiredService<DbContextOptions<ApplicationDbContext>>());`n`n" ^
        "        var userManager = serviceProvider.GetRequiredService<UserManager<ApplicationUser>>();`n" ^
        "        var roleManager = serviceProvider.GetRequiredService<RoleManager<IdentityRole>>();`n`n" ^
        "        // Seed Roles`n" ^
        "        if (!await roleManager.RoleExistsAsync(\"Admin\"))`n" ^
        "        {`n" ^
        "            await roleManager.CreateAsync(new IdentityRole(\"Admin\"));`n" ^
        "        }`n" ^
        "        if (!await roleManager.RoleExistsAsync(\"User\"))`n" ^
        "        {`n" ^
        "            await roleManager.CreateAsync(new IdentityRole(\"User\"));`n" ^
        "        }`n`n" ^
        "        // Seed Admin User`n" ^
        "        const string adminEmail = \"admin@!PROJECT_NAME_LOWER!.com\";`n" ^
        "        const string adminPassword = \"Admin123!\";`n`n" ^
        "        var adminUser = await userManager.FindByEmailAsync(adminEmail);`n" ^
        "        if (adminUser == null)`n" ^
        "        {`n" ^
        "            adminUser = new ApplicationUser`n" ^
        "            {`n" ^
        "                UserName = adminEmail,`n" ^
        "                Email = adminEmail,`n" ^
        "                EmailConfirmed = true`n" ^
        "            };`n" ^
        "            await userManager.CreateAsync(adminUser, adminPassword);`n" ^
        "            await userManager.AddToRoleAsync(adminUser, \"Admin\");`n" ^
        "        }`n`n" ^
        "        // Seed Categories`n" ^
        "        if (!context.Categories.Any())`n" ^
        "        {`n" ^
        "            var categories = new[]`n" ^
        "            {`n" ^
        "                new Category { Name = \"Type A\", Description = \"First category type\" },`n" ^
        "                new Category { Name = \"Type B\", Description = \"Second category type\" },`n" ^
        "                new Category { Name = \"Type C\", Description = \"Third category type\" }`n" ^
        "            };`n" ^
        "            context.Categories.AddRange(categories);`n" ^
        "            await context.SaveChangesAsync();`n" ^
        "        }`n`n" ^
        "        // Seed %entity1New%s`n" ^
        "        if (!context.%entity1New%s.Any())`n" ^
        "        {`n" ^
        "            var providers = new[]`n" ^
        "            {`n" ^
        "                new %entity1New% { Name = \"Provider One\", Email = \"provider1@example.com\" },`n" ^
        "                new %entity1New% { Name = \"Provider Two\", Email = \"provider2@example.com\" }`n" ^
        "            };`n" ^
        "            context.%entity1New%s.AddRange(providers);`n" ^
        "            await context.SaveChangesAsync();`n" ^
        "        }`n`n" ^
        "        // Seed %entity2New%s`n" ^
        "        if (!context.%entity2New%s.Any())`n" ^
        "        {`n" ^
        "            var category1 = context.Categories.First();`n" ^
        "            var category2 = context.Categories.Skip(1).First();`n" ^
        "            var provider1 = context.%entity1New%s.First();`n" ^
        "            var provider2 = context.%entity1New%s.Skip(1).First();`n`n" ^
        "            var items = new[]`n" ^
        "            {`n" ^
        "                new %entity2New% { Title = \"Item One\", Description = \"First item\", Price = 10.99m, %entity1New%Id = provider1.Id, CategoryId = category1.Id },`n" ^
        "                new %entity2New% { Title = \"Item Two\", Description = \"Second item\", Price = 15.99m, %entity1New%Id = provider1.Id, CategoryId = category2.Id },`n" ^
        "                new %entity2New% { Title = \"Item Three\", Description = \"Third item\", Price = 20.99m, %entity1New%Id = provider2.Id, CategoryId = category1.Id }`n" ^
        "            };`n" ^
        "            context.%entity2New%s.AddRange(items);`n" ^
        "            await context.SaveChangesAsync();`n" ^
        "        }`n" ^
        "    }`n" ^
        "}`n" ^
        "'@; " ^
        "$seedTemplate = $seedTemplate -replace '!PROJECT_NAME_LOWER!', '%PROJECT_NAME_LOWER%'; " ^
        "Set-Content -Path $seedDataPath -Value $seedTemplate -Encoding UTF8; " ^
    "}"

:: Configure multi-project startup profiles
echo 🚀 Configuring multi-project startup profiles...

:: Create Properties folder for Visual Studio launch profiles
if not exist "%targetPath%\Properties" mkdir "%targetPath%\Properties"

:: Create launchSettings.json for the solution
powershell -ExecutionPolicy Bypass -Command ^
    "$launchSettings = @{ " ^
        "profiles = @{ " ^
            "'%projectName% (Multi-Project)' = @{ " ^
                "commandName = 'Project'; " ^
                "launchBrowser = $true; " ^
                "applicationUrl = 'https://localhost:7234;http://localhost:5234'; " ^
                "environmentVariables = @{ ASPNETCORE_ENVIRONMENT = 'Development' } " ^
            "} " ^
        "} " ^
    "}; " ^
    "$json = $launchSettings | ConvertTo-Json -Depth 4; " ^
    "Set-Content -Path '%targetPath%\\Properties\\launchSettings.json' -Value $json -Encoding UTF8;"

:: Create .vscode configuration for VS Code users
if not exist "%targetPath%\.vscode" mkdir "%targetPath%\.vscode"

:: Create launch.json with compound configuration
powershell -ExecutionPolicy Bypass -Command ^
    "$vscodeConfig = @{ " ^
        "version = '0.2.0'; " ^
        "configurations = @( " ^
            "@{ name = '%projectName%.IdentityServer'; type = 'coreclr'; request = 'launch'; preLaunchTask = 'build'; program = '${workspaceFolder}/%projectName%.IdentityServer/bin/Debug/net8.0/%projectName%.IdentityServer.dll'; args = @(); cwd = '${workspaceFolder}/%projectName%.IdentityServer'; env = @{ ASPNETCORE_ENVIRONMENT = 'Development'; ASPNETCORE_URLS = 'https://localhost:5001' }; sourceFileMap = @{ '/Views' = '${workspaceFolder}/Views' } }, " ^
            "@{ name = '%projectName%.OrderApi'; type = 'coreclr'; request = 'launch'; preLaunchTask = 'build'; program = '${workspaceFolder}/%projectName%.OrderApi/bin/Debug/net8.0/%projectName%.OrderApi.dll'; args = @(); cwd = '${workspaceFolder}/%projectName%.OrderApi'; env = @{ ASPNETCORE_ENVIRONMENT = 'Development'; ASPNETCORE_URLS = 'https://localhost:7232' } }, " ^
            "@{ name = '%projectName%.MVC'; type = 'coreclr'; request = 'launch'; preLaunchTask = 'build'; program = '${workspaceFolder}/%projectName%.MVC/bin/Debug/net8.0/%projectName%.MVC.dll'; args = @(); cwd = '${workspaceFolder}/%projectName%.MVC'; env = @{ ASPNETCORE_ENVIRONMENT = 'Development'; ASPNETCORE_URLS = 'https://localhost:7234' }; serverReadyAction = @{ action = 'openExternally'; pattern = '\\bNow listening on:\\s+(https?://\\S+)' } } " ^
        "); " ^
        "compounds = @( " ^
            "@{ name = 'Launch All %projectName% Services'; configurations = @( '%projectName%.IdentityServer', '%projectName%.OrderApi', '%projectName%.MVC' ) } " ^
        ") " ^
    "}; " ^
    "$json = $vscodeConfig | ConvertTo-Json -Depth 5; " ^
    "Set-Content -Path '%targetPath%\\.vscode\\launch.json' -Value $json -Encoding UTF8;"

:: Create tasks.json for VS Code build task
powershell -ExecutionPolicy Bypass -Command ^
    "$tasksConfig = @{ " ^
        "version = '2.0.0'; " ^
        "tasks = @( " ^
            "@{ label = 'build'; command = 'dotnet'; type = 'process'; args = @('build'); options = @{ cwd = '${workspaceFolder}' }; group = @{ kind = 'build'; isDefault = $true }; presentation = @{ echo = $true; reveal = 'silent'; focus = $false; panel = 'shared'; showReuseMessage = $true; clear = $false }; problemMatcher = '$msCompile' } " ^
        ") " ^
    "}; " ^
    "$json = $tasksConfig | ConvertTo-Json -Depth 4; " ^
    "Set-Content -Path '%targetPath%\\.vscode\\tasks.json' -Value $json -Encoding UTF8;"

echo.
echo ✅ Transformation completed successfully!
echo.
echo 🎯 Next Steps:
echo    1. cd %targetPath%
echo    2. dotnet ef migrations add Initial --project %projectName%.MVC
echo    3. dotnet ef database update --project %projectName%.MVC
echo    4. dotnet build
echo    5. Press F5 in Visual Studio (multi-project startup configured!)
echo    6. Or run: dotnet run --project %projectName%.MVC
echo.
echo 🚀 Multi-project startup profiles configured:
echo    • Visual Studio: Open solution and press F5
echo    • VS Code: Run "Launch All %projectName% Services" compound
echo    • All services will start automatically with correct ports
echo.
echo 🌐 Then visit: https://localhost:7234
echo 📧 Login with: admin@%PROJECT_NAME_LOWER%.com / Admin123!
echo.
echo 📝 To customize for your specific scenario:
echo    • Update SeedData.cs with domain-specific data
echo    • Modify entity properties to match business requirements
echo    • Add validation rules and business logic
echo.
echo 🎉 Happy coding! Your transformed project is ready.
pause 

:toLowerCase
setlocal enabledelayedexpansion
set "str=!%~1!"
for %%a in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    set "str=!str:%%a=%%a!"
)
set "str=!str:A=a!"
set "str=!str:B=b!"
set "str=!str:C=c!"
set "str=!str:D=d!"
set "str=!str:E=e!"
set "str=!str:F=f!"
set "str=!str:G=g!"
set "str=!str:H=h!"
set "str=!str:I=i!"
set "str=!str:J=j!"
set "str=!str:K=k!"
set "str=!str:L=l!"
set "str=!str:M=m!"
set "str=!str:N=n!"
set "str=!str:O=o!"
set "str=!str:P=p!"
set "str=!str:Q=q!"
set "str=!str:R=r!"
set "str=!str:S=s!"
set "str=!str:T=t!"
set "str=!str:U=u!"
set "str=!str:V=v!"
set "str=!str:W=w!"
set "str=!str:X=x!"
set "str=!str:Y=y!"
set "str=!str:Z=z!"
endlocal & set "%~1=%str%"
goto :eof
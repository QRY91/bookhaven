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

echo.
echo ✅ Transformation completed successfully!
echo.
echo 🎯 Next Steps:
echo    1. cd %targetPath%
echo    2. dotnet ef migrations add Initial --project %projectName%.MVC
echo    3. dotnet ef database update --project %projectName%.MVC
echo    4. dotnet build
echo    5. dotnet run --project %projectName%.MVC
echo.
echo 📝 Don't forget to update the SeedData.cs with your scenario-specific data!
echo.
echo 🎉 Happy coding! Your transformed project is ready.
pause 
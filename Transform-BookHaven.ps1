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
    
    Write-Host ""
    Write-Host "✅ Transformation completed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎯 Next Steps:" -ForegroundColor Yellow
    Write-Host "   1. cd $TargetPath" -ForegroundColor Gray
    Write-Host "   2. dotnet ef migrations add Initial --project $projectName.MVC" -ForegroundColor Gray
    Write-Host "   3. dotnet ef database update --project $projectName.MVC" -ForegroundColor Gray
    Write-Host "   4. dotnet build" -ForegroundColor Gray
    Write-Host "   5. dotnet run --project $projectName.MVC" -ForegroundColor Gray
    Write-Host ""
    Write-Host "📝 Don't forget to update the SeedData.cs with your scenario-specific data!" -ForegroundColor Cyan
    
} catch {
    Write-Host ""
    Write-Host "❌ Transformation failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "💡 You may need to clean up the target directory and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "🎉 Happy coding! Your transformed project is ready." -ForegroundColor Green 
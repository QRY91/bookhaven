# 🚀 HACKATHON MODE: BookHaven → Any Exam Scenario

_"When you have 30 minutes to transform a bookstore into a hotel booking system"_

## 🎯 Core Strategy

BookHaven's architecture is **universally adaptable**:

- **Author** → Any "source/provider" entity
- **Book** → Any "main asset/product" entity
- **Category** → Any "classification" entity
- **Multi-project structure** works for any domain
- **Authentication & CRUD** patterns stay identical

## 📋 Universal Entity Mapping

### BookHaven Structure → Any Domain

```
Author (Provider/Source)     → Restaurant/Hotel/Instructor/Supplier/Venue
├── Name, Biography, Email   → Name, Description, ContactInfo
└── Books (One-to-Many)      → MenuItems/Rooms/Courses/Products/Events

Book (Main Asset)            → MenuItem/Room/Course/Product/Event
├── Title, Description       → Name, Description
├── Price, Stock            → Price, Quantity/Availability
├── AuthorId, CategoryId    → ProviderId, TypeId
└── Category, Author        → Type, Provider

Category (Classification)    → FoodType/RoomType/Level/ProductType/EventType
├── Name, Description       → Name, Description
└── Books                   → MenuItems/Rooms/Courses/Products/Events
```

## 🧙‍♂️ Transformation Wizards (RECOMMENDED!)

**For the fastest transformation, use our interactive wizards:**

### Option A: PowerShell Wizard (Windows)

```powershell
.\Transform-BookHaven.ps1
```

- Interactive prompts for all mappings
- Handles all file/folder renaming automatically
- Progress indicators and error handling
- Works in PowerShell, VS Code terminal, or Git Bash

### Option B: Batch File Wizard (Windows)

```batch
.\transform-bookhaven.bat
```

- Simpler batch file version
- Same interactive prompts
- Uses PowerShell internally for complex operations
- Works in Command Prompt

**Just run the wizard, answer the prompts, and you're done in 2 minutes!**

---

## ⚡ 15-Minute Manual Transformation Process

_(Use this if the wizards don't work or you want to understand the process)_

### Step 1: Project Renaming (2 minutes)

```powershell
# Copy the entire BookHaven solution
cp -r BookHaven PxlEats  # or whatever scenario name

# Rename solution and project files
mv PxlEats/BookHaven.sln PxlEats/PxlEats.sln
mv PxlEats/BookHaven.MVC PxlEats/PxlEats.MVC
mv PxlEats/BookHaven.Shared PxlEats/PxlEats.Shared
mv PxlEats/BookHaven.OrderApi PxlEats/PxlEats.OrderApi
mv PxlEats/BookHaven.IdentityServer PxlEats/PxlEats.IdentityServer
```

### Step 2: Namespace/Project References (3 minutes)

**Using the Transformation Wizard (Recommended):**

```powershell
# Interactive transformation - just answer the prompts!
.\Transform-BookHaven.ps1
```

**Manual Method (Linux/WSL):**

```bash
# Global find/replace in all files
find . -name "*.cs" -o -name "*.csproj" -o -name "*.sln" | \
  xargs sed -i 's/BookHaven/PxlEats/g'

# Update project references in .csproj files
find . -name "*.csproj" | \
  xargs sed -i 's/BookHaven\./PxlEats\./g'
```

**Manual Method (Windows):**

```batch
# Use the batch file version
.\transform-bookhaven.bat
```

### Step 3: Entity Model Transformation (5 minutes)

**Example: BookHaven → PxlEats (Restaurant)**

**File: `PxlEats.Shared/Models/Author.cs` → `Restaurant.cs`**

```csharp
// OLD: Author.cs
public class Author
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Biography { get; set; } = string.Empty;
    public DateTime BirthDate { get; set; }
    public string Email { get; set; } = string.Empty;
    public virtual ICollection<Book>? Books { get; set; }
}

// NEW: Restaurant.cs
public class Restaurant
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string City { get; set; } = string.Empty;
    public string Phone { get; set; } = string.Empty;
    public virtual ICollection<MenuItem>? MenuItems { get; set; }
}
```

**File: `PxlEats.Shared/Models/Book.cs` → `MenuItem.cs`**

```csharp
// OLD: Book.cs
public class Book
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string ISBN { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public int Stock { get; set; }
    public int AuthorId { get; set; }
    public virtual Author? Author { get; set; }
    public int CategoryId { get; set; }
    public virtual Category? Category { get; set; }
}

// NEW: MenuItem.cs
public class MenuItem
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Ingredients { get; set; } = string.Empty;
    public decimal Price { get; set; }
    public bool Available { get; set; } = true;
    public int RestaurantId { get; set; }
    public virtual Restaurant? Restaurant { get; set; }
    public int CategoryId { get; set; }
    public virtual Category? Category { get; set; }
}
```

**File: `PxlEats.Shared/Models/Category.cs`**

```csharp
// OLD: Category (books)
public virtual ICollection<Book>? Books { get; set; }

// NEW: Category (menu items)
public virtual ICollection<MenuItem>? MenuItems { get; set; }
```

### Step 4: DbContext Updates (2 minutes)

**File: `PxlEats.MVC/Data/ApplicationDbContext.cs`**

```csharp
// OLD
public DbSet<Author> Authors { get; set; }
public DbSet<Book> Books { get; set; }
public DbSet<Category> Categories { get; set; }

// NEW
public DbSet<Restaurant> Restaurants { get; set; }
public DbSet<MenuItem> MenuItems { get; set; }
public DbSet<Category> Categories { get; set; }
```

### Step 5: Controller Renaming (2 minutes)

```bash
# Rename controller files
mv Controllers/AuthorsController.cs Controllers/RestaurantsController.cs
mv Controllers/BooksController.cs Controllers/MenuItemsController.cs

# Update class names inside controllers
sed -i 's/AuthorsController/RestaurantsController/g' Controllers/RestaurantsController.cs
sed -i 's/BooksController/MenuItemsController/g' Controllers/MenuItemsController.cs
sed -i 's/Author/Restaurant/g' Controllers/RestaurantsController.cs
sed -i 's/Book/MenuItem/g' Controllers/MenuItemsController.cs
```

### Step 6: View Updates (1 minute)

```bash
# Rename view folders
mv Views/Authors Views/Restaurants
mv Views/Books Views/MenuItems

# Update view content with find/replace
find Views/ -name "*.cshtml" | \
  xargs sed -i -e 's/Author/Restaurant/g' -e 's/Book/MenuItem/g'
```

## 🎭 Scenario-Specific Quick Adaptations

### PxlEats (Restaurant) - Fast Track

```bash
# Entity mapping
Author → Restaurant
Book → MenuItem
Category → FoodType (Pizza, Burger, Salad, etc.)

# Key properties
Biography → Address
BirthDate → PhoneNumber
ISBN → Ingredients
Stock → Available (bool)
```

### PxlStay (Hotel) - Fast Track

```bash
# Entity mapping
Author → Hotel
Book → Room
Category → RoomType (Single, Double, Suite)

# Key properties
Biography → Address
Email → StarRating
ISBN → RoomNumber
Stock → MaxGuests
Price → PricePerNight
```

### PxlLearn (E-Learning) - Fast Track

```bash
# Entity mapping
Author → Instructor
Book → Course
Category → Level (Beginner, Intermediate, Advanced)

# Key properties
Biography → Expertise
BirthDate → YearsExperience
ISBN → Duration
Stock → MaxStudents
```

## 🔧 Advanced Hackathon Techniques

### Seed Data Speed Update

**File: `Data/SeedData.cs`**

```csharp
// Template for any scenario
var provider1 = new {Entity1} { Name = "...", /* scenario-specific fields */ };
var provider2 = new {Entity1} { Name = "...", /* scenario-specific fields */ };

var category1 = new Category { Name = "...", Description = "..." };
var category2 = new Category { Name = "...", Description = "..." };

var asset1 = new {Entity2} {
    Name = "...",
    {Entity1}Id = provider1.Id,
    CategoryId = category1.Id,
    Price = 99.99m
};
```

### Navigation Properties Mass Update

```bash
# Find all navigation property references
grep -r "Author\|Book" --include="*.cs" . | \
  sed 's/Author/Restaurant/g; s/Book/MenuItem/g'
```

### Route Updates for APIs

**File: `OrderApi/Controllers/*Controller.cs`**

```csharp
// OLD
[Route("api/[controller]")]
public class BooksController : ControllerBase

// NEW
[Route("api/[controller]")]
public class MenuItemsController : ControllerBase
```

## 📱 UI Text Quick Updates

### Layout Navigation

**File: `Views/Shared/_Layout.cshtml`**

```html
<!-- OLD -->
<a asp-controller="Authors">Authors</a>
<a asp-controller="Books">Books</a>

<!-- NEW -->
<a asp-controller="Restaurants">Restaurants</a>
<a asp-controller="MenuItems">Menu Items</a>
```

### Page Titles & Headers

```bash
# Mass update all display text
find Views/ -name "*.cshtml" | \
  xargs sed -i -e 's/Authors/Restaurants/g' -e 's/Books/Menu Items/g'
```

## 🚨 Exam Day Speed Tips

### 1. Pre-prepared Templates (5 scenarios ready)

```
BookHaven-PxlEats/     # Restaurant ready
BookHaven-PxlStay/     # Hotel ready
BookHaven-PxlLearn/    # E-Learning ready
BookHaven-PxlStock/    # Inventory ready
BookHaven-PxlEvents/   # Events ready
```

### 2. Mapping Cheat Sheet

```
Financial → Bank/Fund/Transaction
Library → Author/Book/Loan
Restaurant → Restaurant/MenuItem/Order
Hotel → Hotel/Room/Reservation
Learning → Instructor/Course/Enrollment
Inventory → Supplier/Product/Movement
Events → Venue/Event/Booking
```

### 3. Critical Files Priority

1. **Models** (Shared/Models/) - Core entities
2. **DbContext** - Database configuration
3. **Controllers** - CRUD operations
4. **SeedData** - Demo data
5. **Views** - UI (if time permits)

### 4. Speed Commands

```bash
# Ultra-fast rename (30 seconds)
find . -name "*.cs" | xargs sed -i 's/BookHaven/PxlEats/g; s/Author/Restaurant/g; s/Book/MenuItem/g'

# Quick test build
dotnet build --no-restore

# Fast migration
dotnet ef database drop --force
dotnet ef migrations add Initial
dotnet ef database update
```

## 🎯 Exam Success Patterns

### Entity Recognition (2 minutes max)

**Any exam domain follows this pattern:**

- **Primary Entity** (Company/Location/Provider) → Author equivalent
- **Asset Entity** (Product/Service/Resource) → Book equivalent
- **Classification** (Type/Category/Level) → Category equivalent

### Template Adaptation (10 minutes max)

1. **Copy BookHaven** (1 min)
2. **Rename projects** (2 min)
3. **Update entities** (4 min)
4. **Fix DbContext** (1 min)
5. **Update seeddata** (2 min)

### Verification (3 minutes max)

1. **Build succeeds** ✅
2. **Migration runs** ✅
3. **Seed data loads** ✅
4. **Basic CRUD works** ✅

## 🏆 Master Hackathon Mindset

### "Good Enough" Philosophy

- **Don't perfect everything** - Get it working first
- **Skip complex business logic** - Use simple CRUD
- **Copy working patterns** - Don't reinvent wheels
- **Focus on requirements** - Meet specs, not perfection

### Time Allocation (3-hour exam)

- **Analysis & Planning**: 15 minutes
- **Template Adaptation**: 20 minutes
- **Core Implementation**: 90 minutes
- **API & Blazor**: 45 minutes
- **Testing & Polish**: 30 minutes

### Emergency Fallbacks

- **Can't finish new models?** → Use BookHaven with original entities
- **Migration issues?** → Copy working database from BookHaven
- **Controller problems?** → Minimal controllers with basic CRUD
- **View issues?** → Simple list/create views only

---

**Remember**: The goal is **working software that meets requirements**, not perfect software. BookHaven gives you a bulletproof foundation - adapt it quickly and focus on the specific exam requirements! 🚀

**You're not starting from zero. You're customizing a working solution.** 💪

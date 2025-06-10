# 📋 EXAM TRANSFORMATION CHEAT SHEET

## 🚀 30-Second Entity Recognition

| Domain         | Entity 1 (Author→) | Entity 2 (Book→) | Entity 3 (Category→) |
| -------------- | ------------------ | ---------------- | -------------------- |
| **Restaurant** | Restaurant         | MenuItem         | FoodType             |
| **Hotel**      | Hotel              | Room             | RoomType             |
| **Library**    | Author             | Book             | Genre                |
| **E-Learning** | Instructor         | Course           | Level                |
| **Inventory**  | Supplier           | Product          | ProductType          |
| **Events**     | Venue              | Event            | EventType            |
| **Banking**    | Bank               | Fund             | FundType             |
| **Medical**    | Doctor             | Appointment      | Specialty            |
| **Rental**     | Owner              | Property         | PropertyType         |

## 🧙‍♂️ FASTEST: Use the Transformation Wizard

```powershell
# PowerShell version (recommended)
.\Transform-BookHaven.ps1

# Batch file version (alternative)
.\transform-bookhaven.bat
```

**Just answer the prompts - done in 2 minutes!**

---

## ⚡ Manual Commands (if needed)

### Linux/WSL

```bash
# Step 1: Copy project
cp -r BookHaven NewProjectName

# Step 2: Global rename (choose your scenario)
cd NewProjectName

# Restaurant scenario
find . -name "*.cs" -o -name "*.csproj" -o -name "*.sln" | \
  xargs sed -i 's/BookHaven/PxlEats/g; s/Author/Restaurant/g; s/Book/MenuItem/g'

# Hotel scenario
find . -name "*.cs" -o -name "*.csproj" -o -name "*.sln" | \
  xargs sed -i 's/BookHaven/PxlStay/g; s/Author/Hotel/g; s/Book/Room/g'
```

### Windows PowerShell

```powershell
# Step 1: Copy project
Copy-Item -Path BookHaven -Destination NewProjectName -Recurse

# Step 2: Global rename (restaurant example)
cd NewProjectName
Get-ChildItem -Recurse -Include "*.cs", "*.csproj", "*.sln" |
  ForEach-Object {
    (Get-Content $_.FullName -Raw) -replace "BookHaven", "PxlEats" -replace "\bAuthor\b", "Restaurant" -replace "\bBook\b", "MenuItem" |
    Set-Content $_.FullName -NoNewline
  }
```

## 🔧 Property Mapping Quick Reference

### Restaurant (PxlEats)

```
Author.Name → Restaurant.Name
Author.Biography → Restaurant.Address
Author.Email → Restaurant.Phone
Book.Title → MenuItem.Name
Book.ISBN → MenuItem.Ingredients
Book.Stock → MenuItem.Available (bool)
```

### Hotel (PxlStay)

```
Author.Name → Hotel.Name
Author.Biography → Hotel.Address
Author.Email → Hotel.StarRating
Book.Title → Room.RoomNumber
Book.ISBN → Room.RoomType
Book.Stock → Room.MaxGuests
```

### E-Learning (PxlLearn)

```
Author.Name → Instructor.Name
Author.Biography → Instructor.Expertise
Author.BirthDate → Instructor.Experience
Book.Title → Course.Title
Book.ISBN → Course.Duration
Book.Stock → Course.MaxStudents
```

## 📝 Critical Files Checklist

### 1. Models (5 minutes)

- [ ] `Shared/Models/Author.cs` → `{Entity1}.cs`
- [ ] `Shared/Models/Book.cs` → `{Entity2}.cs`
- [ ] `Shared/Models/Category.cs` → Update navigation properties
- [ ] Update all navigation properties in models

### 2. DbContext (2 minutes)

- [ ] `MVC/Data/ApplicationDbContext.cs` → Update DbSet properties
- [ ] Remove old migrations folder
- [ ] Create new migration: `dotnet ef migrations add Initial`

### 3. Controllers (3 minutes)

- [ ] Rename `AuthorsController.cs` → `{Entity1}Controller.cs`
- [ ] Rename `BooksController.cs` → `{Entity2}Controller.cs`
- [ ] Update class names and entity references inside controllers

### 4. Views (2 minutes)

- [ ] Rename `Views/Authors/` → `Views/{Entity1}/`
- [ ] Rename `Views/Books/` → `Views/{Entity2}/`
- [ ] Update `_Layout.cshtml` navigation links
- [ ] Update page titles and headers

### 5. SeedData (3 minutes)

- [ ] `MVC/Data/SeedData.cs` → Update with scenario-specific data
- [ ] Create 2-3 Entity1 records
- [ ] Create 3-5 categories
- [ ] Create 5+ Entity2 records with relationships

## 🎯 Speed Seed Data Templates

### Restaurant Template

```csharp
var restaurant1 = new Restaurant { Name = "Downtown Grill", Address = "123 Main St", Phone = "555-0101" };
var restaurant2 = new Restaurant { Name = "Campus Cafe", Address = "456 College Ave", Phone = "555-0102" };

var category1 = new Category { Name = "Pizza", Description = "Italian cuisine" };
var category2 = new Category { Name = "Burgers", Description = "American classics" };

var item1 = new MenuItem { Name = "Margherita Pizza", RestaurantId = 1, CategoryId = 1, Price = 12.99m };
var item2 = new MenuItem { Name = "Cheeseburger", RestaurantId = 2, CategoryId = 2, Price = 9.99m };
```

### Hotel Template

```csharp
var hotel1 = new Hotel { Name = "City Center Hotel", Address = "789 Downtown Blvd", StarRating = 4 };
var hotel2 = new Hotel { Name = "Airport Inn", Address = "321 Airport Rd", StarRating = 3 };

var type1 = new Category { Name = "Single", Description = "One bed" };
var type2 = new Category { Name = "Double", Description = "Two beds" };

var room1 = new Room { RoomNumber = "101", HotelId = 1, CategoryId = 1, PricePerNight = 89.99m };
var room2 = new Room { RoomNumber = "201", HotelId = 2, CategoryId = 2, PricePerNight = 109.99m };
```

## 🚨 Emergency Commands

### Build & Test (30 seconds)

```bash
dotnet clean
dotnet build --no-restore
dotnet ef database drop --force
dotnet ef database update
dotnet run
```

### If Migrations Fail

```bash
rm -rf Migrations/
dotnet ef migrations add Initial
dotnet ef database update
```

### If Build Fails

```bash
# Check for missed renames
grep -r "Author\|Book" --include="*.cs" . | head -10
# Fix manually or repeat mass rename
```

## 📊 Time Budget (3-hour exam)

| Phase           | Time   | Tasks                                       |
| --------------- | ------ | ------------------------------------------- |
| **Setup**       | 15 min | Copy project, mass rename, initial build    |
| **Models**      | 20 min | Entity properties, relationships, DbContext |
| **Data**        | 15 min | SeedData, migrations, database setup        |
| **Controllers** | 30 min | Rename, update CRUD operations              |
| **Views**       | 20 min | Rename folders, update content              |
| **API**         | 30 min | Update endpoints, test functionality        |
| **Blazor**      | 45 min | Components, if required                     |
| **Polish**      | 25 min | Testing, fixes, final checks                |

## 🏆 Success Indicators

- [ ] **Project builds without errors**
- [ ] **Database migration succeeds**
- [ ] **Seed data loads correctly**
- [ ] **Basic CRUD operations work**
- [ ] **Navigation links function**
- [ ] **Entity relationships display properly**

---

**Print this sheet and keep it handy during the exam!** 📋

**Remember: Working software > Perfect software** 🎯

# 🚀 BookHaven Multi-Project Setup Guide (Windows)

## 📋 **What We've Accomplished**

✅ **Enhanced Launch Settings** - Multiple startup profiles for different scenarios  
✅ **Shared Models** - Complete data models in BookHaven.Shared  
✅ **MVC Controllers** - Books, Authors, Categories controllers with full CRUD  
✅ **Modern Views** - Responsive Bootstrap UI with search/filtering  
✅ **Navigation** - Updated layout with dropdown menus  
✅ **Entity Framework** - DbContext with seed data and relationships  

---

## 🔧 **Windows Setup Instructions**

### **1. Prerequisites Check**
```powershell
# Verify .NET 8 SDK
dotnet --version
# Should show 8.0.x

# Verify SQL Server (LocalDB)
sqllocaldb info
# Should list available instances
```

### **2. Database Setup**
```powershell
# Navigate to MVC project
cd "exam-prep\mock_exam\BookHaven_MultiProject_Example\BookHaven.MVC"

# Install EF Tools (if not already installed)
dotnet tool install --global dotnet-ef

# Create and apply migration
dotnet ef migrations add InitialCreate
dotnet ef database update
```

### **3. Launch Application**

**Option A: Visual Studio (Recommended)**
1. Open `BookHaven.sln` in Visual Studio
2. Select startup profile from dropdown:
   - **"All Services (Production-like)"** for normal development
   - **"Development Mode (All Debug)"** for full debugging
3. Press `F5`

**Option B: Command Line**
```powershell
# Start all services manually
cd BookHaven.IdentityServer && start dotnet run --launch-profile https
cd ..\BookHaven.OrderApi && start dotnet run --launch-profile https  
cd ..\BookHaven.MVC && dotnet run --launch-profile https
```

### **4. Verify URLs**
- 🌐 **MVC App**: `https://localhost:5001` (main application)
- 🔧 **API Swagger**: `https://localhost:7001/swagger` (API documentation)
- 🔐 **Identity Server**: `https://localhost:6001` (auth service)

---

## 🧪 **Testing the Functionality**

### **1. Basic Navigation Test**
- ✅ Homepage loads with hero section and feature cards
- ✅ Navigation dropdown works (Catalog → Books/Authors/Categories)
- ✅ Bootstrap icons display correctly

### **2. Books Management Test**
- ✅ Browse to `/Books` - should show seeded books
- ✅ Search and filter functionality works
- ✅ Create new book (requires login)
- ✅ Edit/Delete existing books
- ✅ View book details

### **3. Authors & Categories Test**
- ✅ `/Authors` shows author list with book counts
- ✅ `/Categories` shows category cards
- ✅ CRUD operations work for both

### **4. Database Verification**
```sql
-- Connect to (localdb)\mssqllocaldb
-- Database: BookHavenMVC

SELECT COUNT(*) FROM Books;      -- Should show 5 books
SELECT COUNT(*) FROM Authors;    -- Should show 5 authors  
SELECT COUNT(*) FROM Categories; -- Should show 5 categories
```

---

## 🐛 **Troubleshooting**

### **Database Issues**
```powershell
# Reset database
dotnet ef database drop
dotnet ef database update
```

### **Launch Profile Issues**
- Delete `.vs` folder and restart Visual Studio
- Check ports aren't blocked by firewall
- Verify appsettings.json connection string

### **Package Issues**
```powershell
# Restore packages
dotnet restore
# Clean and rebuild
dotnet clean && dotnet build
```

---

## 📚 **Architecture Overview**

```
BookHaven_MultiProject_Example/
├── BookHaven.sln                 # Solution file
├── BookHaven.slnLaunch           # Multi-startup configuration
├── BookHaven.Shared/             # 📦 Shared Models & Data
│   ├── Models/                   #    Book, Author, Category, etc.
│   └── BookHaven.Shared.csproj   #    Class library
├── BookHaven.MVC/                # 🌐 Web Application  
│   ├── Controllers/              #    Books, Authors, Categories
│   ├── Views/                    #    Responsive Bootstrap UI
│   ├── Data/                     #    BookHavenDbContext
│   └── Properties/launchSettings.json
├── BookHaven.OrderApi/           # 🔧 API Service
│   └── Properties/launchSettings.json
└── BookHaven.IdentityServer/     # 🔐 Authentication
    └── Properties/launchSettings.json
```

---

## ✅ **Quick Verification Checklist**

**After setup, verify:**
- [ ] All 3 services start without errors
- [ ] Homepage displays correctly with modern UI
- [ ] Books page shows 5 seeded books
- [ ] Search/filter functionality works
- [ ] Can create/edit books (after login)
- [ ] Authors page shows 5 authors
- [ ] Categories page shows 5 categories in card layout
- [ ] Navigation dropdown works
- [ ] Bootstrap icons display

**Database should contain:**
- [ ] 5 Books (Harry Potter, The Shining, Good Omens, Foundation, Murder on Orient Express)
- [ ] 5 Authors (J.K. Rowling, Stephen King, Neil Gaiman, Isaac Asimov, Agatha Christie)  
- [ ] 5 Categories (Fiction, Non-Fiction, Science, History, Biography)

---

## 🎯 **Exam Prep Notes**

**Key Concepts Demonstrated:**
- ✅ **Multi-project architecture** with shared models
- ✅ **Entity Framework** with migrations and seed data
- ✅ **MVC pattern** with controllers and views
- ✅ **Bootstrap responsive design**
- ✅ **CRUD operations** with validation
- ✅ **Search and filtering** functionality
- ✅ **Launch configurations** for different scenarios

**Perfect for practicing:**
- Controller creation and routing
- View development with Razor syntax
- Entity Framework operations
- Multi-project references
- Launch settings configuration

---

## 💡 **Next Steps for Enhancement**

Once basic functionality is verified:
1. **Add Authentication** - Integrate with IdentityServer
2. **API Integration** - Use OrderApi for order management  
3. **Image Upload** - Implement book cover uploads
4. **Advanced Search** - Add sorting and pagination
5. **Shopping Cart** - Add order management functionality

Your multiproject BookHaven is now fully functional! 🎉 
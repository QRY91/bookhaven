# 🚀 BookHaven Quick Start Guide

## 📋 **Prerequisites**

- ✅ **Visual Studio 2022** (Community, Professional, or Enterprise)
- ✅ **.NET 8 SDK** (verify with `dotnet --version`)
- ✅ **SQL Server LocalDB** (included with Visual Studio)

## 🎯 **Quick Start (3 Steps)**

### **Step 1: Clone & Open**

```bash
git clone [your-repo-url]
cd BookHaven_MultiProject_Example
```

- **Open `BookHaven.sln` in Visual Studio**

### **Step 2: Set Startup Configuration**

- **In Visual Studio toolbar**, select startup configuration:
  - **"All Services (Production-like)"** ← **Recommended for normal use**
  - **"Development Mode (All Debug)"** ← For full debugging

### **Step 3: Press F5**

- Visual Studio will start **all 3 services automatically**:
  - 🌐 **MVC App**: `https://localhost:7234` (main application)
  - 🔧 **API**: `https://localhost:7001/swagger` (API docs)
  - 🔐 **Identity**: `https://localhost:6001` (auth service)

## 🌐 **What You'll See**

### **Homepage** (`https://localhost:7234`)

- Modern BookHaven homepage with feature cards
- Navigation to Books, Authors, Categories

### **Pre-loaded Data**

- **5 Books**: Harry Potter, The Shining, Good Omens, Foundation, Murder on Orient Express
- **5 Authors**: J.K. Rowling, Stephen King, Neil Gaiman, Isaac Asimov, Agatha Christie
- **5 Categories**: Fiction, Non-Fiction, Science, History, Biography

### **Key Features to Test**

- ✅ **Books page** - Browse, search, filter, CRUD operations
- ✅ **Authors page** - Author management with book counts
- ✅ **Categories page** - Category cards with book counts
- ✅ **Responsive design** - Works on desktop and mobile

## 🔧 **If Something Goes Wrong**

### **Database Issues**

```bash
cd BookHaven.MVC
dotnet ef database drop
dotnet ef database update
```

### **Port Conflicts**

- The app uses ports **7234/17234** (MVC), **6001** (Identity), **7001** (API)
- If conflicts occur, update `launchSettings.json` ports

### **Clean Build**

```bash
dotnet clean
dotnet build
```

## 📚 **Architecture Overview**

- **BookHaven.MVC**: Main web application (Bootstrap UI)
- **BookHaven.IdentityServer**: Authentication service (Duende IdentityServer)
- **BookHaven.OrderApi**: REST API for order management
- **BookHaven.Shared**: Shared models and data access

---

**That's it! Your multi-project BookHaven application should be running and fully functional!** 🎉

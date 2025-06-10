# 📚 BookHaven - Multi-Project Bookstore Application

A modern **C# .NET 8** multi-project solution demonstrating microservices architecture, authentication, and CRUD operations for a bookstore management system.

## 🏗️ Architecture Overview

This solution consists of **4 projects** working together:

| Project                      | Purpose                | Port | Technology                     |
| ---------------------------- | ---------------------- | ---- | ------------------------------ |
| **BookHaven.MVC**            | Main web application   | 7234 | ASP.NET Core MVC, Bootstrap    |
| **BookHaven.IdentityServer** | Authentication service | 6001 | Duende IdentityServer          |
| **BookHaven.OrderApi**       | Order/inventory API    | 7001 | ASP.NET Core Web API, Swagger  |
| **BookHaven.Shared**         | Shared library         | -    | Class library with models/DTOs |

## 🚀 Quick Start

### Prerequisites

- **Visual Studio 2022** (any edition)
- **.NET 8 SDK**
- **SQL Server LocalDB** (included with Visual Studio)

### Getting Started (3 Steps)

1. **Clone and Open**

   ```bash
   git clone [your-repo-url]
   cd bookhaven
   # Open BookHaven.sln in Visual Studio
   ```

2. **Configure Startup**

   - In Visual Studio toolbar, select: **"All Services (Production-like)"**
   - Or use **"Development Mode (All Debug)"** for full debugging

3. **Run**
   - Press **F5**
   - All services start automatically with proper dependencies

## 🌐 Application URLs

After startup, you'll have access to:

- **📱 Main App**: https://localhost:7234 (BookHaven web interface)
- **🔧 API Docs**: https://localhost:7001/swagger (Order API documentation)
- **🔐 Auth Service**: https://localhost:6001 (Identity Server - background)

## 👤 Default Accounts

The application comes with pre-seeded accounts:

| Role      | Username | Email                 | Password    |
| --------- | -------- | --------------------- | ----------- |
| **Admin** | `admin`  | `admin@bookhaven.com` | `Admin123!` |

> **Note**: You can register new user accounts through the application's register page.

## 📖 Features

### Core Functionality

- ✅ **Books Management** - Full CRUD operations with categories and authors
- ✅ **Authors Management** - Author profiles with book relationships
- ✅ **Categories Management** - Book categorization system
- ✅ **User Authentication** - Login/register with role-based access
- ✅ **Admin Panel** - Administrative functions for managing content
- ✅ **Responsive Design** - Bootstrap-based UI that works on all devices

### Pre-loaded Sample Data

- **5 Books**: Harry Potter, The Shining, Good Omens, Foundation, Murder on Orient Express
- **5 Authors**: J.K. Rowling, Stephen King, Neil Gaiman, Isaac Asimov, Agatha Christie
- **5 Categories**: Fiction, Non-Fiction, Science, History, Biography
- **Admin Account**: Automatically created for management access

## 🛠️ Development

### Launch Configurations

The solution includes multiple startup scenarios:

| Configuration                      | Use Case             | Services                                |
| ---------------------------------- | -------------------- | --------------------------------------- |
| **All Services (Production-like)** | Normal development   | Identity + API (no debug) + MVC (debug) |
| **Development Mode (All Debug)**   | Full debugging       | All services with debugging             |
| **API Testing**                    | Backend development  | Identity + API only                     |
| **MVC Only**                       | Frontend development | MVC only                                |

### Project Structure

```
BookHaven/
├── BookHaven.MVC/              # Main web application
│   ├── Controllers/            # MVC controllers
│   ├── Views/                  # Razor views
│   ├── Areas/Identity/         # Authentication pages
│   └── Data/                   # Entity Framework context
├── BookHaven.IdentityServer/   # Authentication service
├── BookHaven.OrderApi/         # REST API for orders
│   ├── Controllers/            # API controllers
│   └── Services/               # Business logic
├── BookHaven.Shared/           # Shared library
│   ├── Models/                 # Domain entities
│   └── DTOs/                   # Data transfer objects
└── BookHaven.sln              # Solution file
```

### Key Technologies

- **.NET 8** - Latest framework version
- **Entity Framework Core** - ORM with SQL Server LocalDB
- **ASP.NET Core Identity** - User authentication and authorization
- **Duende IdentityServer** - OAuth2/OpenID Connect server
- **Bootstrap 5** - Responsive UI framework
- **Swagger/OpenAPI** - API documentation

## 🔧 Troubleshooting

### Database Issues

```bash
cd BookHaven.MVC
dotnet ef database drop
dotnet ef database update
```

### Port Conflicts

- MVC: 7234/17234
- Identity: 6001
- API: 7001

Update `launchSettings.json` if ports are in use.

### Clean Build

```bash
dotnet clean
dotnet build
```

## 📝 Development Notes

### Adding New Features

1. **Models**: Add to `BookHaven.Shared/Models/`
2. **API Endpoints**: Add to `BookHaven.OrderApi/Controllers/`
3. **Web Pages**: Add to `BookHaven.MVC/Controllers/` and `Views/`

### Database Changes

```bash
cd BookHaven.MVC
dotnet ef migrations add YourMigrationName
dotnet ef database update
```

### Authentication

- Uses ASP.NET Core Identity with minimal configuration
- Pre-configured for basic login/logout/register flows
- Admin role provides access to management features

## 🎯 Demo Scenarios

### For Presentations

1. **Browse Books** - Show catalog with search and filtering
2. **CRUD Operations** - Demonstrate create/edit/delete for books/authors
3. **Authentication** - Login as admin, show role-based features
4. **API Integration** - Show Swagger docs and API endpoints
5. **Multi-Project** - Demonstrate all services running together

## 🔌 Offline Exam Preparation

For environments without internet access (perfect for exams):

### One-time Setup (Before Exam)

```powershell
# Download all required packages and configure automatically
.\download-packages.ps1
# When prompted, press 'Y' to set up NuGet source automatically!
```

### During Exam

```powershell
# Install packages from local repository
Install-Package Microsoft.EntityFrameworkCore -Version 8.0.16 -Source LocalExamPackages
# See EXAM_CHEAT_SHEET.md for complete package list
```

**Files:**

- `download-packages.ps1` - PowerShell script to download packages
- `download-packages.sh` - Bash script for cross-platform compatibility
- `EXAM_OFFLINE_SETUP.md` - Detailed setup instructions
- `EXAM_CHEAT_SHEET.md` - Quick reference for exam day

## 📚 Learning Resources

- **MEATBAG_MANUAL.md** - Comprehensive implementation guide with architecture patterns and educational insights
- **EXAM_OFFLINE_SETUP.md** - Complete offline package setup for exam environments (no internet required)
- **EXAM_CHEAT_SHEET.md** - Quick reference guide with essential commands and templates
- **Project Structure** - Multi-project solution demonstrating enterprise patterns
- **Authentication Integration** - Real-world Identity setup with proper configuration
- **Rich Sample Data** - Realistic seed data for meaningful demonstrations

---

**🎉 That's it! You now have a fully functional multi-project bookstore application ready for development, demonstration, and offline exam scenarios.**

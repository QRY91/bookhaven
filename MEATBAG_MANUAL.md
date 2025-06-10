# 🤖 MEATBAG MANUAL: Multi-Project MVC Implementation Guide

_"Because even meatbags can build enterprise-grade applications when they follow a recipe"_

## 🎯 Purpose

This is your **stress-tested roadmap** for building multi-project MVC applications from scratch. Perfect for exams, interviews, or when your brain has turned to mush and you need clear waypoints.

---

## 🏗️ Architecture Overview

### The Big Picture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   MVC Frontend  │───▶│  Identity Server │    │   API Backend   │
│  (User Interface)│    │  (Authentication)│    │ (Business Logic)│
└─────────────────┘    └─────────────────┘    └─────────────────┘
           │                                              │
           └──────────────────┬───────────────────────────┘
                              │
                    ┌─────────────────┐
                    │ Shared Library  │
                    │ (Common Models) │
                    └─────────────────┘
```

### Project Responsibilities

- **MVC Project**: User interface, views, controllers, main business logic
- **Identity Server**: Centralized authentication, user management
- **API Project**: RESTful services, external integrations, admin functions
- **Shared Library**: Domain models, DTOs, shared utilities

---

## 📋 Implementation Recipe

### Phase 1: Foundation Setup

#### Step 1: Create Solution Structure

```bash
# Create solution and projects
dotnet new sln -n YourAppName
dotnet new mvc -n YourApp.MVC
dotnet new webapi -n YourApp.Api
dotnet new web -n YourApp.IdentityServer
dotnet new classlib -n YourApp.Shared

# Add projects to solution
dotnet sln add **/*.csproj
```

#### Step 2: Configure Project Dependencies

- **MVC** → references **Shared**
- **API** → references **Shared**
- **IdentityServer** → standalone (minimal dependencies)
- Set **MVC** dependencies on **IdentityServer** and **API** in solution

#### Step 3: Install Essential Packages

**MVC Project:**

```xml
<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" />
<PackageReference Include="Microsoft.AspNetCore.Identity.EntityFrameworkCore" />
<PackageReference Include="Microsoft.AspNetCore.Identity.UI" />
<PackageReference Include="Microsoft.EntityFrameworkCore.Tools" />
<PackageReference Include="Microsoft.VisualStudio.Web.CodeGeneration.Design" />
```

**API Project:**

```xml
<PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" />
<PackageReference Include="Swashbuckle.AspNetCore" />
```

**IdentityServer Project:**

```xml
<PackageReference Include="Duende.IdentityServer" />
<PackageReference Include="Microsoft.AspNetCore.Identity.EntityFrameworkCore" />
```

### Phase 2: Domain Modeling

#### Step 4: Design Your Domain Models

**In Shared Library:**

```csharp
// Core entities with relationships
public class YourMainEntity
{
    public int Id { get; set; }
    public string Name { get; set; }
    // Navigation properties
    public virtual ICollection<RelatedEntity> RelatedItems { get; set; }
}
```

#### Step 5: Create Data Transfer Objects (DTOs)

```csharp
// For API communication
public class YourEntityDto
{
    // Simplified properties for data transfer
}
```

#### Step 6: Extend Identity User (if needed)

```csharp
public class ApplicationUser : IdentityUser
{
    public string FirstName { get; set; }
    public string LastName { get; set; }
    // Additional user properties
}
```

### Phase 3: Data Layer

#### Step 7: Configure DbContext

**In MVC Project:**

```csharp
public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public DbSet<YourEntity> YourEntities { get; set; }
    // Configure relationships in OnModelCreating
}
```

#### Step 8: Create and Run Migrations

```bash
cd YourApp.MVC
dotnet ef migrations add InitialCreate
dotnet ef database update
```

#### Step 9: Implement Data Seeding

```csharp
public static class SeedData
{
    public static async Task Initialize(IServiceProvider serviceProvider)
    {
        // Seed roles, users, and sample data
    }
}
```

### Phase 4: Authentication Setup

#### Step 10: Configure Identity in MVC

```csharp
// Program.cs
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options => {
    // Configure password, lockout, user settings
    options.User.AllowedUserNameCharacters = "..@+"; // Allow email as username
}).AddEntityFrameworkStores<ApplicationDbContext>();
```

#### Step 11: Scaffold Authentication Pages

```bash
dotnet aspnet-codegenerator identity -dc YourApp.Data.ApplicationDbContext --files "Account.Login;Account.Register;Account.Logout"
```

#### Step 12: Setup Identity Server (Optional)

- Configure clients, scopes, and identity resources
- Implement token-based authentication between services

### Phase 5: MVC Implementation

#### Step 13: Create Controllers and Actions

```csharp
public class YourEntityController : Controller
{
    private readonly ApplicationDbContext _context;

    // Index, Details, Create, Edit, Delete actions
    // Include [Authorize] attributes where needed
}
```

#### Step 14: Build Views with Scaffolding

```bash
dotnet aspnet-codegenerator controller -name YourEntityController -m YourEntity -dc ApplicationDbContext --relativeFolderPath Controllers --useDefaultLayout --referenceScriptLibraries
```

#### Step 15: Implement Navigation and Layout

- Update `_Layout.cshtml` with navigation
- Configure `_LoginPartial.cshtml` for authentication UI
- Add role-based menu items

### Phase 6: API Implementation

#### Step 16: Create API Controllers

```csharp
[ApiController]
[Route("api/[controller]")]
public class YourEntityApiController : ControllerBase
{
    // GET, POST, PUT, DELETE endpoints
    // Return DTOs, not domain models
}
```

#### Step 17: Configure Swagger

```csharp
// Program.cs
builder.Services.AddSwaggerGen();
// Configure Swagger UI in pipeline
```

#### Step 18: Implement Cross-Service Communication

- HTTP clients for service-to-service calls
- Shared DTOs for data contracts

### Phase 7: Integration and Polish

#### Step 19: Configure Multi-Project Startup

**Create `.slnLaunch` file:**

```json
[
  {
    "Name": "All Services",
    "Projects": [
      {
        "Path": "YourApp.IdentityServer\\YourApp.IdentityServer.csproj",
        "Action": "StartWithoutDebugging"
      },
      {
        "Path": "YourApp.Api\\YourApp.Api.csproj",
        "Action": "StartWithoutDebugging"
      },
      { "Path": "YourApp.MVC\\YourApp.MVC.csproj", "Action": "Start" }
    ]
  }
]
```

#### Step 20: Implement Error Handling and Validation

- Model validation attributes
- Custom error pages
- API error responses

#### Step 21: Add Authorization and Security

```csharp
[Authorize(Roles = "Admin")]
public class AdminController : Controller { }

// Configure authorization policies
services.AddAuthorization(options => {
    options.AddPolicy("AdminOnly", policy => policy.RequireRole("Admin"));
});
```

---

## 🧠 Key Concepts to Remember

### Domain-Driven Design

- **Entities**: Objects with identity (ID property)
- **Value Objects**: Objects defined by their attributes
- **Aggregates**: Cluster of entities treated as a unit
- **Repositories**: Abstraction for data access

### MVC Pattern

- **Models**: Data and business logic
- **Views**: User interface presentation
- **Controllers**: Handle user input and coordinate between models and views

### Separation of Concerns

- **Presentation Layer** (MVC): UI logic
- **Business Layer** (Services): Business rules
- **Data Layer** (Repository/DbContext): Data access
- **Cross-Cutting** (Shared): Common functionality

### RESTful API Design

- **GET** `/api/entities` - List all
- **GET** `/api/entities/{id}` - Get specific
- **POST** `/api/entities` - Create new
- **PUT** `/api/entities/{id}` - Update existing
- **DELETE** `/api/entities/{id}` - Remove

---

## ⚠️ Common Pitfalls (Learn from Our Pain)

### Authentication Nightmares

- ❌ **Don't** mix `AddDefaultIdentity` and `AddIdentity`
- ✅ **Do** use email as username for scaffolded pages
- ✅ **Do** set `options.SignIn.RequireConfirmedAccount = false` for demos

### Database Drama

- ❌ **Don't** forget to add DbSets to your context
- ❌ **Don't** ignore migration warnings about decimal precision
- ✅ **Do** seed data in a separate method with existence checks

### Project Reference Headaches

- ❌ **Don't** create circular dependencies
- ✅ **Do** follow the dependency hierarchy: MVC/API → Shared
- ✅ **Do** use DTOs for cross-service communication

### Configuration Confusion

- ❌ **Don't** hardcode connection strings in multiple places
- ✅ **Do** use consistent port configurations across services
- ✅ **Do** document your launch configurations

---

## 🎯 Exam Day Checklist

### Before You Start

- [ ] Read requirements thoroughly
- [ ] Identify your domain entities and relationships
- [ ] Plan your project structure
- [ ] Decide on authentication strategy

### Implementation Order

- [ ] Create solution and project structure
- [ ] Install NuGet packages
- [ ] Create domain models in Shared library
- [ ] Setup DbContext and migrations
- [ ] Configure authentication
- [ ] Scaffold controllers and views
- [ ] Implement seed data
- [ ] Test basic CRUD operations
- [ ] Add API endpoints if required
- [ ] Configure multi-project startup
- [ ] Test end-to-end functionality

### Final Polish

- [ ] Add proper navigation
- [ ] Implement authorization where needed
- [ ] Test authentication flow
- [ ] Verify all services start correctly
- [ ] Clean up any compiler warnings
- [ ] Write basic documentation

---

## 🚀 Success Metrics

You know you've nailed it when:

- ✅ All services start with F5
- ✅ Login/logout works correctly
- ✅ CRUD operations function properly
- ✅ API endpoints return expected data
- ✅ Navigation reflects user roles
- ✅ Sample data displays correctly
- ✅ No red squiggly lines (compiler errors)

---

**Remember**: This isn't about memorizing every line of code. It's about understanding the **patterns**, **sequence**, and **relationships** between components. Follow this recipe, adapt it to your scenario, and you'll have a solid multi-project application that demonstrates enterprise-level architecture.

_Now go forth and architect, you magnificent meatbag! 🤖_

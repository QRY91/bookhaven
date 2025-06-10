# 🏗️ WALKTHROUGH 01: Multi-Project Architecture & Interconnections

## 🎯 **Exam Focus**: Understanding the "Big Picture" in 15 minutes

### **The 4-Project Symphony**

```
BookHaven Solution
├── 🌐 BookHaven.MVC          # Main web app (WHERE USERS INTERACT)
│   ├── Controllers/          # → Business logic & HTTP handling
│   ├── Views/               # → User interface (Razor)
│   ├── Data/                # → DbContext + Seed data
│   └── Areas/Identity/      # → Login/Register pages
│
├── 🔐 BookHaven.IdentityServer # Auth service (WHERE TOKENS LIVE)
│   └── Program.cs           # → Minimal setup for JWT tokens
│
├── 📚 BookHaven.Shared        # Domain models (WHERE TRUTH LIVES)
│   ├── Models/              # → Book, Author, Category, Order
│   └── DTOs/                # → Data transfer objects
│
└── 🛒 BookHaven.OrderApi     # REST API (WHERE ORDERS HAPPEN)
    ├── Controllers/         # → API endpoints
    ├── Services/            # → Business logic
    └── Data/                # → Order-specific data access
```

---

## 🔄 **How They Talk to Each Other**

### **1. Startup Orchestration** (F5 Magic)

- **All 3 services launch together** via `BookHaven.slnLaunch`
- **Ports**: Identity(5001), API(7232), MVC(7234)
- **MVC is the "front door"** - users only see this

### **2. Shared Models Flow**

```
BookHaven.Shared → BookHaven.MVC     (Domain models)
BookHaven.Shared → BookHaven.OrderApi (Same models)
```

**Why this matters**: Change `Book.cs` once, both projects use it!

### **3. Authentication Chain**

```
User → MVC → IdentityServer → JWT Token → Back to MVC
```

**Current Reality**: Identity is set up but **NOT FULLY USED YET**

### **4. API Integration Potential**

```
MVC Controllers → HttpClient → OrderApi → Database
```

**Current Reality**: OrderApi exists but **MVC DOESN'T CALL IT YET**

---

## ⚡ **Speed Reconstruction Strategy**

### **Phase 1: Core Foundation (30 mins)**

1. Create solution with 2-3 projects (skip API initially)
2. Set up shared models (Book, Author, Category)
3. Configure DbContext with relationships

### **Phase 2: MVC Functionality (90 mins)**

1. Scaffold controllers for CRUD operations
2. Implement search/filtering on Books
3. Add authentication (Identity)

### **Phase 3: Exam Extras (60 mins)**

1. Add role-based authorization
2. Create Blazor components
3. API integration (if required)

---

## 🎯 **Key Interconnection Points to Remember**

### **1. Model Relationships (CRITICAL)**

```csharp
Book → Author (Many-to-One)
Book → Category (Many-to-One)
Order → OrderItem → Book (Complex relationship)
```

### **2. DbContext Configuration**

- **One DbContext** in MVC project
- **Seed data** runs on startup
- **Navigation properties** enable easy queries

### **3. Dependency Injection**

- Services registered in `Program.cs`
- Controllers get what they need via constructor
- **Clean separation** of concerns

---

## 🚨 **Common Exam Pitfalls**

1. **Forgetting project references** - Shared models won't be available
2. **Connection strings** - LocalDB vs SQL Server Express
3. **Authentication setup** - Identity configuration is complex
4. **Seed data timing** - Must run after migrations
5. **Multi-project startup** - Students often forget to configure this

---

## 📝 **Quick Reference: Project Dependencies**

```xml
<!-- BookHaven.MVC.csproj -->
<ProjectReference Include="..\BookHaven.Shared\BookHaven.Shared.csproj" />

<!-- BookHaven.OrderApi.csproj -->
<ProjectReference Include="..\BookHaven.Shared\BookHaven.Shared.csproj" />
```

**Memory Tip**: Shared goes everywhere, others stand alone!

---

**Next**: [WALKTHROUGH_02_MODELS.md](./WALKTHROUGH_02_MODELS.md) - Deep dive into the domain model relationships

# Requirements Analysis: PxlFund Banking System

**Assignment**: C# Web2 Voorbeeldexamen - Banking Fund Management  
**Domain**: Financial/Banking Fund Management  
**Complexity**: High (Multi-project, API, Blazor, External Auth)  
**Time Constraint**: 3 hours (exam conditions)

---

## 🎯 **CORE REQUIREMENTS BREAKDOWN**

### **Architecture Requirements**
- **Multi-project solution**: PxlFund.Mvc + PxlFund.Shared
- **Project references**: MVC references Shared library
- **Offline NuGet packages**: Must work without internet
- **SQL Server**: LocalDB or SQL Server connection
- **External authentication**: Google OAuth integration

### **Data Model Requirements**
```
Bank
├── Id (int, PK)
├── Name (string) - "KBC", "Argenta"

Fund  
├── Id (int, PK)
├── Name (string) - "KBC Green", "KBC Yellow", etc.
├── BankId (int, FK)
├── Value (decimal) - 100, 125, 135, 140 euro
└── Bank (navigation)

UserFund (Many-to-Many Bridge)
├── UserId (string, FK)
├── FundId (int, FK)
├── User (navigation)
└── Fund (navigation)

User (Identity)
├── Standard Identity properties
├── Roles: "Admin", "Client"
└── UserFunds (navigation)
```

### **Seeding Data Requirements**
**Banks**:
- KBC
- Argenta

**Funds**:
- KBC Green (KBC, 100 euro)
- KBC Yellow (KBC, 125 euro)  
- ARG Brown (Argenta, 135 euro)
- ARG Black (Argenta, 140 euro)

**Users**:
- Admin user: admin@pxl.be / Adm!n
- Roles: Admin, Client

---

## 📋 **FUNCTIONAL REQUIREMENTS**

### **1. Authentication System**
- **Local login**: Username/password
- **External login**: Google OAuth
- **Role-based access**: Admin vs Client permissions
- **UserLoginRepository**: Handle both login types

### **2. MVC Controllers (CRUD)**
- **BankController**: Manage banks
- **FundController**: Manage funds
- **UserFundController**: Manage user-fund relationships

### **3. REST API Endpoints**
```
GET /api/FundInfo
Response: BankName – FundName – FundValue

POST /api/Fund/KBC  
Purpose: Add Fund for bank KBC
```

### **4. Blazor Components**
- **Add UserFund Component**: Form to add fund to user portfolio
- **User Funds Overview**: Display logged-in user's funds

---

## ⏱️ **3-HOUR IMPLEMENTATION STRATEGY**

### **Phase 1: Foundation (0-45 minutes)**
**Priority**: Get basic structure working
- [ ] Create solution with both projects
- [ ] Set up project references
- [ ] Configure NuGet packages offline
- [ ] Create basic models (Bank, Fund, UserFund)
- [ ] Set up ApplicationDbContext
- [ ] Configure SQL Server connection
- [ ] Initial migration and database creation

### **Phase 2: Core Functionality (45-135 minutes)**
**Priority**: CRUD operations and authentication
- [ ] Implement Identity with roles
- [ ] Create controllers (Bank, Fund, UserFund)
- [ ] Basic CRUD views for each entity
- [ ] Seed data implementation
- [ ] Google authentication setup
- [ ] Test basic login/logout flow

### **Phase 3: Advanced Features (135-180 minutes)**
**Priority**: API and Blazor components
- [ ] REST API endpoints (/api/FundInfo, /api/Fund/KBC)
- [ ] Blazor component for adding UserFund
- [ ] Blazor component for user funds overview
- [ ] Final testing and bug fixes
- [ ] Polish UI if time allows

---

## 🚨 **COMPLEXITY WARNINGS**

### **High Complexity Elements**
1. **Multi-project solution**: Project references can be tricky
2. **External authentication**: Google OAuth setup
3. **Blazor integration**: Mixed MVC/Blazor architecture
4. **API endpoints**: Additional routing configuration
5. **Role-based security**: Proper authorization setup

### **Potential Time Sinks**
- **Project reference issues**: Dependencies not loading
- **Google OAuth configuration**: Client ID/Secret setup
- **Blazor component integration**: SignalR hub configuration
- **API routing conflicts**: Controller vs API routing
- **Seeding data errors**: Migration or data insertion failures

### **Risk Mitigation Strategy**
- **Start simple**: Get basic MVC working first
- **Incremental testing**: Test each component before moving on
- **Fallback plan**: Skip Blazor/API if behind schedule
- **Focus on core**: Bank/Fund CRUD is essential, other features are bonus

---

## 🎯 **SUCCESS CRITERIA**

### **Minimum Viable Product (Must Have)**
- [ ] **Working solution** with both projects
- [ ] **Database created** with migrations
- [ ] **Basic CRUD** for Bank and Fund entities
- [ ] **User authentication** (local login working)
- [ ] **Seed data** populated correctly
- [ ] **No compilation errors**

### **Full Requirements (Exam Success)**
- [ ] **Google authentication** working
- [ ] **All three controllers** (Bank, Fund, UserFund)
- [ ] **API endpoints** responding correctly
- [ ] **Blazor components** functional
- [ ] **Role-based access** implemented
- [ ] **Clean, navigable UI**

### **Excellence Indicators**
- [ ] **Error handling** throughout application
- [ ] **Professional UI** with Bootstrap styling
- [ ] **Proper validation** on forms
- [ ] **Clean code structure** following patterns
- [ ] **Complete documentation** of implementation

---

## 🔧 **TECHNICAL IMPLEMENTATION NOTES**

### **Multi-Project Setup**
```xml
<!-- In PxlFund.Mvc.csproj -->
<ProjectReference Include="..\PxlFund.Shared\PxlFund.Shared.csproj" />
```

### **Google Authentication Configuration**
```csharp
services.AddAuthentication()
    .AddGoogle(options =>
    {
        options.ClientId = "your-client-id";
        options.ClientSecret = "your-client-secret";
    });
```

### **API Controller Setup**
```csharp
[ApiController]
[Route("api/[controller]")]
public class FundInfoController : ControllerBase
{
    [HttpGet]
    public IActionResult GetFundInfo()
    {
        // Return BankName – FundName – FundValue
    }
}
```

### **Blazor Component Integration**
```csharp
// In Program.cs
builder.Services.AddServerSideBlazor();

// In routing
app.MapBlazorHub();
```

---

## 📊 **ENTITY RELATIONSHIP ANALYSIS**

### **Core Relationships**
- **Bank → Funds**: One-to-Many (One bank has many funds)
- **User → UserFunds**: One-to-Many (One user has many fund investments)
- **Fund → UserFunds**: One-to-Many (One fund can be owned by many users)
- **User ↔ Fund**: Many-to-Many through UserFund bridge table

### **Database Schema**
```sql
Banks: Id, Name
Funds: Id, Name, BankId, Value
UserFunds: UserId, FundId
AspNetUsers: (Identity tables)
AspNetRoles: (Identity tables)
```

---

## 🚀 **TEMPLATE CUSTOMIZATION GUIDE**

### **Entity Mapping for Templates**
- `{Entity}` → Bank, Fund, UserFund
- `{ProjectName}` → PxlFund.Mvc
- `{SharedProject}` → PxlFund.Shared
- `{Domain}` → Banking/Financial

### **Template Adaptations Needed**
1. **Multi-project Program.cs**: Reference shared services
2. **Identity with roles**: Admin/Client role seeding
3. **API controllers**: Mixed MVC/API routing
4. **Blazor integration**: Server-side Blazor setup
5. **External auth**: Google OAuth configuration

---

**This is a complex, multi-faceted exam that tests all aspects of .NET Core development. Success requires systematic execution of the foundation first, then building up complexity layer by layer.**
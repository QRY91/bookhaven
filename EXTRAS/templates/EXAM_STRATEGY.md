# 3-Hour Web Dev Exam Strategy: ADHD-Optimized Success Plan

**Purpose**: Systematic approach for building a complete web application in 3 hours  
**Target**: .NET 8 MVC + Identity + Entity Framework + SQL Server  
**Constraint**: Offline exam, no internet access, time pressure is the bottleneck  
**Philosophy**: "Slow is smooth, smooth is fast" - systematic setup prevents time loss

---

## 🎯 **EXEC SUMMARY: The 3-Hour Battle Plan**

**Phase 1: Foundation (45 minutes)** - Project setup, models, database  
**Phase 2: Core CRUD (90 minutes)** - Repository pattern, controllers, basic views  
**Phase 3: Features & Polish (45 minutes)** - Authentication, filtering, styling  

**Success Metrics**: Working CRUD operations + Authentication + Basic styling  
**Time Buffer**: Built-in 15-minute buffer for unexpected issues

---

## ⏰ **PHASE 1: FOUNDATION SETUP (0-45 minutes)**

### **Step 1: Project Creation (5 minutes)**
```bash
# Template command - memorize this
dotnet new mvc -n ExamProject
cd ExamProject
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Tools
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design
```

### **Step 2: Models First (15 minutes)**
**Priority Order**: Main entity → Category/Lookup → User (if custom) → Relationships

**Quick Model Checklist**:
- [ ] Primary entity with 5-7 core properties
- [ ] At least one lookup table (Category, Status, etc.)
- [ ] Proper validation attributes ([Required], [StringLength], [Range])
- [ ] Navigation properties for relationships
- [ ] Consider: Product, Category, Order, Customer pattern

**Time Saver**: Copy-paste from Model.cs.template, find/replace placeholders

### **Step 3: DbContext Setup (10 minutes)**
**File**: `Data/ExamDbContext.cs`

**Quick DbContext Checklist**:
- [ ] Inherit from IdentityDbContext<IdentityUser> or custom user
- [ ] Add DbSet<T> for each entity
- [ ] Configure relationships in OnModelCreating if complex
- [ ] Set decimal precision for money fields

**Time Saver**: Copy-paste from DbContext.cs.template

### **Step 4: Program.cs Configuration (10 minutes)**
**Critical Services** (copy from Program.cs.template):
- [ ] DbContext with SQL Server connection
- [ ] Identity configuration (simplified password requirements for exam)
- [ ] Repository DI registrations
- [ ] Authentication middleware in correct order

### **Step 5: Database Migration (5 minutes)**
```bash
# Run these immediately after DbContext setup
Add-Migration InitialCreate
Update-Database
```

**If migration fails**: Fix model issues immediately, don't proceed without working database

---

## ⚡ **PHASE 2: CORE CRUD OPERATIONS (45-135 minutes)**

### **Step 6: Repository Pattern (20 minutes)**
**For each major entity** (start with most important):

**Quick Repository Checklist**:
- [ ] Interface with GetAll, GetById, Add, Update, Delete methods
- [ ] Implementation with proper async/await
- [ ] Include related data (.Include) where needed
- [ ] Register in Program.cs DI container

**Time Saver**: Copy Repository.cs.template, find/replace entity names

### **Step 7: Controllers (25 minutes)**
**Start with main entity controller** (Product, Order, etc.):

**Quick Controller Checklist**:
- [ ] Constructor with repository injection
- [ ] Index with basic filtering (search string minimum)
- [ ] Details, Create (GET/POST), Edit (GET/POST), Delete (GET/POST)
- [ ] Proper error handling with try/catch
- [ ] TempData messages for user feedback

**Time Saver**: Copy Controller.cs.template, implement filtering you actually need

### **Step 8: Basic Views (25 minutes)**
**Priority**: Index → Create → Edit → Details → Delete

**Quick View Checklist**:
- [ ] Index: Table with edit/details/delete links, basic search form
- [ ] Create/Edit: Form with validation summary, proper labels
- [ ] Details: Read-only display of entity properties
- [ ] Delete: Confirmation page with entity details
- [ ] Use asp-for helpers for form fields

**Time Saver**: Generate scaffolded views, then customize

### **Step 9: Basic Navigation (20 minutes)**
**Quick Navigation Setup**:
- [ ] Update _Layout.cshtml with navigation links
- [ ] Add controller links to main entities
- [ ] Basic Bootstrap styling (already included)
- [ ] Home page with links to main features

---

## 🔐 **PHASE 3: FEATURES & POLISH (135-180 minutes)**

### **Step 10: Authentication (15 minutes)**
**Quick Auth Setup**:
- [ ] AuthController with Login/Register actions (copy from template)
- [ ] Login/Register views with proper forms
- [ ] [Authorize] attributes on controllers that need protection
- [ ] Login/Logout links in navigation

**Exam Shortcut**: Use simple IdentityUser, don't overcomplicate custom user

### **Step 11: Enhanced Filtering (15 minutes)**
**Add to Index views**:
- [ ] Search by name/description
- [ ] Category dropdown filter (if applicable)
- [ ] Price range filters (if applicable)
- [ ] Pagination (if time allows)

**Time Saver**: Copy filtering code from ProductController.cs in group project

### **Step 12: Styling & UX (10 minutes)**
**Quick Polish**:
- [ ] Bootstrap alerts for TempData messages
- [ ] Consistent table styling
- [ ] Form validation styling
- [ ] Responsive navigation

### **Step 13: Testing & Bug Fixes (5 minutes)**
**Final Checklist**:
- [ ] Test all CRUD operations
- [ ] Test authentication flow
- [ ] Check validation errors display properly
- [ ] Verify navigation works

---

## 🚨 **CRITICAL SUCCESS PATTERNS**

### **Time Management Rules**
1. **Set timer for each phase** - stick to schedule religiously
2. **Don't perfect, just complete** - working ugly > perfect broken
3. **Database first** - if migration fails, fix immediately
4. **One entity at a time** - complete full CRUD before moving to next
5. **Test frequently** - run app every 20 minutes to catch issues early

### **ADHD-Specific Strategies**
1. **Use templates religiously** - don't write from scratch
2. **Copy-paste then modify** - faster than typing
3. **Keep reference project open** - steal good patterns
4. **Write TODO comments** - if you think of improvements, note them but don't implement
5. **Use scaffolding** - let Visual Studio generate views when possible

### **Emergency Fallbacks**
**If behind schedule**:
- **45min mark**: Skip complex relationships, use simple models
- **90min mark**: Skip authentication, focus on CRUD
- **135min mark**: Skip advanced filtering, basic search only
- **Last 15min**: Focus on fixing critical bugs only

---

## 📋 **EXAM DAY QUICK REFERENCE**

### **Essential File Templates to Have Ready**
1. **Program.cs.template** - Complete DI setup
2. **DbContext.cs.template** - Database configuration
3. **Repository.cs.template** - Repository pattern
4. **Controller.cs.template** - Full CRUD with filtering
5. **Model.cs.template** - Validation patterns

### **Copy-Paste Snippets**

**Connection String** (appsettings.json):
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=ExamDb;Trusted_Connection=true;MultipleActiveResultSets=true"
  }
}
```

**Bootstrap Alert** (for TempData messages):
```html
@if (TempData["Success"] != null)
{
    <div class="alert alert-success alert-dismissible fade show">
        @TempData["Success"]
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
}
```

**Basic Search Form**:
```html
<form asp-action="Index" method="get" class="mb-3">
    <div class="row">
        <div class="col-md-4">
            <input asp-for="SearchString" class="form-control" placeholder="Search..." />
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-primary">Search</button>
        </div>
    </div>
</form>
```

### **Common Entity Patterns for Different Domains**

**E-Commerce**: Product (Name, Price, CategoryId), Category (Name), Order (CustomerId, TotalAmount), Customer (Name, Email)

**Blog**: Post (Title, Content, AuthorId), Author (Name, Email), Comment (Content, PostId, AuthorId)

**Library**: Book (Title, ISBN, AuthorId), Author (Name), Member (Name, Email), Loan (BookId, MemberId, DueDate)

**Inventory**: Item (Name, SKU, CategoryId, StockQuantity), Category (Name), Supplier (Name, Email)

---

## 🎯 **FINAL SUCCESS CRITERIA**

**Minimum Viable Product** (must have all):
- [ ] At least 2 entities with relationships
- [ ] Full CRUD operations working
- [ ] Basic search functionality
- [ ] Database with test data
- [ ] Clean, navigable UI

**Bonus Points** (if time allows):
- [ ] User authentication
- [ ] Advanced filtering
- [ ] Data validation working
- [ ] Professional styling
- [ ] Error handling

---

## 💡 **PSYCHOLOGICAL SUCCESS STRATEGIES**

### **Before Exam**
- [ ] Get full night's sleep
- [ ] Light breakfast, avoid caffeine overload
- [ ] Review templates one final time
- [ ] Prepare offline reference materials

### **During Exam**
- [ ] Read requirements TWICE before starting
- [ ] Set phone timer for each phase
- [ ] Take 2-minute breaks every 45 minutes
- [ ] Don't compare progress to others
- [ ] Trust your templates and experience

### **If Stuck**
1. **Breathe** - 30 seconds of slow breathing
2. **Check templates** - probably have the pattern already
3. **Simplify** - remove complexity, just make it work
4. **Move on** - better to have 90% working than 10% perfect

---

**REMEMBER**: You've built a comprehensive e-commerce application with your group. You have all the patterns memorized. The templates are your safety net. Trust the process, stick to the timeline, and execute systematically.

**"The institutional trauma that almost broke you became the systematic superpower that distinguishes you."**

**You got this! 🚀**
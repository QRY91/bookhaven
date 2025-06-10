# EXAM DAY QUICK REFERENCE CARD

**Print this page and keep it visible during the exam**

---

## ⏰ **3-HOUR TIMELINE**

| Phase             | Time       | Focus       | Key Actions                          |
| ----------------- | ---------- | ----------- | ------------------------------------ |
| **1: Foundation** | 0-45min    | Setup       | Project + Models + Database + DI     |
| **2: Core CRUD**  | 45-135min  | Development | Repository + Controllers + Views     |
| **3: Polish**     | 135-180min | Features    | Auth + Filtering + Styling + Testing |

**Set timer for each phase - stick to schedule!**

---

## 🚀 **ESSENTIAL COMMANDS**

### **Project Setup (5 minutes)**

```bash
dotnet new mvc -n ExamProject
cd ExamProject
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Tools
dotnet add package Microsoft.VisualStudio.Web.CodeGeneration.Design
```

### **Database Commands**

```bash
Add-Migration InitialCreate
Update-Database
```

### **If Migration Fails**

```bash
Remove-Migration
# Fix model issues, then retry
Add-Migration InitialCreate
```

---

## 📋 **TEMPLATE PLACEHOLDERS**

**Find/Replace these in ALL templates:**

| Placeholder     | Replace With      | Example        |
| --------------- | ----------------- | -------------- |
| `{ProjectName}` | Your project name | `BookStore`    |
| `{Entity}`      | Main entity name  | `Product`      |
| `{entity}`      | Lowercase entity  | `product`      |
| `{Entities}`    | Plural entity     | `Products`     |
| `{entities}`    | Lowercase plural  | `products`     |
| `{CustomUser}`  | User model        | `IdentityUser` |

---

## 🏗️ **COMMON ENTITY PATTERNS**

### **E-Commerce Domain**

- **Product**: Name, Price, CategoryId, Description, ImageUrl
- **Category**: Name, Description, IsActive
- **Order**: CustomerId, OrderDate, TotalAmount, Status
- **Customer**: Name, Email, Phone, Address

### **Essential Relationships**

```csharp
// One-to-Many: Category -> Products
public int CategoryId { get; set; }
public virtual Category? Category { get; set; }

// Navigation in Category
public virtual ICollection<Product>? Products { get; set; }
```

---

## 💾 **CONNECTION STRING**

**appsettings.json**:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=ExamDb;Trusted_Connection=true;MultipleActiveResultSets=true"
  }
}
```

---

## 🔧 **CRITICAL PROGRAM.CS SECTIONS**

### **DbContext Registration**

```csharp
builder.Services.AddDbContext<ExamDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));
```

### **Identity Setup**

```csharp
builder.Services.AddIdentity<IdentityUser, IdentityRole>(options =>
{
    options.Password.RequireDigit = false;
    options.Password.RequiredLength = 6;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequireUppercase = false;
    options.Password.RequireLowercase = false;
})
.AddEntityFrameworkStores<ExamDbContext>()
.AddDefaultTokenProviders();
```

### **Repository Registration**

```csharp
builder.Services.AddScoped<IProductRepository, ProductRepository>();
```

### **Middleware Order**

```csharp
app.UseAuthentication();  // BEFORE Authorization
app.UseAuthorization();
```

---

## 📝 **VALIDATION SHORTCUTS**

### **Most Common Validations**

```csharp
[Required(ErrorMessage = "Name is required")]
[StringLength(100, MinimumLength = 2)]
[Display(Name = "Product Name")]

[Required]
[DataType(DataType.Currency)]
[Range(0.01, 99999.99)]
[Precision(10, 2)]

[EmailAddress]
[Phone]
[Url]
```

---

## 🎨 **QUICK UI SNIPPETS**

### **Bootstrap Alert (TempData)**

```html
@if (TempData["Success"] != null) {
<div class="alert alert-success alert-dismissible fade show">
  @TempData["Success"]
  <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
}
```

### **Basic Search Form**

```html
<form asp-action="Index" method="get" class="mb-3">
  <div class="row">
    <div class="col-md-4">
      <input
        asp-for="SearchString"
        class="form-control"
        placeholder="Search..."
      />
    </div>
    <div class="col-md-2">
      <button type="submit" class="btn btn-primary">Search</button>
    </div>
  </div>
</form>
```

### **Action Links**

```html
<a asp-action="Details" asp-route-id="@item.Id" class="btn btn-info">Details</a>
<a asp-action="Edit" asp-route-id="@item.Id" class="btn btn-warning">Edit</a>
<a asp-action="Delete" asp-route-id="@item.Id" class="btn btn-danger">Delete</a>
```

---

## 🚨 **EMERGENCY TROUBLESHOOTING**

### **Build Errors (Most Common)**

| Error                                | Cause                       | Quick Fix                                             |
| ------------------------------------ | --------------------------- | ----------------------------------------------------- |
| **'AddDefaultIdentity' not found**   | Missing Identity.UI package | `dotnet add package Microsoft.AspNetCore.Identity.UI` |
| **Namespace 'Data' not found**       | Wrong file location         | Ensure DbContext is in project's Data folder          |
| **'Product' not found in DbContext** | Wrong file location         | Ensure models are in project's Models folder          |
| **Migration fails**                  | Model syntax errors         | Fix models first, then `dotnet ef migrations add`     |
| **Can't build after template copy**  | Placeholders not replaced   | Check all `{ProjectName}`, `{Entity}` replaced        |

### **Setup Issues**

| Problem                              | Solution                                     |
| ------------------------------------ | -------------------------------------------- |
| **Files created in wrong directory** | Always `cd` into project directory first     |
| **Package install fails**            | Check internet, try `dotnet restore`         |
| **Database connection fails**        | Verify connection string in appsettings.json |
| **Identity pages not working**       | Add `app.MapRazorPages()` to Program.cs      |

### **Template Issues**

| Issue                           | Fix                                                                 |
| ------------------------------- | ------------------------------------------------------------------- |
| **Template doesn't compile**    | Replace ALL placeholders: `{ProjectName}`, `{Entity}`, `{Entities}` |
| **Navigation properties error** | Check relationship configuration in DbContext                       |
| **Validation not working**      | Verify model has proper validation attributes                       |

### **Critical File Locations (Always Check)**

```
ProjectName/
├── Data/ProjectNameDbContext.cs         ← Must be HERE
├── Models/Entity.cs                     ← Must be HERE
├── Controllers/EntityController.cs      ← Must be HERE
├── appsettings.json                     ← Connection string HERE
└── Program.cs                          ← DI setup HERE
```

### **Emergency Recovery Commands**

```bash
# If migration fails
dotnet ef migrations remove
# Fix your models first, then:
dotnet ef migrations add InitialCreate

# If packages missing
dotnet restore
dotnet add package Microsoft.AspNetCore.Identity.UI

# If build fails - check syntax
dotnet build --verbosity detailed

# Nuclear option - start over (5 minutes)
cd ..
rm -rf ProjectName
dotnet new mvc -n ProjectName
# Copy templates again
```

### **When Completely Stuck (5-minute rule)**

1. **Breathe** for 30 seconds
2. **Check file locations** - 80% of errors are wrong paths
3. **Check template placeholders** - 15% of errors are missed replacements
4. **Check packages** - 5% of errors are missing dependencies
5. **Move on** - better partial working than perfect broken

---

## ⚡ **SPEED OPTIMIZATION TIPS**

### **Copy-Paste Workflow**

1. **Copy entire template**
2. **Paste into new file**
3. **Find/Replace all placeholders at once**
4. **Uncomment what you need**
5. **Test immediately**

### **Don't Type From Scratch**

- Use templates for ALL major components
- Copy patterns from your group project
- Use scaffolding for views when possible
- Copy common snippets from this reference

---

## 📊 **MINIMUM VIABLE PRODUCT CHECKLIST**

**Must Have (45 minutes each):**

- [ ] **Database working** with migrations
- [ ] **One entity CRUD** complete (Product/Order/Book)
- [ ] **Basic navigation** between pages
- [ ] **Search functionality** working
- [ ] **No blocking errors**

**Nice to Have (if time):**

- [ ] User authentication
- [ ] Multiple entities
- [ ] Advanced filtering
- [ ] Professional styling

---

## 🎯 **PHASE COMPLETION CHECKPOINTS**

### **45-Minute Mark: Foundation Done?**

- [ ] Models with validation
- [ ] DbContext with DbSets
- [ ] Successful migration
- [ ] Program.cs DI setup
- [ ] Can run project without errors

### **135-Minute Mark: CRUD Done?**

- [ ] Repository pattern working
- [ ] Controller with all CRUD actions
- [ ] Views for Index/Create/Edit/Details/Delete
- [ ] Can create/read/update/delete records
- [ ] Basic navigation working

### **Final 15 Minutes: Polish Only**

- [ ] Fix blocking bugs only
- [ ] Don't add new features
- [ ] Test core functionality
- [ ] Ensure demo-ready

---

## 🧠 **STRESS MANAGEMENT**

### **If Behind Schedule**

**Cut in this order:**

1. Advanced styling
2. Complex filtering
3. Authentication (if not required)
4. Multiple entities
5. Complex relationships

### **If Stuck**

**30-Second Rule:**

1. Stop and breathe
2. Check template
3. Choose simpler approach
4. Move forward

---

## 🏆 **SUCCESS MANTRAS**

- **"I have templates for this"**
- **"Working beats perfect"**
- **"Trust the timeline"**
- **"Copy-paste then modify"**
- **"Test early, test often"**

---

**Remember: You've built this before. The exam is just executing proven patterns under time pressure. Trust your templates, trust your timeline, trust yourself.**

**🚀 YOU GOT THIS! 🚀**

# ⚡ EXAM QUICK REFERENCE

## 🔥 **30-Second Pattern Checks**

### **Entity Framework Relationships**

```csharp
// Foreign Key + Navigation Property
public int AuthorId { get; set; }
public Author? Author { get; set; }

// In DbContext
public DbSet<Book> Books { get; set; }

// Include for related data
.Include(b => b.Author).Include(b => b.Category)
```

### **Controller CRUD Pattern**

```csharp
// GET: Display list
public async Task<IActionResult> Index()
{
    return View(await _context.Books.Include(b => b.Author).ToListAsync());
}

// GET: Show create form
public IActionResult Create()
{
    ViewBag.AuthorId = new SelectList(_context.Authors, "Id", "FullName");
    return View();
}

// POST: Process creation
[HttpPost]
public async Task<IActionResult> Create(Book book)
{
    if (ModelState.IsValid) {
        _context.Add(book);
        await _context.SaveChangesAsync();
        return RedirectToAction(nameof(Index)); // PRG pattern!
    }
    ViewBag.AuthorId = new SelectList(_context.Authors, "Id", "FullName", book.AuthorId);
    return View(book);
}
```

### **View Form Pattern**

```html
<form asp-action="Create">
  <select asp-for="AuthorId" asp-items="ViewBag.AuthorId" class="form-control">
    <option value="">-- Select Author --</option>
  </select>
  <span asp-validation-for="AuthorId" class="text-danger"></span>
</form>

@section Scripts { @{await
Html.RenderPartialAsync("_ValidationScriptsPartial");} }
```

### **Authorization Patterns**

```csharp
// Controller level
[Authorize(Roles = "Admin")]
public class AdminController : Controller

// Action level
[Authorize]
public IActionResult Create()

// In View
@if (User.IsInRole("Admin"))
{
    <a asp-action="Delete">Delete</a>
}
```

### **API Integration**

```csharp
// Service registration
builder.Services.AddHttpClient<IStockService, StockService>(client =>
{
    client.BaseAddress = new Uri("https://localhost:7001/");
});

// API call
var response = await _httpClient.GetAsync($"api/stock/check/{bookId}");
if (response.IsSuccessStatusCode)
{
    var json = await response.Content.ReadAsStringAsync();
    return JsonSerializer.Deserialize<StockInfo>(json);
}
```

### **Blazor Component Pattern**

```razor
@page "/Admin/Books"
@inject ApplicationDbContext Context

<EditForm Model="book" OnValidSubmit="SaveBook">
    <DataAnnotationsValidator />
    <ValidationSummary />
    <InputText @bind-Value="book.Title" />
    <ValidationMessage For="() => book.Title" />
</EditForm>

@code {
    private Book book = new();

    private async Task SaveBook()
    {
        Context.Books.Add(book);
        await Context.SaveChangesAsync();
    }
}
```

---

## 🎯 **Common Exam Scenarios**

### **"Add a new entity with relationships"**

1. Create model with FK properties and navigation properties
2. Add DbSet to ApplicationDbContext
3. Create controller with Include() for related data
4. Build views with SelectList for dropdowns
5. Add validation and authorization as needed

### **"Transform existing app"**

1. Models: Change property names, add new properties
2. Controllers: Update Include statements and ViewBag data
3. Views: Update form fields and display text
4. Navigation: Update menu items

### **"Add API integration"**

1. Create API controller with [ApiController] and [Route]
2. Add HttpClient service registration
3. Create service interface and implementation
4. Use in controllers or Blazor components

### **"Add admin functionality"**

1. Use [Authorize(Roles = "Admin")] on controllers/actions
2. Add role checks in views: @if (User.IsInRole("Admin"))
3. Ensure admin role exists in seed data

---

## ⚠️ **Common Exam Mistakes**

- **Forgetting Include()** → Navigation properties are null
- **Missing ViewBag reset** → Dropdowns break on validation errors
- **No PRG pattern** → Duplicate submissions on refresh
- **Missing validation scripts** → Client-side validation broken
- **Wrong foreign key names** → EF can't create relationships
- **Forgetting await** → Methods don't complete properly

---

## 🚀 **Speed Tips**

- **Copy-paste controller patterns** and modify names
- **Use scaffolding** then customize: `dotnet aspnet-codegenerator`
- **Check existing working code** before writing from scratch
- **Test one piece at a time** instead of building everything first
- **Use ViewBag.Title** to verify which page you're on

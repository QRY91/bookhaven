# Mental Framework - Architectural Orientation

## 30-Second Framework (Core Architecture)

**"Where Am I?" - Quick Mental Map**

```
📊 DATA LAYER     → Models + DbContext + EF
🎮 CONTROL LAYER  → Controllers + Actions + Routing
👁️ VIEW LAYER     → Razor Views + ViewModels + Layout
🔐 AUTH LAYER     → Identity + Roles + Authorization
⚡ BLAZOR LAYER   → Components + Services + Real-time
🌐 API LAYER      → Controllers + HttpClient + JSON
```

**Mental Anchor:** Data flows UP (Models→Controllers→Views), User flows DOWN (Views→Controllers→Models)

---

## 1-Minute Framework (Key Patterns)

**"How Do I Navigate?" - Pattern Recognition**

### 🏗️ **MVC Flow Pattern**

- **Route** → **Controller Action** → **Model/Service** → **View**
- Controller gets data, passes to view via ViewBag/Model
- POST actions: model binding → validation → save → redirect

### 🔗 **Entity Framework Pattern**

- **Models** = Database tables with navigation properties
- **DbContext** = Database gateway with DbSet<> collections
- **Loading** = Include() for eager, virtual for lazy

### 🛡️ **Authorization Pattern**

- **[Authorize]** = Login required
- **[Authorize(Roles = "Admin")]** = Role required
- **User.IsInRole()** = Conditional access in views

### ⚡ **Blazor Integration Pattern**

- **@page** directives for routing
- **@inject** for dependency injection
- **StateHasChanged()** for UI updates

---

## 5-Minute Framework (Implementation Details)

**"How Do I Implement?" - Code Patterns**

### 📊 **DATA LAYER Deep Dive**

```csharp
// Model Pattern
public class Book {
    public int Id { get; set; }                    // Primary Key
    public int AuthorId { get; set; }             // Foreign Key
    public virtual Author Author { get; set; }    // Navigation Property
}

// DbContext Pattern
public class BookHavenContext : DbContext {
    public DbSet<Book> Books { get; set; }
    protected override void OnModelCreating(ModelBuilder builder) {
        // Seed data, configure relationships
    }
}
```

### 🎮 **CONTROLLER LAYER Deep Dive**

```csharp
// GET Pattern
public IActionResult Index() {
    var books = _context.Books.Include(b => b.Author).ToList();
    return View(books);
}

// POST Pattern
[HttpPost]
public IActionResult Create(Book book) {
    if (ModelState.IsValid) {
        _context.Books.Add(book);
        _context.SaveChanges();
        return RedirectToAction("Index");
    }
    return View(book);
}

// API Pattern
[ApiController]
[Route("api/[controller]")]
public class BooksController : ControllerBase {
    [HttpGet("{id}")]
    public IActionResult Get(int id) => Ok(_context.Books.Find(id));
}
```

### 👁️ **VIEW LAYER Deep Dive**

```razor
@* Layout Pattern *@
@{
    Layout = "_Layout";
    ViewData["Title"] = "Books";
}

@* Model Binding Pattern *@
@model IEnumerable<Book>
@foreach(var book in Model) {
    <p>@book.Title by @book.Author.Name</p>
}

@* Form Pattern *@
@using (Html.BeginForm()) {
    @Html.LabelFor(m => m.Title)
    @Html.TextBoxFor(m => m.Title)
    @Html.ValidationMessageFor(m => m.Title)
}
```

### 🔐 **AUTH LAYER Deep Dive**

```csharp
// Controller Authorization
[Authorize(Roles = "Admin")]
public class AdminController : Controller { }

// View Conditional Access
@if (User.IsInRole("Admin")) {
    <a href="/Admin">Admin Dashboard</a>
}

// Program.cs Setup
builder.Services.AddDefaultIdentity<IdentityUser>(options => {
    options.SignIn.RequireConfirmedAccount = false;
}).AddRoles<IdentityRole>()
  .AddEntityFrameworkStores<BookHavenContext>();
```

### ⚡ **BLAZOR LAYER Deep Dive**

```razor
@* Component Pattern *@
@page "/admin/books"
@inject BookHavenContext Context
@inject IJSRuntime JSRuntime

<h3>Book Manager</h3>
@if (books == null) {
    <p>Loading...</p>
} else {
    @foreach (var book in books) {
        <div>@book.Title</div>
    }
}

@code {
    private List<Book> books;

    protected override async Task OnInitializedAsync() {
        books = Context.Books.Include(b => b.Author).ToList();
    }
}
```

### 🌐 **API INTEGRATION Deep Dive**

```csharp
// Service Pattern
public interface IStockService {
    Task<StockResponse> CheckStockAsync(int bookId);
}

public class StockService : IStockService {
    private readonly HttpClient _httpClient;

    public async Task<StockResponse> CheckStockAsync(int bookId) {
        var response = await _httpClient.GetAsync($"api/stock/check/{bookId}");
        return await response.Content.ReadFromJsonAsync<StockResponse>();
    }
}

// Registration Pattern
builder.Services.AddHttpClient<IStockService, StockService>(client => {
    client.BaseAddress = new Uri("https://localhost:7001/");
});
```

---

## 🧠 Mental Navigation Commands

**"I'm Lost - Where Am I?"**

- Look for: `@model`, `@page`, `[HttpGet]`, `DbSet<>`, `@inject`
- These keywords instantly tell you which layer you're in

**"I Need to Flow Data"**

- **UP Flow:** Model → Controller → View
- **DOWN Flow:** Form → Controller → Model → Database

**"I Need to Add Feature"**

- **CRUD:** Model → DbContext → Controller → Views
- **Auth:** Add [Authorize] → Check User.IsInRole()
- **API:** Create controller → Add service → Inject in consumer

**"I'm Debugging"**

- **Null Reference:** Missing Include() or navigation property
- **404:** Check routing, controller/action names
- **403:** Check authorization attributes and user roles

---

## 🎯 Exam Instinct Patterns

1. **See `DbSet<Book>`** → Think: Data layer, EF context
2. **See `[HttpPost]`** → Think: Form submission, model binding
3. **See `@model Book`** → Think: Strongly-typed view
4. **See `User.IsInRole()`** → Think: Role-based authorization
5. **See `@inject`** → Think: Blazor dependency injection
6. **See `Include()`** → Think: Eager loading relationships

**Mental Mantra:** "Data up, user down, authorize everything, include relationships"

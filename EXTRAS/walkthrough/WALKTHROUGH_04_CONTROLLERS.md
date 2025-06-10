# 🎮 WALKTHROUGH 04: MVC Controllers & CRUD Operations

## 🎯 **Exam Focus**: Controller Patterns & Business Logic in 25 minutes

### **The Controller Trinity** (Three Levels of Complexity)

```
📚 BooksController (COMPLEX)    👤 AuthorsController (STANDARD)    📂 CategoriesController (SIMPLE)
├── Advanced Search             ├── Basic CRUD                      ├── Basic CRUD
├── Multiple Filters            ├── Include Navigation              ├── Simple Validation
├── ViewBag Data               ├── Standard Validation             └── Minimal Logic
└── Complex Queries            └── Error Handling
```

---

## 🔧 **Controller Base Pattern** (All Controllers Follow This)

### **Constructor Injection** (DbContext Dependency)

```csharp
public class BooksController : Controller
{
    private readonly ApplicationDbContext _context;

    public BooksController(ApplicationDbContext context)
    {
        _context = context; // Dependency Injection Magic
    }
}
```

### **The 7 Standard Actions** (CRUD + 1)

```
1. Index()         → List all items
2. Details(id)     → Show one item
3. Create() GET    → Show create form
4. Create() POST   → Process create form
5. Edit(id) GET    → Show edit form
6. Edit(id) POST   → Process edit form
7. Delete(id) GET  → Show delete confirmation
8. DeleteConfirmed() POST → Actually delete
```

---

## 📊 **BooksController: The Complex One** (Exam Favorite)

### **Index Action: Advanced Search & Filtering**

```csharp
public async Task<IActionResult> Index(string searchString, int? categoryId,
    int? authorId, decimal? minPrice, decimal? maxPrice)
{
    // START WITH BASE QUERY (Include related data)
    var booksQuery = _context.Books
        .Include(b => b.Author)    // Load Author with each Book
        .Include(b => b.Category)  // Load Category with each Book
        .AsQueryable();            // Keep it as IQueryable for chaining

    // SEARCH FUNCTIONALITY (Multiple fields)
    if (!string.IsNullOrEmpty(searchString))
    {
        booksQuery = booksQuery.Where(b =>
            b.Title.Contains(searchString) ||
            b.Description.Contains(searchString) ||
            b.Author.FirstName.Contains(searchString) ||
            b.Author.LastName.Contains(searchString));
    }

    // CATEGORY FILTER
    if (categoryId.HasValue)
        booksQuery = booksQuery.Where(b => b.CategoryId == categoryId);

    // AUTHOR FILTER
    if (authorId.HasValue)
        booksQuery = booksQuery.Where(b => b.AuthorId == authorId);

    // PRICE RANGE FILTER
    if (minPrice.HasValue)
        booksQuery = booksQuery.Where(b => b.Price >= minPrice);
    if (maxPrice.HasValue)
        booksQuery = booksQuery.Where(b => b.Price <= maxPrice);

    // EXECUTE QUERY & SORT
    var books = await booksQuery.OrderBy(b => b.Title).ToListAsync();

    // POPULATE VIEWBAG FOR DROPDOWNS
    ViewBag.Categories = new SelectList(await _context.Categories.ToListAsync(), "Id", "Name");
    ViewBag.Authors = new SelectList(await _context.Authors.ToListAsync(), "Id", "FullName");

    // PRESERVE CURRENT FILTER VALUES
    ViewBag.CurrentSearch = searchString;
    ViewBag.CurrentCategory = categoryId;
    ViewBag.CurrentAuthor = authorId;

    return View(books);
}
```

---

## ⚡ **Speed Reconstruction: Controller Patterns (30 mins)**

### **Step 1: Basic CRUD Controller (15 mins)**

```csharp
public class BooksController : Controller
{
    private readonly ApplicationDbContext _context;

    public BooksController(ApplicationDbContext context) => _context = context;

    // Index - List all
    public async Task<IActionResult> Index()
    {
        var books = await _context.Books
            .Include(b => b.Author)
            .Include(b => b.Category)
            .ToListAsync();
        return View(books);
    }

    // Create GET
    public IActionResult Create()
    {
        ViewData["AuthorId"] = new SelectList(_context.Authors, "Id", "FullName");
        ViewData["CategoryId"] = new SelectList(_context.Categories, "Id", "Name");
        return View();
    }

    // Create POST
    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Book book)
    {
        if (ModelState.IsValid)
        {
            _context.Add(book);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
        // Repopulate dropdowns on error
        ViewData["AuthorId"] = new SelectList(_context.Authors, "Id", "FullName", book.AuthorId);
        ViewData["CategoryId"] = new SelectList(_context.Categories, "Id", "Name", book.CategoryId);
        return View(book);
    }
}
```

---

## 🎯 **Key Patterns to Master**

### **1. Include() for Related Data**

```csharp
// Single level
.Include(b => b.Author)

// Multiple properties
.Include(b => b.Author)
.Include(b => b.Category)

// Deep loading
.Include(a => a.Books)
.ThenInclude(b => b.Category)
```

### **2. SelectList for Dropdowns**

```csharp
// Basic dropdown
ViewData["AuthorId"] = new SelectList(_context.Authors, "Id", "FullName");

// With selected value (for Edit)
ViewData["AuthorId"] = new SelectList(_context.Authors, "Id", "FullName", book.AuthorId);
```

### **3. PRG Pattern (Post-Redirect-Get)**

```csharp
// After successful POST
return RedirectToAction(nameof(Index));

// NOT: return View() - causes duplicate submissions
```

---

## 🚨 **Common Exam Mistakes**

### **1. Missing Include() Statements**

```csharp
// ❌ WRONG - Navigation properties will be null
var books = await _context.Books.ToListAsync();

// ✅ CORRECT
var books = await _context.Books
    .Include(b => b.Author)
    .Include(b => b.Category)
    .ToListAsync();
```

### **2. Forgetting to Repopulate ViewData**

```csharp
// ❌ WRONG - Dropdowns empty on validation error
[HttpPost]
public async Task<IActionResult> Create(Book book)
{
    if (ModelState.IsValid) { ... }
    return View(book); // NO DROPDOWN DATA!
}

// ✅ CORRECT - Always repopulate dropdowns
[HttpPost]
public async Task<IActionResult> Create(Book book)
{
    if (ModelState.IsValid) { ... }
    ViewData["AuthorId"] = new SelectList(_context.Authors, "Id", "FullName", book.AuthorId);
    return View(book);
}
```

---

**Next**: [WALKTHROUGH_05_VIEWS.md](./WALKTHROUGH_05_VIEWS.md) - The user interface layer

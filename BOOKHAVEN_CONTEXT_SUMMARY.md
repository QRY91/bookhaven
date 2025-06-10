# 📚 BookHaven Application - Complete Context Summary

## 🏗️ **Architecture Overview**

**Multi-Project Solution Structure:**

```
BookHaven/
├── BookHaven.MVC/          # Main web application (Razor Pages + MVC)
├── BookHaven.IdentityServer/ # Authentication service (minimal setup)
├── BookHaven.OrderApi/     # REST API for order management
├── BookHaven.Shared/       # Shared models and DTOs
└── BookHaven.sln          # Solution file with dependencies
```

**Project Dependencies:**

- `BookHaven.MVC` depends on `BookHaven.Shared`, `BookHaven.IdentityServer`, `BookHaven.OrderApi`
- Multi-project startup profile configured (press F5 to launch all services)

---

## 🎯 **Core Domain Models**

### **Book Entity** (Primary Focus)

```csharp
public class Book
{
    public int Id { get; set; }

    [Required] public string Title { get; set; }
    public string Description { get; set; }
    [Required] public string ISBN { get; set; }

    [Range(0.01, 999.99)] public decimal Price { get; set; }
    public int StockQuantity { get; set; }
    public DateTime PublishedDate { get; set; }
    public bool IsActive { get; set; }
    public string? ImageUrl { get; set; }

    // Foreign Keys
    public int AuthorId { get; set; }
    public int CategoryId { get; set; }

    // Navigation Properties
    public virtual Author? Author { get; set; }
    public virtual Category? Category { get; set; }
    public virtual ICollection<OrderItem>? OrderItems { get; set; }
}
```

### **Author Entity**

```csharp
public class Author
{
    public int Id { get; set; }
    [Required] public string FirstName { get; set; }
    [Required] public string LastName { get; set; }
    public string? Biography { get; set; }
    public DateTime? BirthDate { get; set; }
    [EmailAddress] public string? Email { get; set; }
    [Url] public string? Website { get; set; }

    // Navigation Properties
    public virtual ICollection<Book>? Books { get; set; }
    public string FullName => $"{FirstName} {LastName}";
}
```

### **Category Entity**

```csharp
public class Category
{
    public int Id { get; set; }
    [Required] public string Name { get; set; }
    public string? Description { get; set; }
    public int DisplayOrder { get; set; }
    public bool IsActive { get; set; }

    // Navigation Properties
    public virtual ICollection<Book>? Books { get; set; }
}
```

### **Order System** (For API integration)

- `Order`: Customer orders with order items
- `OrderItem`: Individual book items in orders
- `Customer`: Customer information

---

## 🔐 **Authentication & Authorization**

### **Current Setup (Working)**

- **ASP.NET Core Identity** with custom `ApplicationUser`
- **Admin User**: `admin@bookhaven.com` / `Admin123!`
- **Roles**: `Admin`, `Client` (but no authorization attributes yet)
- **Email as Username** enabled
- **No confirmation required** for development

### **⚠️ Missing Role-Based Authorization**

**Controllers currently have NO authorization attributes!** All CRUD operations are public.

**You should add:**

```csharp
[Authorize] // For authenticated users (Read operations)
[Authorize(Roles = "Admin")] // For admin-only (Create/Update/Delete)
```

---

## 🎮 **Controller Functionality**

### **BooksController** (Most Complex)

- **Index**: Advanced filtering (search, category, author, price range)
- **Details**: Book details with related data (Author, Category)
- **Create/Edit/Delete**: Full CRUD with validation
- **ViewBag data**: Categories and Authors for dropdowns

### **AuthorsController** & **CategoriesController**

- Standard scaffolded CRUD operations
- Basic validation and error handling

### **⚠️ Missing Features for Exams:**

1. **Role-based authorization** (CUD = Admin only, R = Any user)
2. **Blazor components** (likely exam requirement)
3. **API integration** (OrderApi is there but not used)
4. **Advanced validation** (custom validators)
5. **File upload** (book images)

---

## 🌱 **Seed Data (Rich & Realistic)**

### **Categories** (5)

- Fiction, Non-Fiction, Science, History, Biography

### **Authors** (5 Famous)

- J.K. Rowling, Stephen King, Neil Gaiman, Isaac Asimov, Agatha Christie
- Complete with biographies, birth dates, emails, websites

### **Books** (5+ with relationships)

- Harry Potter series, Stephen King novels, etc.
- Proper ISBN, pricing, stock quantities
- Image URLs configured (though images may not exist)

---

## 🚀 **Development Setup**

### **Multi-Project Startup (F5 Ready)**

- **IdentityServer**: `https://localhost:5001`
- **OrderApi**: `https://localhost:7232`
- **MVC**: `https://localhost:7234` (main entry point)

### **Database**

- **SQL Server LocalDB** (connection string in appsettings.json)
- **Entity Framework Core** with migrations
- **Auto-seeding** on application start

---

## 📋 **Exam Preparation Recommendations**

### **1. Add Role-Based Authorization** (High Priority)

```csharp
// Books Controller example
[Authorize] // All methods require authentication
public class BooksController : Controller
{
    [AllowAnonymous] // Or remove [Authorize] from class
    public async Task<IActionResult> Index() { ... }

    [AllowAnonymous]
    public async Task<IActionResult> Details(int? id) { ... }

    [Authorize(Roles = "Admin")]
    public IActionResult Create() { ... }

    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Edit(int? id) { ... }

    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Delete(int? id) { ... }
}
```

### **2. Add Blazor Components** (Likely Exam Topic)

Create components for:

- Book search/filter widget
- Author selection component
- Category management
- Book recommendation slider

### **3. Integrate OrderApi** (API Calls)

- Create service classes to call the OrderApi
- Add HttpClient configuration
- Implement order management from MVC

### **4. Enhance Validation**

- Custom validation attributes
- Client-side validation with JavaScript
- File upload validation for book images

### **5. Add Advanced Features**

- Pagination for large datasets
- Sorting functionality
- Export to Excel/PDF
- Email notifications
- Logging and error handling

---

## 🛠️ **Quick Study Commands**

```bash
# Run the application
dotnet run --project BookHaven.MVC

# Create new migration
dotnet ef migrations add [MigrationName] --project BookHaven.MVC

# Update database
dotnet ef database update --project BookHaven.MVC

# Build entire solution
dotnet build

# Run tests (if you add them)
dotnet test
```

---

## 🎯 **Key Exam Scenarios You Can Practice**

1. **Transform to Restaurant**: Author→Restaurant, Book→MenuItem, Category→FoodType
2. **Add role-based authorization**: Admin can CUD, Users can R
3. **Create Blazor components**: Interactive UI elements
4. **API integration**: Connect MVC to OrderApi
5. **Custom validation**: Business rules and constraints
6. **File uploads**: Book cover images
7. **Advanced queries**: Complex filtering and search
8. **Data export**: PDF/Excel generation

---

## 📚 **This is Your Foundation**

BookHaven is a **production-ready foundation** with:

- ✅ Multi-project architecture
- ✅ Working authentication
- ✅ Rich domain models with relationships
- ✅ Comprehensive seed data
- ✅ Advanced search/filtering
- ✅ Proper validation and error handling
- ✅ Professional UI structure

**Missing pieces** (perfect for exam practice):

- ⚠️ Role-based authorization
- ⚠️ Blazor components
- ⚠️ API integration
- ⚠️ Advanced features

**Study Strategy**: Focus on the missing pieces while understanding how the existing foundation works. This gives you the best of both worlds - a solid base to build on, plus clear areas to demonstrate your skills during exams.

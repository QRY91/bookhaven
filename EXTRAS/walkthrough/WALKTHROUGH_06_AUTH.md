# 🔐 WALKTHROUGH 06: Authentication & Authorization

## 🎯 **Exam Focus**: Identity & Security in 15 minutes

### **Authentication vs Authorization** (Know the Difference!)

```
🔑 AUTHENTICATION (Who are you?)
├── Login/Register forms
├── ASP.NET Core Identity
├── JWT tokens (IdentityServer)
└── User management

🛡️ AUTHORIZATION (What can you do?)
├── [Authorize] attributes
├── Role-based access
├── Claims-based permissions
└── Resource protection
```

---

## 🔧 **ASP.NET Core Identity Setup** (The Foundation)

### **Program.cs Configuration**

```csharp
// 1. DATABASE CONTEXT (with Identity)
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));

// 2. IDENTITY CONFIGURATION
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options => {
    // NO EMAIL CONFIRMATION (for development)
    options.SignIn.RequireConfirmedAccount = false;
    options.SignIn.RequireConfirmedEmail = false;

    // PASSWORD RULES
    options.Password.RequiredLength = 8;
    options.Password.RequireDigit = true;
    options.Password.RequireUppercase = true;
    options.Password.RequireLowercase = true;
    options.Password.RequireNonAlphanumeric = true;

    // USER SETTINGS
    options.User.RequireUniqueEmail = true;
    options.User.AllowedUserNameCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._@+";
})
.AddEntityFrameworkStores<ApplicationDbContext>() // Link to DbContext
.AddDefaultTokenProviders();

// 3. ADD MVC WITH VIEWS (includes auth views)
builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages(); // For Identity UI

var app = builder.Build();

// 4. MIDDLEWARE ORDER (CRITICAL!)
app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

app.UseAuthentication(); // WHO are you?
app.UseAuthorization();  // WHAT can you do?

app.MapControllerRoute(...);
app.MapRazorPages(); // Identity pages (login/register)
```

**Critical Points:**

- **Authentication before Authorization** in middleware pipeline
- **AddRazorPages()** required for Identity UI
- **RequireConfirmedAccount = false** for exam environment

---

## 👤 **ApplicationUser Model** (Custom User)

```csharp
// BookHaven.Shared/Models/ApplicationUser.cs
public class ApplicationUser : IdentityUser
{
    [Required]
    [StringLength(50)]
    public string FirstName { get; set; } = string.Empty;

    [Required]
    [StringLength(50)]
    public string LastName { get; set; } = string.Empty;

    // Computed property
    public string FullName => $"{FirstName} {LastName}";
}
```

**Why Custom User?**

- Add business-specific properties
- Still gets all Identity features (Email, Password, etc.)
- Can relate to other entities if needed

---

## 🌱 **Role & User Seeding** (Admin Setup)

### **SeedData.Initialize** (Create Admin User)

```csharp
public static async Task Initialize(IServiceProvider serviceProvider)
{
    var roleManager = serviceProvider.GetRequiredService<RoleManager<IdentityRole>>();
    var userManager = serviceProvider.GetRequiredService<UserManager<ApplicationUser>>();

    // 1. CREATE ROLES
    string[] roleNames = { "Admin", "Client" };
    foreach (var roleName in roleNames)
    {
        if (!await roleManager.RoleExistsAsync(roleName))
        {
            await roleManager.CreateAsync(new IdentityRole(roleName));
        }
    }

    // 2. CREATE ADMIN USER
    var adminEmail = "admin@bookhaven.com";
    var adminUser = await userManager.FindByEmailAsync(adminEmail);

    if (adminUser == null)
    {
        adminUser = new ApplicationUser
        {
            UserName = adminEmail,    // EMAIL AS USERNAME
            Email = adminEmail,
            EmailConfirmed = true,    // Skip email confirmation
            FirstName = "Admin",
            LastName = "User"
        };

        var result = await userManager.CreateAsync(adminUser, "Admin123!");
        if (result.Succeeded)
        {
            await userManager.AddToRoleAsync(adminUser, "Admin");
        }
    }
}
```

**Seeding Strategy:**

1. **Roles first** (Admin, Client)
2. **Admin user** with strong password
3. **Email as username** for simplicity
4. **Skip email confirmation** for exams

---

## 🛡️ **Authorization Patterns** (Protecting Controllers)

### **Method 1: Controller-Level Authorization**

```csharp
[Authorize] // ALL actions require authentication
public class BooksController : Controller
{
    // Index & Details - any authenticated user can access
    [AllowAnonymous] // Override class-level [Authorize]
    public async Task<IActionResult> Index() { ... }

    [AllowAnonymous]
    public async Task<IActionResult> Details(int? id) { ... }

    // Create, Edit, Delete - Admin only
    [Authorize(Roles = "Admin")]
    public IActionResult Create() { ... }

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Create(Book book) { ... }

    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Edit(int? id) { ... }

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Edit(int id, Book book) { ... }

    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Delete(int? id) { ... }

    [HttpPost, ActionName("Delete")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> DeleteConfirmed(int id) { ... }
}
```

### **Method 2: Action-Level Authorization**

```csharp
public class BooksController : Controller
{
    // Public actions - no authorization needed
    public async Task<IActionResult> Index() { ... }
    public async Task<IActionResult> Details(int? id) { ... }

    // Protected actions - require specific roles
    [Authorize(Roles = "Admin")]
    public IActionResult Create() { ... }

    [HttpPost]
    [Authorize(Roles = "Admin")]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Create(Book book) { ... }
}
```

---

## 🎨 **View-Level Authorization** (Conditional UI)

### **Hide/Show Based on User Role**

```html
<!-- In Views/Books/Index.cshtml -->
@using Microsoft.AspNetCore.Identity @inject SignInManager<ApplicationUser>
  SignInManager @inject UserManager<ApplicationUser>
    UserManager

    <h2>📚 Books</h2>

    <!-- ADMIN-ONLY BUTTONS -->
    @if (SignInManager.IsSignedIn(User) && User.IsInRole("Admin")) {
    <a asp-action="Create" class="btn btn-primary mb-3">
      <i class="bi bi-plus-circle"></i> Add New Book
    </a>
    }

    <table class="table">
      <thead>
        <tr>
          <th>Title</th>
          <th>Author</th>
          <th>Price</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
        @foreach (var item in Model) {
        <tr>
          <td>@item.Title</td>
          <td>@(item.Author?.FullName ?? "Unknown")</td>
          <td>@item.Price.ToString("C")</td>
          <td>
            <!-- EVERYONE can view details -->
            <a
              asp-action="Details"
              asp-route-id="@item.Id"
              class="btn btn-sm btn-info"
              >Details</a
            >

            <!-- ADMIN ONLY - Edit/Delete -->
            @if (User.IsInRole("Admin")) {
            <a
              asp-action="Edit"
              asp-route-id="@item.Id"
              class="btn btn-sm btn-warning"
              >Edit</a
            >
            <a
              asp-action="Delete"
              asp-route-id="@item.Id"
              class="btn btn-sm btn-danger"
              >Delete</a
            >
            }
          </td>
        </tr>
        }
      </tbody>
    </table></ApplicationUser
  ></ApplicationUser
>
```

### **Login Partial** (\_LoginPartial.cshtml)

```html
@using Microsoft.AspNetCore.Identity
@inject SignInManager<ApplicationUser> SignInManager
@inject UserManager<ApplicationUser> UserManager

<ul class="navbar-nav">
    @if (SignInManager.IsSignedIn(User))
    {
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown">
                Welcome @User.Identity!.Name!
            </a>
            <ul class="dropdown-menu">
                <li><a class="dropdown-item" asp-area="Identity" asp-page="/Account/Manage/Index">Profile</a></li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <form class="dropdown-item" asp-area="Identity" asp-page="/Account/Logout" asp-route-returnUrl="@Url.Action("Index", "Home")">
                        <button type="submit" class="btn btn-link nav-link">Logout</button>
                    </form>
                </li>
            </ul>
        </li>
    }
    else
    {
        <li class="nav-item">
            <a class="nav-link" asp-area="Identity" asp-page="/Account/Register">Register</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" asp-area="Identity" asp-page="/Account/Login">Login</a>
        </li>
    }
</ul>
```

---

## ⚡ **Speed Reconstruction: Auth Setup (20 mins)**

### **Step 1: Configure Identity (5 mins)**

```csharp
// In Program.cs
builder.Services.AddIdentity<ApplicationUser, IdentityRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();

builder.Services.AddRazorPages(); // For Identity UI

// After app.Build()
app.UseAuthentication();
app.UseAuthorization();
app.MapRazorPages();
```

### **Step 2: Create ApplicationUser (5 mins)**

```csharp
public class ApplicationUser : IdentityUser
{
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string FullName => $"{FirstName} {LastName}";
}
```

### **Step 3: Seed Admin User (5 mins)**

```csharp
// In SeedData
var adminUser = new ApplicationUser
{
    UserName = "admin@example.com",
    Email = "admin@example.com",
    EmailConfirmed = true
};
await userManager.CreateAsync(adminUser, "Admin123!");
await userManager.AddToRoleAsync(adminUser, "Admin");
```

### **Step 4: Add Authorization (5 mins)**

```csharp
[Authorize(Roles = "Admin")]
public class BooksController : Controller
{
    [AllowAnonymous]
    public async Task<IActionResult> Index() { ... }

    // Other actions require Admin role
}
```

---

## 🚨 **Common Exam Mistakes**

### **1. Wrong Middleware Order**

```csharp
// ❌ WRONG - Authorization before Authentication
app.UseAuthorization();
app.UseAuthentication();

// ✅ CORRECT - Authentication first
app.UseAuthentication();
app.UseAuthorization();
```

### **2. Missing RazorPages**

```csharp
// ❌ WRONG - No Identity UI
builder.Services.AddControllersWithViews();

// ✅ CORRECT - Include RazorPages for Identity
builder.Services.AddControllersWithViews();
builder.Services.AddRazorPages();

// And in pipeline
app.MapRazorPages();
```

### **3. Forgetting [AllowAnonymous]**

```csharp
// ❌ WRONG - Index requires login
[Authorize]
public class BooksController : Controller
{
    public async Task<IActionResult> Index() { ... } // Requires login!
}

// ✅ CORRECT - Allow anonymous access to Index
[Authorize]
public class BooksController : Controller
{
    [AllowAnonymous]
    public async Task<IActionResult> Index() { ... } // Public access
}
```

---

## 🎓 **Exam Scenarios**

### **1. "Make Books readable by everyone, but only Admins can modify"**

```csharp
[Authorize]
public class BooksController : Controller
{
    [AllowAnonymous]
    public async Task<IActionResult> Index() { ... }

    [AllowAnonymous]
    public async Task<IActionResult> Details(int? id) { ... }

    [Authorize(Roles = "Admin")]
    public IActionResult Create() { ... }

    // All other CUD actions inherit [Authorize] from class
}
```

### **2. "Add role-based navigation"**

```html
@if (User.IsInRole("Admin")) {
<a asp-action="Create" class="btn btn-primary">Add New</a>
}
```

### **3. "Create admin user with password Admin123!"**

```csharp
await userManager.CreateAsync(new ApplicationUser
{
    UserName = "admin@example.com",
    Email = "admin@example.com",
    EmailConfirmed = true
}, "Admin123!");
```

---

**Summary**: Authentication identifies users, Authorization controls access. Use Identity for user management, [Authorize] attributes for protection, and view logic for conditional UI. 🔐

# 🗄️ WALKTHROUGH 03: DbContext & Data Layer

## 🎯 **Exam Focus**: Database Configuration & Seeding in 15 minutes

### **The Data Foundation** (How Models Become Tables)

```
ApplicationDbContext (INHERITS FROM IdentityDbContext)
├── 📊 DbSet<Book> Books
├── 👤 DbSet<Author> Authors
├── 📂 DbSet<Category> Categories
└── 🔐 Identity Tables (Users, Roles, etc.) - AUTOMATIC
```

---

## 🔧 **DbContext Structure** (The Database Gateway)

### **ApplicationDbContext.cs** (Simple but Powerful)

```csharp
public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options) { }

    // YOUR BUSINESS ENTITIES
    public DbSet<Author> Authors { get; set; }
    public DbSet<Book> Books { get; set; }
    public DbSet<Category> Categories { get; set; }

    // Note: Order/OrderItem tables would go in OrderApi project

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder); // CRITICAL - Don't forget this!

        // Custom configurations would go here
        // builder.Entity<Book>().HasIndex(b => b.ISBN).IsUnique();
    }
}
```

**Key Points:**

- **Inherits from IdentityDbContext** → Gets user/role tables for free
- **DbSet properties** → Each becomes a database table
- **OnModelCreating** → Where you configure relationships/constraints

---

## ⚙️ **Program.cs Configuration** (Dependency Injection Setup)

### **Database Configuration**

```csharp
// Get connection string
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// Register DbContext
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));
```

### **Identity Configuration** (Authentication Setup)

```csharp
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(options => {
    // NO EMAIL CONFIRMATION required (for development)
    options.SignIn.RequireConfirmedAccount = false;

    // PASSWORD RULES
    options.Password.RequiredLength = 8;
    options.Password.RequireDigit = true;

    // EMAIL AS USERNAME
    options.User.RequireUniqueEmail = true;
})
.AddEntityFrameworkStores<ApplicationDbContext>() // Link to our DbContext
.AddDefaultTokenProviders();
```

### **Seed Data Execution**

```csharp
// After app.Run() setup, but before app.Run()
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    await SeedData.Initialize(services); // POPULATE INITIAL DATA
}
```

---

## 🌱 **Seed Data Strategy** (Critical for Exams)

### **The Seeding Order** (Dependencies Matter!)

```
1. Roles (Admin, Client)
2. Admin User
3. Categories (Independent)
4. Authors (Independent)
5. Books (Depends on Authors + Categories)
```

### **SeedData.Initialize Pattern**

```csharp
public static async Task Initialize(IServiceProvider serviceProvider)
{
    var roleManager = serviceProvider.GetRequiredService<RoleManager<IdentityRole>>();
    var userManager = serviceProvider.GetRequiredService<UserManager<ApplicationUser>>();
    var context = serviceProvider.GetRequiredService<ApplicationDbContext>();

    // 1. Create Roles
    string[] roleNames = { "Admin", "Client" };
    foreach (var roleName in roleNames)
    {
        if (!await roleManager.RoleExistsAsync(roleName))
        {
            await roleManager.CreateAsync(new IdentityRole(roleName));
        }
    }

    // 2. Create Admin User
    var adminEmail = "admin@bookhaven.com";
    var adminUser = await userManager.FindByEmailAsync(adminEmail);
    if (adminUser == null)
    {
        adminUser = new ApplicationUser
        {
            UserName = adminEmail,
            Email = adminEmail,
            EmailConfirmed = true
        };
        await userManager.CreateAsync(adminUser, "Admin123!");
        await userManager.AddToRoleAsync(adminUser, "Admin");
    }

    // 3. Seed Business Data
    await SeedCategories(context);
    await SeedAuthors(context);
    await SeedBooks(context);
}
```

### **Individual Seed Methods Pattern**

```csharp
private static async Task SeedCategories(ApplicationDbContext context)
{
    // CHECK IF DATA EXISTS (Prevent duplicates)
    if (await context.Categories.AnyAsync())
        return;

    var categories = new List<Category>
    {
        new Category { Name = "Fiction", DisplayOrder = 1, IsActive = true },
        new Category { Name = "Non-Fiction", DisplayOrder = 2, IsActive = true },
        // ... more categories
    };

    context.Categories.AddRange(categories);
    await context.SaveChangesAsync();
}
```

---

## ⚡ **Speed Reconstruction: Data Layer (20 mins)**

### **Step 1: Create DbContext (5 mins)**

```csharp
public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options) { }

    public DbSet<Book> Books { get; set; }
    public DbSet<Author> Authors { get; set; }
    public DbSet<Category> Categories { get; set; }
}
```

### **Step 2: Configure in Program.cs (5 mins)**

```csharp
// Add these services
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddIdentity<ApplicationUser, IdentityRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();
```

### **Step 3: Create Basic Seed Data (10 mins)**

```csharp
public static class SeedData
{
    public static async Task Initialize(IServiceProvider serviceProvider)
    {
        var context = serviceProvider.GetRequiredService<ApplicationDbContext>();

        // Seed categories first
        if (!context.Categories.Any())
        {
            context.Categories.AddRange(
                new Category { Name = "Fiction" },
                new Category { Name = "Non-Fiction" }
            );
            await context.SaveChangesAsync();
        }

        // Then authors
        if (!context.Authors.Any())
        {
            context.Authors.AddRange(
                new Author { FirstName = "John", LastName = "Doe" }
            );
            await context.SaveChangesAsync();
        }

        // Finally books (with relationships)
        if (!context.Books.Any())
        {
            var fiction = context.Categories.First(c => c.Name == "Fiction");
            var author = context.Authors.First();

            context.Books.Add(new Book
            {
                Title = "Sample Book",
                Price = 19.99m,
                AuthorId = author.Id,
                CategoryId = fiction.Id
            });
            await context.SaveChangesAsync();
        }
    }
}
```

---

## 🎯 **Key Patterns to Remember**

### **1. Service Registration Order**

```csharp
builder.Services.AddDbContext<ApplicationDbContext>(...);  // 1st
builder.Services.AddIdentity<ApplicationUser, IdentityRole>(...) // 2nd
    .AddEntityFrameworkStores<ApplicationDbContext>(); // Links to DbContext
```

### **2. Seed Data Guards**

```csharp
if (await context.Categories.AnyAsync()) // Check before seeding
    return; // Don't duplicate data
```

### **3. Relationship Seeding**

```csharp
// Get parent entities first
var fiction = context.Categories.First(c => c.Name == "Fiction");
var author = context.Authors.First(a => a.LastName == "Smith");

// Then create child with foreign keys
var book = new Book
{
    Title = "New Book",
    AuthorId = author.Id,    // Reference parent
    CategoryId = fiction.Id  // Reference parent
};
```

---

## 🚨 **Common Exam Mistakes**

### **1. Forgetting base.OnModelCreating()**

```csharp
// ❌ WRONG
protected override void OnModelCreating(ModelBuilder builder)
{
    // Custom configurations...
}

// ✅ CORRECT
protected override void OnModelCreating(ModelBuilder builder)
{
    base.OnModelCreating(builder); // DON'T FORGET THIS!
    // Custom configurations...
}
```

### **2. Wrong Seed Data Execution Location**

```csharp
// ❌ WRONG - Before app.Run()
using (var scope = app.Services.CreateScope()) { ... }
app.Run();

// ✅ CORRECT - After configuration, before app.Run()
app.UseAuthentication();
app.UseAuthorization();
// ... other middleware

using (var scope = app.Services.CreateScope()) { ... }
app.Run();
```

### **3. Circular Dependencies in Seeding**

```csharp
// ❌ WRONG - Books before Authors
await SeedBooks(context);
await SeedAuthors(context);

// ✅ CORRECT - Dependencies first
await SeedAuthors(context);
await SeedCategories(context);
await SeedBooks(context); // Books need Authors & Categories
```

---

## 🎓 **Connection String Examples**

### **Development (LocalDB)**

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=BookHavenDb;Trusted_Connection=true;MultipleActiveResultSets=true"
  }
}
```

### **Exam Environment (SQL Server Express)**

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.\\SQLEXPRESS;Database=BookHavenDb;Trusted_Connection=true;MultipleActiveResultSets=true"
  }
}
```

---

**Next**: [WALKTHROUGH_04_CONTROLLERS.md](./WALKTHROUGH_04_CONTROLLERS.md) - Where the magic happens: MVC Controllers

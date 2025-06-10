# 📚 WALKTHROUGH 02: Domain Models & Relationships

## 🎯 **Exam Focus**: Understanding Entity Relationships in 20 minutes

### **The Core Trinity** (Main Business Logic)

```
📖 Book (CENTER OF UNIVERSE)
├── 👤 Author (Many Books → One Author)
├── 📂 Category (Many Books → One Category)
└── 🛒 OrderItem (Books can be in multiple orders)
```

---

## 🔗 **Relationship Mapping** (CRITICAL FOR EXAMS)

### **1. Book Entity** (The Star of the Show)

```csharp
public class Book
{
    // Primary Key
    public int Id { get; set; }

    // Core Properties with VALIDATION
    [Required, StringLength(200, MinimumLength = 2)]
    public string Title { get; set; }

    [Range(0.01, 999.99)]
    public decimal Price { get; set; }

    // Foreign Keys (RELATIONSHIPS!)
    public int AuthorId { get; set; }    // → Links to Author
    public int CategoryId { get; set; }  // → Links to Category

    // Navigation Properties (HOW EF CONNECTS THEM)
    public virtual Author? Author { get; set; }           // → One Author
    public virtual Category? Category { get; set; }       // → One Category
    public virtual ICollection<OrderItem>? OrderItems { get; set; } // → Many Orders
}
```

### **2. Author Entity** (One-to-Many with Books)

```csharp
public class Author
{
    public int Id { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }

    // Navigation Property (REVERSE RELATIONSHIP)
    public virtual ICollection<Book>? Books { get; set; } // → Many Books

    // Computed Property (EXAM FAVORITE!)
    public string FullName => $"{FirstName} {LastName}";
}
```

### **3. Category Entity** (One-to-Many with Books)

```csharp
public class Category
{
    public int Id { get; set; }
    public string Name { get; set; }
    public int DisplayOrder { get; set; } // → For sorting

    // Navigation Property
    public virtual ICollection<Book>? Books { get; set; } // → Many Books
}
```

---

## 🛒 **Order System** (Complex Relationships)

### **The Order Triangle**

```
Customer → Order → OrderItem → Book
   ↑         ↑         ↑         ↑
  (1)      (1)       (M)       (1)
```

### **OrderItem: The Bridge Entity**

```csharp
public class OrderItem
{
    public int Id { get; set; }
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }

    // DUAL FOREIGN KEYS (Many-to-Many Bridge)
    public int OrderId { get; set; }   // → Links to Order
    public int BookId { get; set; }    // → Links to Book

    // DUAL NAVIGATION PROPERTIES
    public virtual Order? Order { get; set; }
    public virtual Book? Book { get; set; }

    // CALCULATED PROPERTY (Business Logic)
    public decimal LineTotal => Quantity * UnitPrice;
}
```

---

## ⚡ **Speed Coding: Model Creation Strategy**

### **Step 1: Create Base Models (10 mins)**

1. **Book** (with basic properties)
2. **Author** (with name fields)
3. **Category** (with name/description)

### **Step 2: Add Relationships (5 mins)**

```csharp
// In Book model
public int AuthorId { get; set; }
public int CategoryId { get; set; }
public virtual Author? Author { get; set; }
public virtual Category? Category { get; set; }

// In Author model
public virtual ICollection<Book>? Books { get; set; }

// In Category model
public virtual ICollection<Book>? Books { get; set; }
```

### **Step 3: Add Validation (5 mins)**

```csharp
[Required]
[StringLength(200, MinimumLength = 2)]
[Display(Name = "Book Title")]
[Range(0.01, 999.99)]
[DataType(DataType.Currency)]
```

---

## 🎯 **Key Patterns to Remember**

### **1. Foreign Key Convention**

```csharp
public int AuthorId { get; set; }        // → Foreign Key
public virtual Author? Author { get; set; } // → Navigation Property
```

**Memory Tip**: FK name = EntityName + "Id"

### **2. Collection Navigation**

```csharp
public virtual ICollection<Book>? Books { get; set; } // → One-to-Many
```

**Memory Tip**: "Parent" has collection of "Children"

### **3. Validation Patterns**

```csharp
[Required] // → Not null/empty
[StringLength(max, MinimumLength = min)] // → Length limits
[Range(min, max)] // → Numeric ranges
[Display(Name = "Display Text")] // → UI labels
[DataType(DataType.Currency)] // → Formatting hint
```

---

## 🚨 **Common Exam Mistakes**

### **1. Missing Virtual Keyword**

```csharp
// ❌ WRONG
public Author? Author { get; set; }

// ✅ CORRECT
public virtual Author? Author { get; set; }
```

### **2. Wrong Collection Type**

```csharp
// ❌ WRONG
public List<Book>? Books { get; set; }

// ✅ CORRECT
public virtual ICollection<Book>? Books { get; set; }
```

### **3. Forgetting Nullable Reference**

```csharp
// ❌ WRONG (in .NET 8)
public virtual Author Author { get; set; }

// ✅ CORRECT
public virtual Author? Author { get; set; }
```

---

## 📊 **Entity Relationship Diagram** (Mental Model)

```
    Author (1)
       ↓
    Book (M) ← Category (1)
       ↓
   OrderItem (M)
       ↓
    Order (1)
       ↓
   Customer (1)
```

**Translation**:

- One Author writes Many Books
- One Category contains Many Books
- One Book can be in Many OrderItems
- One Order contains Many OrderItems
- One Customer can have Many Orders

---

## 🎓 **Exam Transformation Examples**

### **Restaurant Example**

```csharp
Book → MenuItem
Author → Restaurant
Category → FoodType
Order → Order (same)
OrderItem → OrderItem (same)
```

### **Movie Example**

```csharp
Book → Movie
Author → Director
Category → Genre
Order → Rental
OrderItem → RentalItem
```

**Memory Tip**: The RELATIONSHIP PATTERNS stay the same!

---

**Next**: [WALKTHROUGH_03_DBCONTEXT.md](./WALKTHROUGH_03_DBCONTEXT.md) - How EF Core brings these models to life

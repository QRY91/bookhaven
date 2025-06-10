# 🗄️ Database Setup Guide

## ❗ FIXING THE NULLREFERENCEEXCEPTION

The error you're seeing happens because the database hasn't been created/updated yet. Follow these steps:

## 🔧 Quick Fix Steps

### 1. **Apply Database Migrations**

```powershell
# Navigate to the MVC project directory
cd "examinator\exam-prep\mock_exam\BookHaven_MultiProject_Example\BookHaven.MVC"

# Update the database (this will create it if it doesn't exist)
dotnet ef database update
```

### 2. **Verify Database Creation**

```powershell
# Check if the migration worked
dotnet ef database update --verbose
```

### 3. **If you get EF Tools error:**

```powershell
# Install EF Tools globally
dotnet tool install --global dotnet-ef

# Then try again
dotnet ef database update
```

## 🧪 Test the Fix

1. **Restart the application:**

   ```powershell
   dotnet run --launch-profile "BookHaven.MVC"
   ```

2. **Navigate to:** `https://localhost:7234/Books`

3. **You should now see:**
   - ✅ 5 seeded books (Harry Potter, The Shining, Good Omens, Foundation, Murder on Orient Express)
   - ✅ No more NullReferenceException
   - ✅ Search and filter functionality working

## 📊 Expected Database Contents

After successful migration, your database should contain:

| Table          | Records | Sample Data                                                                 |
| -------------- | ------- | --------------------------------------------------------------------------- |
| **Books**      | 5       | Harry Potter, The Shining, Good Omens, Foundation, Murder on Orient Express |
| **Authors**    | 5       | J.K. Rowling, Stephen King, Neil Gaiman, Isaac Asimov, Agatha Christie      |
| **Categories** | 5       | Fiction, Non-Fiction, Science, History, Biography                           |

## 🚨 If Still Getting Errors

### **Option A: Reset Database**

```powershell
# Drop and recreate database
dotnet ef database drop
dotnet ef database update
```

### **Option B: Manual Verification**

```sql
-- Connect to SQL Server and check:
-- Server: (localdb)\mssqllocaldb
-- Database: BookHavenMvcDb

SELECT COUNT(*) as BookCount FROM Books;
SELECT COUNT(*) as AuthorCount FROM Authors;
SELECT COUNT(*) as CategoryCount FROM Categories;
```

### **Option C: Check Connection String**

If LocalDB isn't working, update `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.\\SQLEXPRESS;Database=BookHavenMvcDb;Trusted_Connection=true;MultipleActiveResultSets=true"
  }
}
```

## ✅ Success Indicators

When everything is working correctly:

- ✅ Books page loads without errors
- ✅ You see 5 books in the table
- ✅ Search/filter dropdowns are populated
- ✅ Authors and Categories pages work
- ✅ CRUD operations function properly

## 💡 What Was Fixed

1. **View Issue**: Fixed category dropdown casting issue
2. **Controller**: Added null-safe navigation properties
3. **Error Handling**: Added empty state handling
4. **Price Filtering**: Added missing price filter parameters

The main issue was that Entity Framework hadn't created the database yet, so all queries were returning null/empty results, causing the NullReferenceException in the view.

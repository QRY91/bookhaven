# 🧠 HANDS-ON STUDY CHALLENGES

**Perfect for exam prep!** Each challenge takes 5-15 minutes and helps you understand **how and why** the code works.

---

## 🎯 **CHALLENGE SET 1: MODEL DETECTIVE** (30 mins)

### **Challenge 1.1: Relationship Hunter** ⏱️ 5 mins

**Question**: How does EF Core know that a Book belongs to an Author?

**Your Mission**:

1. Open `BookHaven.Shared/Models/Book.cs`
2. Find the TWO properties that create the Author relationship
3. **Modify**: Change `AuthorId` to `WriterId`
4. **Predict**: What will break? Where will you see errors?
5. **Test**: Run the app and see if you were right!
6. **Revert**: Change it back and understand WHY it worked

**Key Learning**: Navigation properties vs Foreign keys

---

### **Challenge 1.2: Validation Bypass** ⏱️ 10 mins

**Question**: What happens if you remove ALL validation from Book.Title?

**Your Mission**:

1. Find the validation attributes on `Book.Title`
2. **Comment them out**: `// [Required]`, `// [StringLength(200)]`
3. **Predict**: Can you create a book with no title? 200+ character title?
4. **Test**: Try creating a book through the UI
5. **Explore**: Check the Create form - does client-side validation still work?
6. **Investigate**: Why does/doesn't it work?

**Bonus**: Where else is validation happening? (Hint: Look at the view)

---

### **Challenge 1.3: Price Manipulation** ⏱️ 10 mins

**Question**: How would you make all books cost at least $5.00?

**Your Mission**:

1. Add a custom validation to `Book.Price`
2. **Try**: `[Range(5.00, 1000.00, ErrorMessage = "Price must be between $5 and $1000")]`
3. **Test**: Try creating a cheap book
4. **Explore**: What happens in the Blazor admin vs MVC create form?
5. **Investigate**: Why do both respect the same validation?

**Key Learning**: Data Annotations work across the entire app

---

## 🎯 **CHALLENGE SET 2: CONTROLLER ARCHAEOLOGY** (45 mins)

### **Challenge 2.1: The Include Mystery** ⏱️ 15 mins

**Question**: Why do some queries use `.Include()` and others don't?

**Your Mission**:

1. Open `BooksController.cs` and find the `Index` action
2. **Find**: The `.Include(b => b.Author).Include(b => b.Category)` line
3. **Experiment**: Comment out `.Include(b => b.Author)`
4. **Predict**: What will happen to the book list?
5. **Test**: Run and see the Author column
6. **Investigate**: Why are categories still showing?

**Deep Dive**: Find another controller method that DOESN'T use Include. Why not?

---

### **Challenge 2.2: ViewBag Detective** ⏱️ 15 mins

**Question**: How does the Create form get its dropdown lists?

**Your Mission**:

1. Find the `Create GET` action in `BooksController`
2. **Trace**: Follow `ViewBag.AuthorId` - where does it come from?
3. **Experiment**: Change `ViewBag.AuthorId` to `ViewBag.Writers`
4. **Predict**: What will break in the Create view?
5. **Fix**: Update the view to use the new ViewBag name
6. **Test**: Does the dropdown still work?

**Bonus**: Why use ViewBag instead of ViewData? What's the difference?

---

### **Challenge 2.3: POST-Redirect-GET Hunt** ⏱️ 15 mins

**Question**: What prevents duplicate form submissions?

**Your Mission**:

1. Find the `Create POST` action in `BooksController`
2. **Identify**: The redirect line `return RedirectToAction(nameof(Index))`
3. **Experiment**: Change it to `return View(book)`
4. **Predict**: What happens if you refresh the page after creating a book?
5. **Test**: Create a book, then hit F5. How many books get created?
6. **Revert**: Put the redirect back

**Key Learning**: PRG (Post-Redirect-Get) pattern prevents duplicate submissions

---

## 🎯 **CHALLENGE SET 3: VIEW FORENSICS** (30 mins)

### **Challenge 3.1: Tag Helper Hunt** ⏱️ 10 mins

**Question**: How do forms know which action to post to?

**Your Mission**:

1. Open `Views/Books/Create.cshtml`
2. **Find**: `asp-controller` and `asp-action` attributes
3. **Experiment**: Change `asp-action="Create"` to `asp-action="Store"`
4. **Predict**: What error will you get?
5. **Test**: Try submitting the form
6. **Investigate**: Look at the generated HTML (View Source)

**Bonus**: What URL does the form actually post to?

---

### **Challenge 3.2: Validation Message Mystery** ⏱️ 10 mins

**Question**: How do validation messages appear without page refresh?

**Your Mission**:

1. Look at the Create form's `@section Scripts`
2. **Find**: The validation scripts being loaded
3. **Experiment**: Comment out the Scripts section
4. **Test**: Try submitting invalid data
5. **Compare**: Server-side vs client-side validation

**Investigation**: Which validation happens first? Why?

---

### **Challenge 3.3: Layout Detective** ⏱️ 10 mins

**Question**: How does the navigation bar know if you're logged in?

**Your Mission**:

1. Open `Views/Shared/_Layout.cshtml`
2. **Find**: The `@if (User.IsInRole("Admin"))` section
3. **Experiment**: Change it to show for all users: `@if (true)`
4. **Test**: See the admin link when not logged in
5. **Click it**: What happens? Why?

**Deep Dive**: Where is the `User` object coming from?

---

## 🎯 **CHALLENGE SET 4: DATABASE DETECTIVE** (20 mins)

### **Challenge 4.1: Seed Data Hunt** ⏱️ 10 mins

**Question**: How does the app get its initial data?

**Your Mission**:

1. Find `SeedData.cs` in the Data folder
2. **Trace**: How is it called? (Hint: Check Program.cs)
3. **Experiment**: Add a new book to the seed data
4. **Predict**: When will it appear in the app?
5. **Test**: Delete the database and restart

**Investigation**: Why check `context.Books.Any()` before seeding?

---

### **Challenge 4.2: Connection String Hunt** ⏱️ 10 mins

**Question**: How does the app know which database to use?

**Your Mission**:

1. Find the connection string in `appsettings.json`
2. **Trace**: How is it used in Program.cs?
3. **Experiment**: Change the database name to "BookHavenTest"
4. **Predict**: What will happen when you run the app?
5. **Test**: Will your data still be there?

**Key Learning**: Each database name creates a separate database file

---

## 🎯 **CHALLENGE SET 5: BLAZOR EXPLORATION** (25 mins)

### **Challenge 5.1: Component State Hunt** ⏱️ 15 mins

**Question**: How does the BookManager component track which book you're editing?

**Your Mission**:

1. Open `Blazor/Admin/BookManager.razor`
2. **Find**: The `editingBook` variable
3. **Trace**: How does clicking "Edit" populate this variable?
4. **Experiment**: Add a debug line: `<p>Editing: @editingBook.Title</p>`
5. **Test**: Click edit and watch the debug info

**Investigation**: Why create a new Book object instead of editing directly?

---

### **Challenge 5.2: Modal Mystery** ⏱️ 10 mins

**Question**: How does the modal appear and disappear?

**Your Mission**:

1. Find the `@if (showBookForm)` section
2. **Trace**: What sets `showBookForm` to true/false?
3. **Experiment**: Set `showBookForm = true` in OnInitializedAsync
4. **Predict**: What will you see when the page loads?
5. **Test**: Refresh the admin page

**Bonus**: How is this different from JavaScript modals?

---

## 🎯 **CHALLENGE SET 6: API ADVENTURE** (20 mins)

### **Challenge 6.1: HTTP Client Hunt** ⏱️ 10 mins

**Question**: How does the MVC app know where to find the API?

**Your Mission**:

1. Find the HttpClient configuration in `Program.cs`
2. **Experiment**: Change the base URL to `https://localhost:9999/`
3. **Predict**: What will happen to the stock check?
4. **Test**: Click the "Test Stock API" button
5. **Investigate**: Check the browser's Network tab (F12)

**Key Learning**: HttpClient dependency injection and base URLs

---

### **Challenge 6.2: JSON Serialization Hunt** ⏱️ 10 mins

**Question**: How does JSON from the API become C# objects?

**Your Mission**:

1. Look at `StockService.cs` JsonSerializer.Deserialize line
2. **Experiment**: Remove `PropertyNameCaseInsensitive = true`
3. **Predict**: Will the API still work?
4. **Test**: Check the stock API button
5. **Investigate**: Compare API JSON with StockInfo class property names

**Key Learning**: Case sensitivity in JSON deserialization

---

## 🎯 **EXAM SIMULATION CHALLENGES** (30 mins)

### **Challenge 7.1: Quick Transformation** ⏱️ 15 mins

**Transform BookHaven into LibrarySystem**:

1. Change "Books" to "Items" in one controller
2. Change "Authors" to "Creators" in the navigation
3. Add a "LibraryCard" property to ApplicationUser
4. **Question**: What breaks? What still works? Why?

### **Challenge 7.2: Speed CRUD** ⏱️ 15 mins

**Add a Publisher entity**:

1. Create the model (3 properties max)
2. Add to ApplicationDbContext
3. Create a basic controller with Index and Create
4. **Time yourself**: How fast can you do basic CRUD?

---

## 📝 **REFLECTION QUESTIONS**

After each challenge set, ask yourself:

- **What pattern did I just explore?**
- **Where else in the app does this pattern appear?**
- **How would I explain this to someone else?**
- **What would break if I removed this piece?**
- **How does this help in an exam scenario?**

**Remember**: Understanding WHY something works is more valuable than memorizing HOW it works! 🧠

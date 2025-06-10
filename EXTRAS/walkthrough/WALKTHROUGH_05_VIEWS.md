# 🎨 WALKTHROUGH 05: Razor Views & UI Patterns

## 🎯 **Exam Focus**: View Structure & Form Patterns in 20 minutes

### **The View Hierarchy** (How UI is Organized)

```
Views/
├── 📁 Shared/                  # Common components
│   ├── _Layout.cshtml         # → Master template (header/footer/nav)
│   ├── _LoginPartial.cshtml   # → Authentication widget
│   └── _ValidationScriptsPartial.cshtml # → Client validation
│
├── 📁 Books/                  # Book-specific views
│   ├── Index.cshtml          # → List + Search/Filter (COMPLEX)
│   ├── Create.cshtml         # → Form for new books
│   ├── Edit.cshtml           # → Form for editing
│   ├── Details.cshtml        # → Read-only view
│   └── Delete.cshtml         # → Confirmation page
│
├── 📁 Authors/               # Standard CRUD views
├── 📁 Categories/            # Simple CRUD views
└── 📁 Home/                  # Landing pages
```

---

## 🏗️ **Layout Structure** (The Foundation)

### **\_Layout.cshtml** (Master Template)

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>@ViewData["Title"] - BookHaven</title>
    <!-- Bootstrap CSS -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css"
    />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
    />
  </head>
  <body>
    <header>
      <nav class="navbar navbar-expand-sm navbar-light bg-white">
        <div class="container-fluid">
          <a class="navbar-brand" asp-controller="Home" asp-action="Index"
            >📚 BookHaven</a
          >

          <!-- Navigation Menu -->
          <ul class="navbar-nav">
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                <i class="bi bi-book"></i> Catalog
              </a>
              <ul class="dropdown-menu">
                <li>
                  <a
                    class="dropdown-item"
                    asp-controller="Books"
                    asp-action="Index"
                    >Books</a
                  >
                </li>
                <li>
                  <a
                    class="dropdown-item"
                    asp-controller="Authors"
                    asp-action="Index"
                    >Authors</a
                  >
                </li>
                <li>
                  <a
                    class="dropdown-item"
                    asp-controller="Categories"
                    asp-action="Index"
                    >Categories</a
                  >
                </li>
              </ul>
            </li>
          </ul>

          <!-- Login/Logout Partial -->
          <partial name="_LoginPartial" />
        </div>
      </nav>
    </header>

    <div class="container">
      <main role="main" class="pb-3">
        @RenderBody()
        <!-- VIEW CONTENT GOES HERE -->
      </main>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js"></script>
    @await RenderSectionAsync("Scripts", required: false)
  </body>
</html>
```

**Key Points:**

- **@ViewData["Title"]** → Sets page title dynamically
- **asp-controller/asp-action** → ASP.NET Core tag helpers for navigation
- **@RenderBody()** → Where individual view content appears
- **@RenderSectionAsync("Scripts")** → Page-specific JavaScript

---

## 📝 **Create/Edit Forms** (The Bread & Butter)

### **Books/Create.cshtml** (Form Patterns)

```html
@model BookHaven.Shared.Models.Book @{ ViewData["Title"] = "Create Book"; }

<div class="container mt-4">
  <h2 class="mb-4">📖 Create New Book</h2>

  <div class="card">
    <div class="card-body">
      <form asp-action="Create">
        <!-- VALIDATION SUMMARY -->
        <div asp-validation-summary="ModelOnly" class="text-danger mb-3"></div>

        <!-- BASIC FIELDS -->
        <div class="row">
          <div class="col-md-6">
            <div class="form-group mb-3">
              <label asp-for="Title" class="form-label"></label>
              <input asp-for="Title" class="form-control" />
              <span asp-validation-for="Title" class="text-danger"></span>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-group mb-3">
              <label asp-for="ISBN" class="form-label"></label>
              <input asp-for="ISBN" class="form-control" />
              <span asp-validation-for="ISBN" class="text-danger"></span>
            </div>
          </div>
        </div>

        <!-- DROPDOWNS (Foreign Keys) -->
        <div class="row">
          <div class="col-md-6">
            <div class="form-group mb-3">
              <label asp-for="AuthorId" class="form-label"></label>
              <select
                asp-for="AuthorId"
                class="form-select"
                asp-items="ViewBag.AuthorId"
              >
                <option value="">-- Select Author --</option>
              </select>
              <span asp-validation-for="AuthorId" class="text-danger"></span>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-group mb-3">
              <label asp-for="CategoryId" class="form-label"></label>
              <select
                asp-for="CategoryId"
                class="form-select"
                asp-items="ViewBag.CategoryId"
              >
                <option value="">-- Select Category --</option>
              </select>
              <span asp-validation-for="CategoryId" class="text-danger"></span>
            </div>
          </div>
        </div>

        <!-- SPECIALIZED INPUTS -->
        <div class="row">
          <div class="col-md-4">
            <div class="form-group mb-3">
              <label asp-for="Price" class="form-label"></label>
              <input
                asp-for="Price"
                class="form-control"
                type="number"
                step="0.01"
              />
              <span asp-validation-for="Price" class="text-danger"></span>
            </div>
          </div>
          <div class="col-md-4">
            <div class="form-group mb-3">
              <label asp-for="PublishedDate" class="form-label"></label>
              <input asp-for="PublishedDate" class="form-control" type="date" />
              <span
                asp-validation-for="PublishedDate"
                class="text-danger"
              ></span>
            </div>
          </div>
          <div class="col-md-4">
            <div class="form-check mt-4">
              <input
                asp-for="IsActive"
                class="form-check-input"
                type="checkbox"
                checked
              />
              <label asp-for="IsActive" class="form-check-label"></label>
            </div>
          </div>
        </div>

        <!-- SUBMIT BUTTONS -->
        <div class="form-group mt-4">
          <input
            type="submit"
            value="Create Book"
            class="btn btn-primary me-2"
          />
          <a asp-action="Index" class="btn btn-secondary">Back to List</a>
        </div>
      </form>
    </div>
  </div>
</div>

@section Scripts { @{await
Html.RenderPartialAsync("_ValidationScriptsPartial");} }
```

---

## 🎯 **Key View Patterns to Master**

### **1. Tag Helpers**

```html
<!-- Form Controls -->
<input asp-for="PropertyName" class="form-control" />
<select asp-for="PropertyName" asp-items="ViewBag.SelectList" />
<textarea asp-for="PropertyName" rows="3" />

<!-- Navigation -->
<a asp-controller="Books" asp-action="Index">Books</a>
<a asp-action="Edit" asp-route-id="@item.Id">Edit</a>

<!-- Validation -->
<span asp-validation-for="PropertyName" class="text-danger"></span>
<div asp-validation-summary="ModelOnly" class="text-danger"></div>
```

### **2. ViewBag/ViewData Usage**

```html
<!-- In Controller -->
ViewBag.Categories = new SelectList(categories, "Id", "Name");
ViewBag.CurrentSearch = searchString;

<!-- In View -->
<select asp-items="ViewBag.Categories" />
<input value="@ViewBag.CurrentSearch" />
<h2>@ViewData["Title"]</h2>
```

---

## 🚨 **Common Exam Mistakes**

### **1. Missing Scripts Section**

```html
<!-- ❌ WRONG - No client validation -->
<form asp-action="Create">
  <!-- form fields -->
</form>

<!-- ✅ CORRECT - Include validation scripts -->
<form asp-action="Create">
  <!-- form fields -->
</form>

@section Scripts { @{await
Html.RenderPartialAsync("_ValidationScriptsPartial");} }
```

### **2. Missing Null Checks**

```html
<!-- ❌ WRONG - Will crash if Author is null -->
<td>@item.Author.FullName</td>

<!-- ✅ CORRECT - Safe navigation -->
<td>@(item.Author?.FullName ?? "Unknown Author")</td>
```

---

**Next**: [WALKTHROUGH_06_AUTH.md](./WALKTHROUGH_06_AUTH.md) - Authentication and authorization patterns

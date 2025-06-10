# 🔌 WALKTHROUGH 08: Simple API Integration

## 🎯 **Goal**: Connect MVC app to API using HttpClient

### **Architecture** (Simple & Clean)

```
MVC App (Port 7234)          API Service (Port 7001)
├── StockService             ├── StockController
├── HttpClient  ──────────>  ├── GET /api/stock/check/{id}
└── Controllers              └── GET /api/stock/status
```

**Perfect for exams** - demonstrates HTTP client integration without complexity!

---

## ⚡ **Implementation Steps** (15 minutes)

### **Step 1: Create API Controller** (5 mins)

**In `OrderApi/Controllers/StockController.cs`:**

```csharp
[ApiController]
[Route("api/[controller]")]
public class StockController : ControllerBase
{
    [HttpGet("check/{bookId}")]
    public ActionResult<object> CheckStock(int bookId)
    {
        // Simple demo logic
        var random = new Random();
        var stockLevel = random.Next(0, 50);

        return Ok(new
        {
            BookId = bookId,
            StockLevel = stockLevel,
            IsInStock = stockLevel > 0,
            Status = stockLevel > 10 ? "High" : stockLevel > 0 ? "Low" : "Out of Stock"
        });
    }
}
```

### **Step 2: Create Service Interface** (3 mins)

**In `MVC/Services/IStockService.cs`:**

```csharp
public interface IStockService
{
    Task<StockInfo?> CheckStockAsync(int bookId);
    Task<bool> IsApiOnlineAsync();
}

public class StockInfo
{
    public int BookId { get; set; }
    public int StockLevel { get; set; }
    public bool IsInStock { get; set; }
    public string Status { get; set; } = string.Empty;
}
```

### **Step 3: Implement Service** (5 mins)

**In `MVC/Services/StockService.cs`:**

```csharp
public class StockService : IStockService
{
    private readonly HttpClient _httpClient;

    public StockService(HttpClient httpClient)
    {
        _httpClient = httpClient;
    }

    public async Task<StockInfo?> CheckStockAsync(int bookId)
    {
        try
        {
            var response = await _httpClient.GetAsync($"api/stock/check/{bookId}");

            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                return JsonSerializer.Deserialize<StockInfo>(json, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });
            }
            return null;
        }
        catch
        {
            return null; // Handle gracefully
        }
    }
}
```

### **Step 4: Configure HttpClient** (2 mins)

**In `Program.cs`:**

```csharp
// Add HttpClient for API integration
builder.Services.AddHttpClient<IStockService, StockService>(client =>
{
    client.BaseAddress = new Uri("https://localhost:7001/"); // API URL
    client.Timeout = TimeSpan.FromSeconds(10);
});
```

---

## 🎮 **Usage Examples**

### **In Controller:**

```csharp
public class HomeController : Controller
{
    private readonly IStockService _stockService;

    public HomeController(IStockService stockService)
    {
        _stockService = stockService;
    }

    public async Task<IActionResult> CheckStock(int bookId)
    {
        var stockInfo = await _stockService.CheckStockAsync(bookId);
        return Json(stockInfo);
    }
}
```

### **In View (JavaScript):**

```javascript
async function testApi() {
  const response = await fetch("/Home/CheckStock?bookId=1");
  const data = await response.json();
  console.log(data); // Display stock info
}
```

---

## 🔧 **Testing Your Integration**

### **Run Both Projects:**

```bash
# Terminal 1: Start API
cd BookHaven.OrderApi
dotnet run

# Terminal 2: Start MVC
cd BookHaven.MVC
dotnet run
```

### **Test Points:**

1. **Home page** - shows API status (🟢 Online/🔴 Offline)
2. **Test button** - click "🔌 Test Stock API"
3. **API endpoint** - visit `https://localhost:7001/api/stock/check/1`
4. **Swagger** - `https://localhost:7001/swagger` (if configured)

---

## 🎯 **Key Patterns for Exams**

### **HttpClient Registration:**

```csharp
// Simple
builder.Services.AddHttpClient<IService, Service>(client => {
    client.BaseAddress = new Uri("https://api-url/");
});
```

### **API Call Pattern:**

```csharp
var response = await _httpClient.GetAsync("endpoint");
if (response.IsSuccessStatusCode) {
    var json = await response.Content.ReadAsStringAsync();
    return JsonSerializer.Deserialize<T>(json);
}
```

### **Error Handling:**

```csharp
try {
    // API call
} catch (HttpRequestException) {
    // Network error
} catch (TaskCanceledException) {
    // Timeout
}
```

---

## 🚀 **What This Demonstrates**

✅ **HttpClient dependency injection**  
✅ **Service pattern** for API integration  
✅ **JSON serialization/deserialization**  
✅ **Async/await patterns**  
✅ **Error handling** for network calls  
✅ **Multi-project communication**

**Perfect for exam scenarios** - shows you understand modern .NET API integration! 🎯

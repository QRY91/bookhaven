using Microsoft.AspNetCore.Mvc;

namespace BookHaven.OrderApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class StockController : ControllerBase
{
    [HttpGet("check/{bookId}")]
    public ActionResult<object> CheckStock(int bookId)
    {
        // Consistent stock per book (seeded by book ID)
        var random = new Random(bookId * 42);
        var stockLevel = random.Next(0, 50);
        var isInStock = stockLevel > 0;
        
        return Ok(new
        {
            BookId = bookId,
            StockLevel = stockLevel,
            IsInStock = isInStock,
            Status = stockLevel > 10 ? "High" : stockLevel > 0 ? "Low" : "Out of Stock",
            LastChecked = DateTime.UtcNow
        });
    }

    [HttpGet("status")]
    public ActionResult<object> GetApiStatus()
    {
        return Ok(new
        {
            Service = "BookHaven Stock API",
            Status = "Online",
            Version = "1.0.0",
            Endpoints = new[]
            {
                "GET /api/stock/check/{bookId} - Check stock for a book",
                "GET /api/stock/status - API health check"
            },
            Timestamp = DateTime.UtcNow
        });
    }
} 
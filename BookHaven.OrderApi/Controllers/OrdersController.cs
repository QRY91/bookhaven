using Microsoft.AspNetCore.Mvc;
using BookHaven.Shared.DTOs;

namespace BookHaven.OrderApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    [HttpGet]
    public ActionResult<IEnumerable<string>> Get()
    {
        return Ok(new[] { "Demo Order 1", "Demo Order 2", "Demo Order 3" });
    }

    [HttpGet("{id}")]
    public ActionResult<string> Get(int id)
    {
        return Ok($"Order {id} details");
    }

    [HttpPost]
    public ActionResult<OrderResponse> Create([FromBody] CreateOrderRequest request)
    {
        // Demo implementation
        return Ok(new OrderResponse
        {
            Success = true,
            Message = "Order created successfully (demo)",
            OrderId = new Random().Next(1000, 9999)
        });
    }

    [HttpGet("status")]
    public ActionResult<object> GetStatus()
    {
        return Ok(new
        {
            Service = "BookHaven.OrderApi",
            Status = "Running",
            Version = "1.0.0",
            Timestamp = DateTime.UtcNow,
            Port = 7001
        });
    }
} 
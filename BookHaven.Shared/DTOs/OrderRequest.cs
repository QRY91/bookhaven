namespace BookHaven.Shared.DTOs;

public class CreateOrderRequest
{
    public string CustomerId { get; set; } = string.Empty;
    public List<OrderItemDto> Items { get; set; } = new();
}

public class OrderItemDto
{
    public int BookId { get; set; }
    public int Quantity { get; set; }
    public decimal Price { get; set; }
}

public class OrderResponse
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public int? OrderId { get; set; }
    public List<string> Errors { get; set; } = new();
} 
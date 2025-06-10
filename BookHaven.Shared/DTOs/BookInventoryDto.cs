namespace BookHaven.Shared.DTOs;

public class BookInventoryDto
{
    public int BookId { get; set; }
    public string Title { get; set; } = string.Empty;
    public int StockQuantity { get; set; }
    public decimal Price { get; set; }
    public bool IsAvailable { get; set; }
}

public class UpdateInventoryRequest
{
    public int BookId { get; set; }
    public int Quantity { get; set; }
    public string Operation { get; set; } = string.Empty; // "add", "remove", "set"
}

public class InventoryResponse
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public BookInventoryDto? UpdatedItem { get; set; }
    public List<string> Errors { get; set; } = new();
} 
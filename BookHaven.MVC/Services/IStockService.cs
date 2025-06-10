namespace BookHaven.MVC.Services;

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
    public DateTime LastChecked { get; set; }
} 
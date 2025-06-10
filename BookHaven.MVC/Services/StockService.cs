using System.Text.Json;

namespace BookHaven.MVC.Services;

public class StockService : IStockService
{
    private readonly HttpClient _httpClient;
    private readonly ILogger<StockService> _logger;

    public StockService(HttpClient httpClient, ILogger<StockService> logger)
    {
        _httpClient = httpClient;
        _logger = logger;
    }

    public async Task<StockInfo?> CheckStockAsync(int bookId)
    {
        try
        {
            _logger.LogInformation("Checking stock for book ID: {BookId}", bookId);
            
            var response = await _httpClient.GetAsync($"api/stock/check/{bookId}");
            
            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                var stockData = JsonSerializer.Deserialize<StockInfo>(json, new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });
                
                _logger.LogInformation("Stock check successful for book ID {BookId}: {Status}", bookId, stockData?.Status);
                return stockData;
            }
            else
            {
                _logger.LogWarning("Stock API returned error for book ID {BookId}: {StatusCode}", bookId, response.StatusCode);
                return null;
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error checking stock for book ID {BookId}", bookId);
            return null;
        }
    }

    public async Task<bool> IsApiOnlineAsync()
    {
        try
        {
            var response = await _httpClient.GetAsync("api/stock/status");
            return response.IsSuccessStatusCode;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error checking API status");
            return false;
        }
    }
} 
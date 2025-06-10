using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using BookHaven.Shared.Models;
using BookHaven.MVC.Services;

namespace BookHaven.MVC.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;
    private readonly IStockService _stockService;

    public HomeController(ILogger<HomeController> logger, IStockService stockService)
    {
        _logger = logger;
        _stockService = stockService;
    }

    public async Task<IActionResult> Index()
    {
        ViewBag.Title = "BookHaven Multi-Project Demo";
        ViewBag.ApiUrl = "https://localhost:7001/swagger";
        ViewBag.IdentityUrl = "https://localhost:6001";
        
        // Demo API integration - check if our Stock API is online
        ViewBag.ApiStatus = await _stockService.IsApiOnlineAsync() ? "🟢 Online" : "🔴 Offline";
        
        return View();
    }

    // API Demo endpoint
    [HttpGet]
    public async Task<IActionResult> CheckStock(int bookId = 1)
    {
        var stockInfo = await _stockService.CheckStockAsync(bookId);
        return Json(stockInfo);
    }

    public IActionResult Privacy()
    {
        return View();
    }

    [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
    public IActionResult Error()
    {
        return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
    }
} 
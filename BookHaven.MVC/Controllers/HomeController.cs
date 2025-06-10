using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using BookHaven.Shared.Models;

namespace BookHaven.MVC.Controllers;

public class HomeController : Controller
{
    private readonly ILogger<HomeController> _logger;

    public HomeController(ILogger<HomeController> logger)
    {
        _logger = logger;
    }

    public IActionResult Index()
    {
        ViewBag.Title = "BookHaven Multi-Project Demo";
        ViewBag.ApiUrl = "https://localhost:7001/swagger";
        ViewBag.IdentityUrl = "https://localhost:6001";
        return View();
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
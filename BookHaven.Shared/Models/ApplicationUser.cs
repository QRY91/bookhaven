using Microsoft.AspNetCore.Identity;

namespace BookHaven.Shared.Models;

public class ApplicationUser : IdentityUser
{
    // Add any custom properties here if needed
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
} 
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using BookHaven.Shared.Models;

namespace BookHaven.MVC.Data;

public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
        // Customize the ASP.NET Identity model and override the defaults if needed.
        // For example, you can rename the ASP.NET Identity table names and more.
        // Add your customizations after calling base.OnModelCreating(builder);
        // Add any custom model configurations here
    }

    public DbSet<Author> Authors { get; set; }
    public DbSet<Book> Books { get; set; }
    public DbSet<Category> Categories { get; set; }
} 
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using BookHaven.Shared.Models;

namespace BookHaven.MVC.Data;

public static class SeedData
{
    public static async Task Initialize(IServiceProvider serviceProvider)
    {
        var roleManager = serviceProvider.GetRequiredService<RoleManager<IdentityRole>>();
        var userManager = serviceProvider.GetRequiredService<UserManager<ApplicationUser>>();
        var context = serviceProvider.GetRequiredService<ApplicationDbContext>();

        // Create roles
        string[] roleNames = { "Admin", "Client" };
        foreach (var roleName in roleNames)
        {
            if (!await roleManager.RoleExistsAsync(roleName))
            {
                await roleManager.CreateAsync(new IdentityRole(roleName));
            }
        }

        // Create admin user
        var adminEmail = "admin@bookhaven.com";
        var adminUser = await userManager.FindByEmailAsync(adminEmail);

        if (adminUser == null)
        {
            adminUser = new ApplicationUser
            {
                UserName = adminEmail, // Use email as username
                Email = adminEmail,
                EmailConfirmed = true,
                FirstName = "Admin",
                LastName = "User"
            };

            var result = await userManager.CreateAsync(adminUser, "Admin123!");
            if (result.Succeeded)
            {
                await userManager.AddToRoleAsync(adminUser, "Admin");
                Console.WriteLine("Admin user created successfully!");
            }
            else
            {
                Console.WriteLine("Failed to create admin user:");
                foreach (var error in result.Errors)
                {
                    Console.WriteLine($"- {error.Description}");
                }
            }
        }
        else
        {
            Console.WriteLine("Admin user already exists.");
        }

        // Seed Categories
        await SeedCategories(context);
        
        // Seed Authors  
        await SeedAuthors(context);
        
        // Seed Books
        await SeedBooks(context);
    }

    private static async Task SeedCategories(ApplicationDbContext context)
    {
        if (await context.Categories.AnyAsync()) 
        {
            Console.WriteLine("Categories already exist.");
            return;
        }

        var categories = new List<Category>
        {
            new Category 
            { 
                Name = "Fiction", 
                Description = "Fictional literature including novels and short stories", 
                DisplayOrder = 1, 
                IsActive = true 
            },
            new Category 
            { 
                Name = "Non-Fiction", 
                Description = "Factual books including biographies, history, and educational content", 
                DisplayOrder = 2, 
                IsActive = true 
            },
            new Category 
            { 
                Name = "Science", 
                Description = "Scientific literature including research and popular science", 
                DisplayOrder = 3, 
                IsActive = true 
            },
            new Category 
            { 
                Name = "History", 
                Description = "Historical accounts, biographies, and historical analysis", 
                DisplayOrder = 4, 
                IsActive = true 
            },
            new Category 
            { 
                Name = "Biography", 
                Description = "Life stories of notable individuals", 
                DisplayOrder = 5, 
                IsActive = true 
            }
        };

        context.Categories.AddRange(categories);
        await context.SaveChangesAsync();
        Console.WriteLine("Categories seeded successfully!");
    }

    private static async Task SeedAuthors(ApplicationDbContext context)
    {
        if (await context.Authors.AnyAsync()) 
        {
            Console.WriteLine("Authors already exist.");
            return;
        }

        var authors = new List<Author>
        {
            new Author 
            { 
                FirstName = "J.K.", 
                LastName = "Rowling", 
                Biography = "British author best known for the Harry Potter fantasy series.",
                BirthDate = new DateTime(1965, 7, 31),
                Email = "contact@jkrowling.com",
                Website = "https://www.jkrowling.com"
            },
            new Author 
            { 
                FirstName = "Stephen", 
                LastName = "King", 
                Biography = "American author of horror, supernatural fiction, suspense, crime, science-fiction, and fantasy novels.",
                BirthDate = new DateTime(1947, 9, 21),
                Email = "contact@stephenking.com",
                Website = "https://stephenking.com"
            },
            new Author 
            { 
                FirstName = "Neil", 
                LastName = "Gaiman", 
                Biography = "English author of short fiction, novels, comic books, graphic novels, audio theatre, and films.",
                BirthDate = new DateTime(1960, 11, 10),
                Email = "contact@neilgaiman.com",
                Website = "https://www.neilgaiman.com"
            },
            new Author 
            { 
                FirstName = "Isaac", 
                LastName = "Asimov", 
                Biography = "American writer and professor of biochemistry, best known for his works of science fiction.",
                BirthDate = new DateTime(1920, 1, 2),
                Email = "legacy@asimov.com",
                Website = "https://www.asimovonline.com"
            },
            new Author 
            { 
                FirstName = "Agatha", 
                LastName = "Christie", 
                Biography = "English writer known for her detective novels, especially those featuring Hercule Poirot and Miss Marple.",
                BirthDate = new DateTime(1890, 9, 15),
                Email = "estate@agathachristie.com",
                Website = "https://www.agathachristie.com"
            }
        };

        context.Authors.AddRange(authors);
        await context.SaveChangesAsync();
        Console.WriteLine("Authors seeded successfully!");
    }

    private static async Task SeedBooks(ApplicationDbContext context)
    {
        if (await context.Books.AnyAsync()) 
        {
            Console.WriteLine("Books already exist.");
            return;
        }

        // Get the seeded authors and categories
        var authors = await context.Authors.ToListAsync();
        var categories = await context.Categories.ToListAsync();

        var rowling = authors.First(a => a.LastName == "Rowling");
        var king = authors.First(a => a.LastName == "King");
        var gaiman = authors.First(a => a.LastName == "Gaiman");
        var asimov = authors.First(a => a.LastName == "Asimov");
        var christie = authors.First(a => a.LastName == "Christie");

        var fiction = categories.First(c => c.Name == "Fiction");
        var science = categories.First(c => c.Name == "Science");
        var biography = categories.First(c => c.Name == "Biography");

        var books = new List<Book>
        {
            new Book 
            { 
                Title = "Harry Potter and the Philosopher's Stone", 
                Description = "The first book in the Harry Potter series, following young Harry as he discovers he's a wizard.",
                ISBN = "978-0747532699",
                Price = 12.99m,
                StockQuantity = 50,
                PublishedDate = new DateTime(1997, 6, 26),
                IsActive = true,
                ImageUrl = "/images/books/harry-potter-1.jpg",
                AuthorId = rowling.Id,
                CategoryId = fiction.Id
            },
            new Book 
            { 
                Title = "The Shining", 
                Description = "A psychological horror novel about a family isolated in a haunted hotel during the winter.",
                ISBN = "978-0307743657",
                Price = 14.99m,
                StockQuantity = 30,
                PublishedDate = new DateTime(1977, 1, 28),
                IsActive = true,
                ImageUrl = "/images/books/the-shining.jpg",
                AuthorId = king.Id,
                CategoryId = fiction.Id
            },
            new Book 
            { 
                Title = "Good Omens", 
                Description = "A humorous fantasy novel about the coming of the Antichrist and the end of the world.",
                ISBN = "978-0060853983",
                Price = 13.99m,
                StockQuantity = 25,
                PublishedDate = new DateTime(1990, 5, 1),
                IsActive = true,
                ImageUrl = "/images/books/good-omens.jpg",
                AuthorId = gaiman.Id,
                CategoryId = fiction.Id
            },
            new Book 
            { 
                Title = "Foundation", 
                Description = "The first novel in the Foundation series, set in a galactic empire on the brink of collapse.",
                ISBN = "978-0553293357",
                Price = 15.99m,
                StockQuantity = 40,
                PublishedDate = new DateTime(1951, 5, 1),
                IsActive = true,
                ImageUrl = "/images/books/foundation.jpg",
                AuthorId = asimov.Id,
                CategoryId = science.Id
            },
            new Book 
            { 
                Title = "Murder on the Orient Express", 
                Description = "A classic detective novel featuring Hercule Poirot solving a murder on a luxury train.",
                ISBN = "978-0062073501",
                Price = 11.99m,
                StockQuantity = 35,
                PublishedDate = new DateTime(1934, 1, 1),
                IsActive = true,
                ImageUrl = "/images/books/orient-express.jpg",
                AuthorId = christie.Id,
                CategoryId = fiction.Id
            }
        };

        context.Books.AddRange(books);
        await context.SaveChangesAsync();
        Console.WriteLine("Books seeded successfully!");
    }
} 
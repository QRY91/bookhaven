using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using BookHaven.MVC.Data;
using BookHaven.Shared.Models;

namespace BookHaven.MVC.Controllers
{
    public class BooksController : Controller
    {
        private readonly ApplicationDbContext _context;

        public BooksController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Books
        public async Task<IActionResult> Index(string searchString, int? categoryId, int? authorId, decimal? minPrice, decimal? maxPrice)
        {
            var booksQuery = _context.Books
                .Include(b => b.Author)
                .Include(b => b.Category)
                .AsQueryable();

            // Search functionality
            if (!string.IsNullOrEmpty(searchString))
            {
                booksQuery = booksQuery.Where(b => 
                    b.Title.Contains(searchString) || 
                    b.Description.Contains(searchString) ||
                    b.Author.FirstName.Contains(searchString) ||
                    b.Author.LastName.Contains(searchString));
            }

            // Filter by category
            if (categoryId.HasValue)
            {
                booksQuery = booksQuery.Where(b => b.CategoryId == categoryId);
            }

            // Filter by author
            if (authorId.HasValue)
            {
                booksQuery = booksQuery.Where(b => b.AuthorId == authorId);
            }

            // Filter by price range
            if (minPrice.HasValue)
            {
                booksQuery = booksQuery.Where(b => b.Price >= minPrice);
            }

            if (maxPrice.HasValue)
            {
                booksQuery = booksQuery.Where(b => b.Price <= maxPrice);
            }

            var books = await booksQuery.OrderBy(b => b.Title).ToListAsync();

            // Pass filter data to view
            ViewBag.Categories = new SelectList(await _context.Categories.ToListAsync(), "Id", "Name");
            ViewBag.Authors = new SelectList(await _context.Authors.ToListAsync(), "Id", "FullName");
            ViewBag.CurrentSearch = searchString;
            ViewBag.CurrentCategory = categoryId;
            ViewBag.CurrentAuthor = authorId;
            ViewBag.MinPrice = minPrice;
            ViewBag.MaxPrice = maxPrice;

            return View(books);
        }

        // GET: Books/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var book = await _context.Books
                .Include(b => b.Author)
                .Include(b => b.Category)
                .FirstOrDefaultAsync(m => m.Id == id);
            
            if (book == null)
            {
                return NotFound();
            }

            return View(book);
        }

        // GET: Books/Create
        public IActionResult Create()
        {
            ViewData["AuthorId"] = new SelectList(_context.Authors, "Id", "FullName");
            ViewData["CategoryId"] = new SelectList(_context.Categories, "Id", "Name");
            return View();
        }

        // POST: Books/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,Title,Description,ISBN,Price,StockQuantity,PublishedDate,IsActive,ImageUrl,AuthorId,CategoryId")] Book book)
        {
            if (ModelState.IsValid)
            {
                _context.Add(book);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["AuthorId"] = new SelectList(_context.Authors, "Id", "FullName", book.AuthorId);
            ViewData["CategoryId"] = new SelectList(_context.Categories, "Id", "Name", book.CategoryId);
            return View(book);
        }

        // GET: Books/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var book = await _context.Books.FindAsync(id);
            if (book == null)
            {
                return NotFound();
            }
            ViewData["AuthorId"] = new SelectList(_context.Authors, "Id", "FullName", book.AuthorId);
            ViewData["CategoryId"] = new SelectList(_context.Categories, "Id", "Name", book.CategoryId);
            return View(book);
        }

        // POST: Books/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,Title,Description,ISBN,Price,StockQuantity,PublishedDate,IsActive,ImageUrl,AuthorId,CategoryId")] Book book)
        {
            if (id != book.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(book);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!BookExists(book.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["AuthorId"] = new SelectList(_context.Authors, "Id", "FullName", book.AuthorId);
            ViewData["CategoryId"] = new SelectList(_context.Categories, "Id", "Name", book.CategoryId);
            return View(book);
        }

        // GET: Books/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var book = await _context.Books
                .Include(b => b.Author)
                .Include(b => b.Category)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (book == null)
            {
                return NotFound();
            }

            return View(book);
        }

        // POST: Books/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var book = await _context.Books.FindAsync(id);
            if (book != null)
            {
                _context.Books.Remove(book);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool BookExists(int id)
        {
            return _context.Books.Any(e => e.Id == id);
        }
    }
} 
using System.ComponentModel.DataAnnotations;

namespace BookHaven.Shared.Models
{
    public class Book
    {
        public int Id { get; set; }
        
        [Required(ErrorMessage = "Title is required")]
        [StringLength(200, MinimumLength = 2)]
        [Display(Name = "Book Title")]
        public string Title { get; set; } = string.Empty;
        
        public string Description { get; set; } = string.Empty;
        
        [Required]
        public string ISBN { get; set; } = string.Empty;
        
        [Range(0.01, 999.99, ErrorMessage = "Price must be between $0.01 and $999.99")]
        [DataType(DataType.Currency)]
        public decimal Price { get; set; }
        
        [Display(Name = "Stock Quantity")]
        public int StockQuantity { get; set; }
        
        [DataType(DataType.Date)]
        [Display(Name = "Published Date")]
        public DateTime PublishedDate { get; set; }
        
        public bool IsActive { get; set; } = true;
        
        [Display(Name = "Image URL")]
        public string? ImageUrl { get; set; }
        
        // Foreign Keys
        [Display(Name = "Author")]
        public int AuthorId { get; set; }
        
        [Display(Name = "Category")]
        public int CategoryId { get; set; }
        
        // Navigation Properties
        public virtual Author? Author { get; set; }
        public virtual Category? Category { get; set; }
        public virtual ICollection<OrderItem>? OrderItems { get; set; }
    }
} 
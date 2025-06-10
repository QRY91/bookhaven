using System.ComponentModel.DataAnnotations;

namespace BookHaven.Shared.Models
{
    public class Category
    {
        public int Id { get; set; }
        
        [Required]
        [StringLength(100, MinimumLength = 2)]
        public string Name { get; set; } = string.Empty;
        
        public string? Description { get; set; }
        
        [Display(Name = "Display Order")]
        public int DisplayOrder { get; set; } = 0;
        
        [Display(Name = "Is Active")]
        public bool IsActive { get; set; } = true;
        
        // Navigation Properties
        public virtual ICollection<Book>? Books { get; set; }
    }
} 
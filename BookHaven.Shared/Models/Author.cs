using System.ComponentModel.DataAnnotations;

namespace BookHaven.Shared.Models
{
    public class Author
    {
        public int Id { get; set; }
        
        [Required]
        [Display(Name = "First Name")]
        public string FirstName { get; set; } = string.Empty;
        
        [Required]
        [Display(Name = "Last Name")]
        public string LastName { get; set; } = string.Empty;
        
        public string? Biography { get; set; }
        
        [DataType(DataType.Date)]
        [Display(Name = "Birth Date")]
        public DateTime? BirthDate { get; set; }
        
        [EmailAddress]
        public string? Email { get; set; }
        
        [Url]
        public string? Website { get; set; }
        
        // Navigation Properties
        public virtual ICollection<Book>? Books { get; set; }
        
        [Display(Name = "Full Name")]
        public string FullName => $"{FirstName} {LastName}";
    }
} 
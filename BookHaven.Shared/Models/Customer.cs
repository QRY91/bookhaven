using System.ComponentModel.DataAnnotations;

namespace BookHaven.Shared.Models
{
    public class Customer
    {
        public int Id { get; set; }
        
        [Required]
        [Display(Name = "First Name")]
        public string FirstName { get; set; } = string.Empty;
        
        [Required]
        [Display(Name = "Last Name")]
        public string LastName { get; set; } = string.Empty;
        
        [Required]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;
        
        [Phone]
        public string? Phone { get; set; }
        
        public string? Address { get; set; }
        
        public string? City { get; set; }
        
        [Display(Name = "Postal Code")]
        public string? PostalCode { get; set; }
        
        [Display(Name = "Registration Date")]
        public DateTime RegistrationDate { get; set; } = DateTime.Now;
        
        // Navigation Properties
        public virtual ICollection<Order>? Orders { get; set; }
        
        [Display(Name = "Full Name")]
        public string FullName => $"{FirstName} {LastName}";
    }
} 
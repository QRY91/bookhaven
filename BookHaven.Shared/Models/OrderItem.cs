using System.ComponentModel.DataAnnotations;

namespace BookHaven.Shared.Models
{
    public class OrderItem
    {
        public int Id { get; set; }
        
        public int Quantity { get; set; }
        
        [Display(Name = "Unit Price")]
        [DataType(DataType.Currency)]
        public decimal UnitPrice { get; set; }
        
        // Foreign Keys
        [Display(Name = "Order")]
        public int OrderId { get; set; }
        
        [Display(Name = "Book")]
        public int BookId { get; set; }
        
        // Navigation Properties
        public virtual Order? Order { get; set; }
        public virtual Book? Book { get; set; }
        
        // Calculated Property
        [Display(Name = "Line Total")]
        [DataType(DataType.Currency)]
        public decimal LineTotal => Quantity * UnitPrice;
    }
} 
using System.ComponentModel.DataAnnotations;

namespace BookHaven.Shared.Models
{
    public class Order
    {
        public int Id { get; set; }
        
        [Display(Name = "Order Number")]
        public string OrderNumber { get; set; } = string.Empty;
        
        [Display(Name = "Order Date")]
        public DateTime OrderDate { get; set; } = DateTime.Now;
        
        [Display(Name = "Total Amount")]
        [DataType(DataType.Currency)]
        public decimal TotalAmount { get; set; }
        
        public string Status { get; set; } = "Pending";
        
        [Display(Name = "Shipping Address")]
        public string? ShippingAddress { get; set; }
        
        // Foreign Key
        [Display(Name = "Customer")]
        public int CustomerId { get; set; }
        
        // Navigation Properties
        public virtual Customer? Customer { get; set; }
        public virtual ICollection<OrderItem>? OrderItems { get; set; }
    }
} 
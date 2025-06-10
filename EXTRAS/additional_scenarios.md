# Additional Mock Exam Scenarios: Domain Variety Practice

**Purpose**: Multiple practice scenarios to prepare for different exam domains  
**Goal**: Build confidence across various business contexts using same technical patterns  
**Strategy**: Same architectural complexity, different business logic  
**Benefit**: Adaptability to unknown exam requirements

---

## 🎯 **SCENARIO OVERVIEW**

Each scenario follows the **same technical pattern** as PxlFund but with different business domains:
- **Multi-project solution** (Main.Mvc + Shared)
- **Identity with roles** and external authentication
- **3 main entities** with relationships
- **CRUD controllers** for all entities
- **REST API endpoints** (GET list, POST create)
- **Blazor components** (add record, overview)
- **Seeding data** with specific business examples

---

## 📚 **SCENARIO 1: PxlLibrary - Library Management System**

### **Business Context**
University library system for managing books, authors, and student loans.

### **Entities & Relationships**
```
Author (Publisher role)
├── Id, Name, Biography, Country
└── Books (One-to-Many)

Book (Asset)
├── Id, Title, ISBN, AuthorId, Price, Category
├── Author (navigation)
└── StudentLoans (One-to-Many)

StudentLoan (Bridge/Transaction)
├── Id, StudentId, BookId, LoanDate, DueDate, ReturnDate
├── Student (navigation)
└── Book (navigation)
```

### **Seeding Requirements**
**Authors**:
- J.K. Rowling (UK)
- George Orwell (UK)
- Agatha Christie (UK)

**Books**:
- Harry Potter - J.K. Rowling - €25.99 - Fantasy
- 1984 - George Orwell - €18.50 - Dystopian
- Murder on Orient Express - Agatha Christie - €22.00 - Mystery

**Roles & Users**:
- Librarian role, Student role
- Admin: librarian@pxl.be / Libr@rian

### **API Endpoints**
```
GET /api/BookInfo
Response: AuthorName – BookTitle – BookPrice

POST /api/Book/Fiction
Purpose: Add Book for category Fiction
```

### **Blazor Components**
- Add StudentLoan component (loan book to student)
- Student Loans Overview (show student's current loans)

---

## 🍕 **SCENARIO 2: PxlEats - Restaurant Ordering System**

### **Business Context**
Restaurant chain management for menus, orders, and customer relationships.

### **Entities & Relationships**
```
Restaurant (Location)
├── Id, Name, Address, City, PhoneNumber
└── MenuItems (One-to-Many)

MenuItem (Product)
├── Id, Name, Description, RestaurantId, Price, Category
├── Restaurant (navigation)
└── OrderItems (One-to-Many)

OrderItem (Bridge/Transaction)
├── Id, CustomerId, MenuItemId, Quantity, OrderDate, Status
├── Customer (navigation)
└── MenuItem (navigation)
```

### **Seeding Requirements**
**Restaurants**:
- PxlEats Downtown
- PxlEats Campus

**MenuItems**:
- Margherita Pizza - PxlEats Downtown - €12.50 - Pizza
- Caesar Salad - PxlEats Downtown - €8.99 - Salad
- Burger Deluxe - PxlEats Campus - €14.99 - Burger
- Pasta Carbonara - PxlEats Campus - €11.50 - Pasta

**Roles & Users**:
- Manager role, Customer role
- Admin: manager@pxleats.be / Mng@r123

### **API Endpoints**
```
GET /api/MenuInfo
Response: RestaurantName – ItemName – ItemPrice

POST /api/MenuItem/Pizza
Purpose: Add MenuItem for category Pizza
```

### **Blazor Components**
- Add OrderItem component (add item to customer order)
- Customer Orders Overview (show customer's order history)

---

## 🏨 **SCENARIO 3: PxlStay - Hotel Booking System**

### **Business Context**
Hotel chain booking system for rooms, reservations, and guest management.

### **Entities & Relationships**
```
Hotel (Location)
├── Id, Name, City, StarRating, Address
└── Rooms (One-to-Many)

Room (Asset)
├── Id, RoomNumber, HotelId, RoomType, PricePerNight, MaxGuests
├── Hotel (navigation)
└── Reservations (One-to-Many)

Reservation (Bridge/Transaction)
├── Id, GuestId, RoomId, CheckIn, CheckOut, TotalPrice, Status
├── Guest (navigation)
└── Room (navigation)
```

### **Seeding Requirements**
**Hotels**:
- PxlStay Brussels
- PxlStay Antwerp

**Rooms**:
- Room 101 - PxlStay Brussels - Single - €89.99/night
- Room 201 - PxlStay Brussels - Double - €129.99/night
- Room 301 - PxlStay Antwerp - Suite - €199.99/night
- Room 401 - PxlStay Antwerp - Double - €139.99/night

**Roles & Users**:
- Manager role, Guest role
- Admin: manager@pxlstay.be / Htl@dm1n

### **API Endpoints**
```
GET /api/RoomInfo
Response: HotelName – RoomType – PricePerNight

POST /api/Room/Suite
Purpose: Add Room for type Suite
```

### **Blazor Components**
- Add Reservation component (book room for guest)
- Guest Reservations Overview (show guest's booking history)

---

## 📖 **SCENARIO 4: PxlLearn - E-Learning Platform**

### **Business Context**
Online learning platform for courses, enrollments, and student progress.

### **Entities & Relationships**
```
Instructor (Publisher role)
├── Id, Name, Email, Expertise, Bio
└── Courses (One-to-Many)

Course (Product)
├── Id, Title, Description, InstructorId, Price, Duration, Level
├── Instructor (navigation)
└── Enrollments (One-to-Many)

Enrollment (Bridge/Transaction)
├── Id, StudentId, CourseId, EnrollmentDate, Progress, Grade, Status
├── Student (navigation)
└── Course (navigation)
```

### **Seeding Requirements**
**Instructors**:
- Dr. Sarah Johnson (Web Development)
- Prof. Mark Stevens (Data Science)

**Courses**:
- ASP.NET Core Fundamentals - Dr. Sarah Johnson - €199.99 - Beginner
- Advanced C# Programming - Dr. Sarah Johnson - €299.99 - Advanced
- Python for Data Science - Prof. Mark Stevens - €249.99 - Intermediate
- Machine Learning Basics - Prof. Mark Stevens - €349.99 - Intermediate

**Roles & Users**:
- Instructor role, Student role
- Admin: admin@pxllearn.be / Lrn@dm1n

### **API Endpoints**
```
GET /api/CourseInfo
Response: InstructorName – CourseTitle – CoursePrice

POST /api/Course/Beginner
Purpose: Add Course for level Beginner
```

### **Blazor Components**
- Add Enrollment component (enroll student in course)
- Student Enrollments Overview (show student's courses and progress)

---

## 📦 **SCENARIO 5: PxlStock - Inventory Management System**

### **Business Context**
Warehouse inventory system for suppliers, products, and stock movements.

### **Entities & Relationships**
```
Supplier (Source)
├── Id, Name, Email, Phone, Address, ContactPerson
└── Products (One-to-Many)

Product (Asset)
├── Id, Name, SKU, SupplierId, UnitPrice, Category, Description
├── Supplier (navigation)
└── StockMovements (One-to-Many)

StockMovement (Bridge/Transaction)
├── Id, ProductId, WarehouseStaffId, MovementType, Quantity, Date, Notes
├── WarehouseStaff (navigation)
└── Product (navigation)
```

### **Seeding Requirements**
**Suppliers**:
- TechSupply Co.
- OfficeGoods Ltd.

**Products**:
- Laptop Dell XPS - TechSupply Co. - €899.99 - Electronics
- Wireless Mouse - TechSupply Co. - €29.99 - Accessories
- Office Chair - OfficeGoods Ltd. - €199.99 - Furniture
- Desk Lamp - OfficeGoods Ltd. - €45.99 - Lighting

**Roles & Users**:
- Manager role, Staff role
- Admin: manager@pxlstock.be / Stk@dm1n

### **API Endpoints**
```
GET /api/ProductInfo
Response: SupplierName – ProductName – UnitPrice

POST /api/Product/Electronics
Purpose: Add Product for category Electronics
```

### **Blazor Components**
- Add StockMovement component (record stock in/out)
- Staff Stock Overview (show staff's recorded movements)

---

## 🎪 **SCENARIO 6: PxlEvents - Event Management System**

### **Business Context**
Event management platform for venues, events, and ticket bookings.

### **Entities & Relationships**
```
Venue (Location)
├── Id, Name, Address, City, Capacity, ContactInfo
└── Events (One-to-Many)

Event (Product)
├── Id, Title, Description, VenueId, Date, TicketPrice, MaxAttendees
├── Venue (navigation)
└── Bookings (One-to-Many)

Booking (Bridge/Transaction)
├── Id, AttendeeId, EventId, BookingDate, TicketQuantity, TotalPrice, Status
├── Attendee (navigation)
└── Event (navigation)
```

### **Seeding Requirements**
**Venues**:
- PXL Convention Center
- PXL Auditorium

**Events**:
- Tech Conference 2024 - PXL Convention Center - €50.00 - Conference
- Music Concert - PXL Auditorium - €75.00 - Entertainment
- Workshop: Web Development - PXL Convention Center - €25.00 - Workshop
- Career Fair - PXL Auditorium - Free - Fair

**Roles & Users**:
- Organizer role, Attendee role
- Admin: organizer@pxlevents.be / Evt@dm1n

### **API Endpoints**
```
GET /api/EventInfo
Response: VenueName – EventTitle – TicketPrice

POST /api/Event/Conference
Purpose: Add Event for type Conference
```

### **Blazor Components**
- Add Booking component (book tickets for attendee)
- Attendee Bookings Overview (show attendee's event bookings)

---

## 🎯 **PRACTICE STRATEGY: SCENARIO ROTATION**

### **Week 1**: Master PxlFund (Banking)
- Learn the technical patterns
- Perfect the 3-hour timing
- Understand all requirements

### **Week 2**: Practice Domain Adaptation
- Pick 2-3 different scenarios
- Focus on quick entity identification
- Practice template customization speed

### **Week 3**: Random Scenario Practice
- Have someone else pick a scenario randomly
- Practice reading requirements and mapping to patterns
- Build confidence with unknown domains

### **Exam Day**: Universal Pattern Recognition
- Any domain can be mapped to the same patterns
- Entity relationships follow predictable structures
- Technical implementation stays consistent

---

## 🔧 **TEMPLATE CUSTOMIZATION GUIDE**

### **Universal Find/Replace Pattern**
```
{ProjectName} → PxlLibrary/PxlEats/PxlStay/etc.
{Entity1} → Author/Restaurant/Hotel/Instructor/Supplier/Venue
{Entity2} → Book/MenuItem/Room/Course/Product/Event  
{Entity3} → StudentLoan/OrderItem/Reservation/Enrollment/StockMovement/Booking
{Role1} → Librarian/Manager/Manager/Instructor/Manager/Organizer
{Role2} → Student/Customer/Guest/Student/Staff/Attendee
```

### **Business Logic Patterns**
- **Source Entity**: Provides/owns the assets (Bank→Fund, Author→Book)
- **Asset Entity**: Main business object (Fund, Book, Room, Course)
- **Transaction Entity**: Records interactions (UserFund, Loan, Reservation)

### **API Pattern**
- **GET /api/{Asset}Info**: List all with source info
- **POST /api/{Asset}/{Category}**: Add new asset by category

### **Blazor Pattern**
- **Add{Transaction}**: Form to create new transaction
- **{User}{Transaction}Overview**: Show user's transaction history

---

## 🏆 **MASTERY INDICATORS**

### **You've Mastered Domain Adaptation When:**
- [ ] **Can identify entities in any domain within 5 minutes**
- [ ] **Recognize relationship patterns immediately**  
- [ ] **Customize templates quickly regardless of business context**
- [ ] **Understand seeding data requirements from any domain**
- [ ] **Map API and Blazor requirements to standard patterns**

### **Exam Readiness Checklist**
- [ ] **Completed 3+ different scenarios successfully**
- [ ] **Under 3-hour completion time for any scenario**
- [ ] **Confident with template customization workflow**
- [ ] **Understand universal architectural patterns**
- [ ] **Ready for unknown domain on exam day**

---

**Remember**: The exam domain doesn't matter. Whether it's banking, library, restaurant, or something completely different, the technical patterns remain the same. Master the systematic approach, and you can adapt to any business context quickly and confidently.

**You're building systematic adaptability, not memorizing specific solutions.** 🚀
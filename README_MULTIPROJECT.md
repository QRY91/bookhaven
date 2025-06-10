# 🏗️ Multi-Project Exam Architecture Guide

**Status**: 🎯 Essential Exam Pattern  
**Architecture**: Microservices-style with MVC + API + Shared Libraries  
**Based on**: PXLPRO2025Shoppers25 pattern analysis  
**Purpose**: Master complex multi-project exam scenarios

---

## 🚨 **CRITICAL INSIGHT**

**Your exam will likely involve a multi-project solution**, not a simple single MVC project. Based on the PXLPRO2025Shoppers25 example, expect:

- ✅ **Main MVC Web Application** - user interface and primary business logic
- ✅ **Separate API Project** - microservice for specific functionality (orders, inventory, etc.)
- ✅ **Shared Class Library** - DTOs and common models for inter-service communication
- ✅ **Identity Server** - separate authentication/authorization service
- ✅ **Solution file** - coordinating all projects with dependencies

**This changes your exam strategy significantly!**

---

## 🏛️ **EXPECTED ARCHITECTURE PATTERN**

### **Project Structure Analysis**

Based on PXLPRO2025Shoppers25, expect this pattern:

```
YourExamSolution.sln
├── YourApp.MVC/                    # Main web application
│   ├── Controllers/                # MVC controllers for UI
│   ├── Views/                      # Razor views and layouts
│   ├── Models/                     # ViewModels and UI models
│   ├── Services/                   # Business logic services
│   ├── Data/                       # EF DbContext for main DB
│   └── YourApp.MVC.csproj         # References Shared library
├── YourApp.SomeApi/               # Specialized API service
│   ├── Controllers/                # API controllers (Web API)
│   ├── Models/                     # API-specific models
│   ├── Data/                       # Separate DbContext for API
│   ├── Services/                   # API business logic
│   └── YourApp.SomeApi.csproj     # References Shared library
├── YourApp.Shared/                # Common DTOs and contracts
│   ├── DTOs/                      # Data Transfer Objects
│   ├── Models/                    # Shared domain models
│   └── YourApp.Shared.csproj      # No external dependencies
└── YourApp.IdentityServer/        # Authentication service
    ├── Config.cs                  # Identity configuration
    ├── Pages/                     # Login/logout pages
    └── YourApp.IdentityServer.csproj
```

### **Key Integration Points**

1. **MVC ↔ API Communication**: HTTP calls using DTOs
2. **Shared DTOs**: Common data contracts between services
3. **Project Dependencies**: MVC and API both reference Shared
4. **Authentication**: Identity server provides auth for both MVC and API
5. **Separate Databases**: Each service may have its own DbContext

---

## ⏱️ **REVISED 3-HOUR STRATEGY**

### **Phase 1: Foundation (0-45 min) - MODIFIED**

**Multi-project setup is more complex - budget extra time:**

```
0-10 min: READ ASSIGNMENT
  - Identify how many projects needed
  - Understand service boundaries
  - Plan DTO communication contracts

10-25 min: SOLUTION SETUP
  - Create solution file
  - Create all project structures
  - Set up project references
  - Install NuGet packages for all projects

25-45 min: SHARED CONTRACTS
  - Define DTOs in Shared library
  - Create basic models for each project
  - Set up DbContexts for each service
  - Test solution builds successfully
```

### **Phase 2: Core Implementation (45-135 min)**

**Parallel development across projects:**

```
45-75 min: API PROJECT FIRST
  - Implement API controllers
  - Set up API DbContext and migrations
  - Create basic CRUD operations
  - Test API endpoints work

75-105 min: MVC PROJECT
  - Create MVC controllers that call API
  - Implement views for user interface
  - Set up MVC DbContext if separate
  - Integrate with API using HttpClient

105-135 min: INTEGRATION
  - Test MVC ↔ API communication
  - Fix any DTO/contract issues
  - Ensure authentication flows work
  - Verify end-to-end functionality
```

### **Phase 3: Polish & Features (135-180 min)**

**Cross-cutting concerns and polish:**

```
135-155 min: AUTHENTICATION
  - Configure Identity Server
  - Set up authentication in MVC
  - Secure API endpoints
  - Test login/logout flows

155-180 min: FINAL POLISH
  - Add validation and error handling
  - Improve UI styling
  - Test all features work together
  - Document any setup requirements
```

---

## 🔧 **ESSENTIAL MULTI-PROJECT SKILLS**

### **Solution Management**

- [ ] **Create solution file** with multiple projects
- [ ] **Set project references** correctly
- [ ] **Manage NuGet packages** across projects
- [ ] **Build order dependencies** - Shared → API → MVC

### **Inter-Service Communication**

- [ ] **HTTP client setup** in MVC to call API
- [ ] **DTO serialization** and deserialization
- [ ] **Error handling** for service calls
- [ ] **Configuration management** for API URLs

### **Shared Libraries**

- [ ] **DTO design** for service contracts
- [ ] **Namespace organization** across projects
- [ ] **Versioning considerations** for shared contracts
- [ ] **Dependency management** without circular references

### **Project-Specific Concerns**

- [ ] **Separate DbContexts** - each service owns its data
- [ ] **Different connection strings** per service
- [ ] **Migration management** across multiple databases
- [ ] **Service-specific configuration** files

---

## 📋 **MULTI-PROJECT TEMPLATES**

### **Solution File Template**

```sln
Microsoft Visual Studio Solution File, Format Version 12.00
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "{ProjectName}.MVC", "{ProjectName}.MVC\{ProjectName}.MVC.csproj", "{GUID1}"
	ProjectSection(ProjectDependencies) = postProject
		{GUID3} = {GUID3}  // IdentityServer
		{GUID4} = {GUID4}  // API
	EndProjectSection
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "{ProjectName}.{ApiName}", "{ProjectName}.{ApiName}\{ProjectName}.{ApiName}.csproj", "{GUID4}"
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "{ProjectName}.Shared", "{ProjectName}.Shared\{ProjectName}.Shared.csproj", "{GUID2}"
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "{ProjectName}.IdentityServer", "{ProjectName}.IdentityServer\{ProjectName}.IdentityServer.csproj", "{GUID3}"
EndProject
```

### **MVC Project File Template**

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
    <PropertyGroup>
        <TargetFramework>net8.0</TargetFramework>
        <Nullable>enable</Nullable>
        <ImplicitUsings>enable</ImplicitUsings>
    </PropertyGroup>

    <ItemGroup>
        <PackageReference Include="Microsoft.AspNetCore.Identity.EntityFrameworkCore" Version="8.0.14" />
        <PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="8.0.14" />
        <PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="8.0.14" />
        <PackageReference Include="Microsoft.AspNetCore.Authentication.OpenIdConnect" Version="8.0.14" />
    </ItemGroup>

    <ItemGroup>
        <ProjectReference Include="..\{ProjectName}.Shared\{ProjectName}.Shared.csproj" />
    </ItemGroup>
</Project>
```

### **API Project File Template**

```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
    <PropertyGroup>
        <TargetFramework>net8.0</TargetFramework>
        <Nullable>enable</Nullable>
        <ImplicitUsings>enable</ImplicitUsings>
    </PropertyGroup>

    <ItemGroup>
        <PackageReference Include="Microsoft.AspNetCore.OpenApi" Version="8.0.14" />
        <PackageReference Include="Microsoft.EntityFrameworkCore.SqlServer" Version="8.0.14" />
        <PackageReference Include="Microsoft.EntityFrameworkCore.Tools" Version="8.0.14" />
        <PackageReference Include="Swashbuckle.AspNetCore" Version="6.4.0" />
    </ItemGroup>

    <ItemGroup>
        <ProjectReference Include="..\{ProjectName}.Shared\{ProjectName}.Shared.csproj" />
    </ItemGroup>
</Project>
```

### **Shared Library Template**

```xml
<Project Sdk="Microsoft.NET.Sdk">
    <PropertyGroup>
        <TargetFramework>net8.0</TargetFramework>
        <ImplicitUsings>enable</ImplicitUsings>
        <Nullable>enable</Nullable>
    </PropertyGroup>
</Project>
```

---

## 🔄 **MVC ↔ API COMMUNICATION PATTERNS**

### **HTTP Client Setup in MVC**

```csharp
// Program.cs in MVC project
builder.Services.AddHttpClient("ApiClient", client =>
{
    client.BaseAddress = new Uri("https://localhost:7001/"); // API URL
});

// Service injection
public class SomeService
{
    private readonly HttpClient _httpClient;

    public SomeService(IHttpClientFactory httpClientFactory)
    {
        _httpClient = httpClientFactory.CreateClient("ApiClient");
    }

    public async Task<List<SomeDto>> GetDataAsync()
    {
        var response = await _httpClient.GetAsync("api/somecontroller");
        var json = await response.Content.ReadAsStringAsync();
        return JsonSerializer.Deserialize<List<SomeDto>>(json) ?? new();
    }
}
```

### **API Controller Pattern**

```csharp
[ApiController]
[Route("api/[controller]")]
public class SomeController : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<List<SomeDto>>> GetAll()
    {
        // Implementation
        return Ok(results);
    }

    [HttpPost]
    public async Task<ActionResult<SomeResponseDto>> Create([FromBody] CreateSomeDto request)
    {
        // Implementation
        return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
    }
}
```

### **Shared DTO Pattern**

```csharp
// In Shared project
namespace {ProjectName}.Shared.DTOs;

public class CreateSomeRequest
{
    public string Name { get; set; } = string.Empty;
    public int SomeValue { get; set; }
}

public class SomeResponseDto
{
    public bool Success { get; set; }
    public string Message { get; set; } = string.Empty;
    public int? Id { get; set; }
    public List<string> Errors { get; set; } = new();
}
```

---

## ⚠️ **COMMON MULTI-PROJECT PITFALLS**

### **Build Order Issues**

- **Problem**: Projects build in wrong order, missing dependencies
- **Solution**: Ensure Shared library builds first, then API, then MVC
- **Fix**: Check project dependencies in solution file

### **Circular References**

- **Problem**: Projects reference each other creating circular dependency
- **Solution**: Use Shared library for common contracts, never reference "up" the chain

### **Configuration Confusion**

- **Problem**: Different projects need different connection strings/settings
- **Solution**: Each project has its own appsettings.json with appropriate configuration

### **Port Conflicts**

- **Problem**: Multiple projects trying to use same ports
- **Solution**: Configure different ports in launchSettings.json for each project

### **Authentication Integration**

- **Problem**: Identity server, MVC, and API authentication not working together
- **Solution**: Follow OpenID Connect patterns, ensure all services configured for same authority

---

## 🎯 **EXAM DAY STRATEGY**

### **Before You Start Coding**

1. **Identify the architecture** - how many projects are expected?
2. **Plan the service boundaries** - what goes in MVC vs API vs Shared?
3. **Design the DTOs first** - these are your contracts between services
4. **Set up project structure** - create all projects and references before coding

### **Development Order Priority**

1. **Shared library** - DTOs and contracts first
2. **API project** - core business logic and data access
3. **MVC project** - user interface and integration with API
4. **Identity integration** - authentication last (if time permits)

### **Time Management Adjustments**

- **Add 15 minutes** to foundation phase for multi-project setup
- **Start with API** - it's usually simpler and establishes your data contracts
- **Test integration early** - don't wait until the end to see if MVC and API talk
- **Have fallback plan** - if inter-service communication fails, can you make it work in MVC only?

---

## 📚 **STUDY PRIORITIES**

### **Essential Skills** (Master these first)

1. **Solution and project creation** - can you set up the structure quickly?
2. **Project references** - how to link projects together
3. **HTTP client usage** - calling APIs from MVC
4. **DTO design** - creating clean contracts between services
5. **Basic API controllers** - simple CRUD operations

### **Intermediate Skills** (If time allows)

1. **Identity server integration** - authentication across services
2. **Error handling** - graceful degradation when services fail
3. **Configuration management** - different settings per project
4. **Swagger/OpenAPI** - documenting your API

### **Advanced Skills** (Nice to have)

1. **API versioning** - handling multiple API versions
2. **Service discovery** - dynamic API endpoint configuration
3. **Distributed logging** - tracking requests across services
4. **Circuit breaker patterns** - handling service failures

---

## 🏆 **SUCCESS INDICATORS**

**You're ready for multi-project exams when you can:**

- [ ] **Create a solution** with 4 projects in under 10 minutes
- [ ] **Set up project references** and NuGet packages correctly
- [ ] **Design DTOs** that work for both MVC and API needs
- [ ] **Implement API endpoints** with proper HTTP status codes
- [ ] **Call APIs from MVC** using HttpClient successfully
- [ ] **Handle basic errors** in inter-service communication
- [ ] **Test end-to-end flows** from UI through API to database

---

## 🚨 **EXAM ADAPTATION STRATEGY**

**If you encounter a multi-project exam:**

1. **Don't panic** - the core principles are the same
2. **Start with Shared project** - establish your contracts first
3. **Build incrementally** - get basic functionality working before adding complexity
4. **Test frequently** - verify each integration step works
5. **Have backup plans** - know how to consolidate functionality if needed

**Remember**: Multi-project is about **separation of concerns**, not more complexity. Each project should have a **clear, focused responsibility**.

---

**Master this architecture pattern and you'll be prepared for advanced exam scenarios! 🚀**

---

## 📝 **NEXT STEPS**

1. **Practice the setup** - create empty multi-project solutions until it's automatic
2. **Study the communication patterns** - HTTP client and DTO usage
3. **Build a simple example** - implement basic CRUD across MVC → API → Database
4. **Time yourself** - can you set up the structure in 15 minutes?
5. **Plan your templates** - adapt your existing templates for multi-project scenarios

**The architecture complexity is manageable when you understand the patterns! 💪**

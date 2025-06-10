# 🚀 BookHaven Multi-Project Setup Guide

**Status**: ✅ Solution builds successfully + Multi-startup configured  
**Build Time**: ~27 seconds (includes NuGet restore)  
**Projects**: 4 (MVC + OrderApi + Shared + IdentityServer)  
**Startup**: ✅ Press F5 to run all 3 services automatically

## 🔧 **Quick Setup**

### **1. Open in Visual Studio**

```bash
# Open the solution file
BookHaven.sln
```

### **2. Build the Solution**

```bash
# Command line build
dotnet build BookHaven.sln

# Or use Visual Studio: Build → Build Solution (Ctrl+Shift+B)
```

### **3. Run All Projects (F5) 🎉**

**✅ ALREADY CONFIGURED!** Just press **F5** or click **Start**:

- **Visual Studio will automatically start all 3 projects**
- **No manual configuration needed** - it's ready out of the box
- **Correct ports are pre-configured** for each service

**What happens when you press F5:**

1. 🚀 **MVC Web App** starts at `https://localhost:5001` (opens in browser)
2. 🚀 **Order API** starts at `https://localhost:7001` (Swagger opens)
3. 🚀 **Identity Server** starts at `https://localhost:6001` (runs in background)

### **4. Expected URLs After Startup**

- **📱 Main App**: `https://localhost:5001` - BookHaven web interface
- **🔧 API Docs**: `https://localhost:7001/swagger` - Order API documentation
- **🔐 Auth Service**: `https://localhost:6001` - Identity server (background)

---

## 📁 **Project Structure**

```
BookHaven/                     # Solution root
├── BookHaven.sln             # Solution file
├── BookHaven.slnLaunch       # ✅ Multi-startup configuration
├── .gitignore                # Excludes build artifacts
├── BookHaven.MVC/            # Main web application
│   ├── Program.cs            # MVC setup + HttpClient (reads API URL from config)
│   ├── appsettings.json      # MVC database + API URL configuration
│   ├── Properties/launchSettings.json  # Port 5001 configuration
│   └── [MVC structure]       # Controllers, Views, Models
├── BookHaven.OrderApi/       # Order management API
│   ├── Program.cs            # API setup + Swagger
│   ├── appsettings.json      # API database config
│   ├── Properties/launchSettings.json  # Port 7001 + Swagger launch
│   └── [API structure]       # Controllers, Models, Services
├── BookHaven.Shared/         # DTOs and contracts
│   ├── DTOs/                 # Order & Inventory DTOs
│   └── BookHaven.Shared.csproj
└── BookHaven.IdentityServer/ # Authentication service
    ├── Program.cs            # Basic IdentityServer setup
    ├── appsettings.json      # Identity database config
    ├── Properties/launchSettings.json  # Port 6001 (no browser)
    └── [Identity structure]   # Configuration, Pages
```

---

## ⚙️ **Startup Configuration Details**

### **Multi-Project Startup** ✅

The solution is configured to automatically start multiple projects:

**Files that make this work:**

- `BookHaven.slnLaunch` - Solution-level startup configuration
- `Properties/launchSettings.json` - Individual project port settings
- `appsettings.json` - Cross-service URL configuration

**Port Assignment:**

- **MVC**: 5001 (HTTPS) + 5000 (HTTP)
- **OrderApi**: 7001 (HTTPS) + 7000 (HTTP)
- **IdentityServer**: 6001 (HTTPS) + 6000 (HTTP)

**Browser Behavior:**

- ✅ **MVC**: Opens browser automatically (main user interface)
- ✅ **OrderApi**: Opens Swagger documentation automatically
- ✅ **IdentityServer**: Runs silently (no browser - background service)

### **Inter-Service Communication** ✅

- **MVC → OrderApi**: Configured via `ApiSettings:OrderApiUrl` in appsettings.json
- **Automatic Discovery**: MVC reads API URL from configuration
- **No Hard-Coding**: All URLs configurable per environment

---

## ⚠️ **Known Issues & Notes**

### **Duende IdentityServer Warning**

- ✅ **Expected**: Low severity vulnerability warning on Duende.IdentityServer 7.0.7
- ✅ **Safe for exam**: This is a demo/learning setup, warning is acceptable
- 🔄 **In production**: Update to latest version

### **Build Order**

- ✅ **Automatic**: Projects build in correct dependency order
- ✅ **Shared → API → MVC → Identity**: Dependencies handled properly

### **Database Separation**

Each project has its own database:

- **MVC**: `BookHavenMvcDb`
- **OrderApi**: `BookHavenOrderDb`
- **IdentityServer**: `BookHavenIdentityDb`

### **Port Conflicts**

- ✅ **Pre-configured**: Each service uses different ports
- ✅ **No Conflicts**: Ports chosen to avoid common conflicts
- 🔧 **Customizable**: Change in `launchSettings.json` if needed

---

## 🎯 **For Development/Testing**

### **Safe to Build & Run**

- ✅ `.gitignore` excludes all build artifacts
- ✅ Can run `dotnet build` without affecting repo
- ✅ No `bin/` or `obj/` folders will be committed
- ✅ **F5 just works** - no setup required

### **Ready for Extensions**

- ✅ HTTP Client configured for MVC → API communication
- ✅ Project references set up correctly
- ✅ Separate configuration files for each service
- ✅ Swagger enabled for API development
- ✅ **Multi-startup configured** for immediate productivity

### **Template Foundation**

- ✅ Basic project structure established
- ✅ NuGet packages configured for each project type
- ✅ **Launch settings optimized** for development workflow
- ✅ Ready for adding models, controllers, views
- ✅ Authentication integration points prepared

---

## 🚀 **Next Steps for Students**

### **Immediate Development**

1. **Press F5** - verify all 3 services start correctly
2. **Check Swagger** - visit `https://localhost:7001/swagger` to see API docs
3. **Test MVC** - visit `https://localhost:5001` to see web interface
4. **Study configuration** - understand how services are connected

### **Progressive Enhancement**

1. **Add Entity Framework** - create DbContexts for each database
2. **Implement shared DTOs** - design contracts between services
3. **Create API controllers** - implement order management endpoints
4. **Build MVC controllers** - consume the API from web interface
5. **Configure authentication** - integrate IdentityServer with MVC and API

### **Advanced Integration**

1. **Test API calls** - implement MVC controllers that call OrderApi
2. **Handle errors** - add proper error handling for service communication
3. **Add authentication** - secure API endpoints and test with MVC
4. **Database migrations** - set up EF for each service

---

## 🏆 **Success Indicators**

**✅ Press F5 and see:**

- 3 console windows open (one for each service)
- MVC web app opens in browser at port 5001
- Swagger documentation opens at port 7001
- No port conflict errors in any console
- All services show "Now listening on..." messages

**✅ Ready for development when:**

- Can navigate between web app and API docs
- Can build solution without errors
- Can stop and restart all services cleanly
- Understand which service handles what functionality

---

## 🎓 **Educational Value**

This setup demonstrates:

- ✅ **Professional development workflow** - multi-project startup is industry standard
- ✅ **Microservices architecture** - separate services with clear boundaries
- ✅ **Configuration management** - externalized settings for flexibility
- ✅ **Development efficiency** - one-click start for complex systems
- ✅ **Real-world patterns** - mirrors actual enterprise development setups

**This is exactly what you'll encounter in professional development environments! 💼**

---

**Press F5 and start building! Everything is ready to go! 🚀**

# 🚀 Enhanced Launch Configuration Guide

## 📋 **Quick Reference**

### **Solution Launch Profiles** (BookHaven.slnLaunch)

| Profile Name                          | Use Case             | IdentityServer | OrderApi | MVC   |
| ------------------------------------- | -------------------- | -------------- | -------- | ----- |
| **All Services (Production-like)**    | Standard development | No Debug       | No Debug | Debug |
| **Development Mode (All Debug)**      | Full debugging       | Debug          | Debug    | Debug |
| **API Testing (API + Identity Only)** | API development      | No Debug       | Debug    | ❌    |
| **MVC Only (For UI Development)**     | Frontend work        | ❌             | ❌       | Debug |

### **Individual Project Profiles**

#### **BookHaven.MVC** (Port 5001)

- `https` - Standard HTTPS with browser (default)
- `https-no-browser` - HTTPS without auto-opening browser
- `Development` - Enhanced dev mode with hot reload
- `http` - HTTP only (for testing)
- `IIS Express` - IIS hosting

#### **BookHaven.OrderApi** (Port 7001)

- `https` - HTTPS without browser (background service)
- `https-swagger` - HTTPS with Swagger UI auto-open
- `http` - HTTP without browser
- `IIS Express` - IIS with Swagger

#### **BookHaven.IdentityServer** (Port 6001)

- `https` - HTTPS silent mode (default for background)
- `https-with-browser` - HTTPS with browser (for testing auth flows)
- `Development` - Enhanced logging for debugging
- `http` - HTTP silent mode
- `IIS Express` - IIS silent mode

---

## 🎯 **Usage Scenarios**

### **📚 Standard Development (Recommended)**

**Use Profile**: `All Services (Production-like)`

**What it does**:

- Starts IdentityServer and OrderApi without debugging (faster)
- Starts MVC with debugging (where you'll spend most time)
- Opens browser to MVC app automatically
- Minimal resource usage

**Visual Studio**: Press F5 or select from startup dropdown

**Expected URLs**:

- 🌐 MVC: `https://localhost:5001` (auto-opens)
- 🔧 API: `https://localhost:7001/swagger` (manual)
- 🔐 Auth: `https://localhost:6001` (background)

### **🔍 Full Debug Mode**

**Use Profile**: `Development Mode (All Debug)`

**What it does**:

- All services start with debugging enabled
- Can set breakpoints in any service
- Slower startup, higher resource usage
- Best for diagnosing cross-service issues

**When to use**:

- Debugging authentication flows
- Tracing API calls between services
- Complex integration issues

### **🔧 API Development**

**Use Profile**: `API Testing (API + Identity Only)`

**What it does**:

- Starts only API and auth services
- Focuses resources on backend
- Perfect for testing API endpoints
- Use Postman/Swagger for testing

**Workflow**:

1. Start this profile
2. Open `https://localhost:7001/swagger`
3. Test API endpoints directly
4. Develop new controllers/endpoints

### **🎨 Frontend Development**

**Use Profile**: `MVC Only (For UI Development)`

**What it does**:

- Starts only the MVC application
- For pure frontend/UI work
- Mock backend calls or work offline
- Fastest startup time

**When to use**:

- Working on Views/Razor pages
- CSS/JavaScript development
- UI/UX improvements
- Doesn't need real API data

---

## ⚡ **Quick Start Commands**

### **Visual Studio**

```bash
# Method 1: Dropdown selection
1. Click startup project dropdown in toolbar
2. Select desired profile
3. Press F5

# Method 2: Right-click solution
1. Right-click solution → "Configure Startup Projects"
2. Select "Multiple startup projects"
3. Configure manually
```

### **Command Line (Alternative)**

```bash
# Start specific services manually
cd BookHaven.IdentityServer && dotnet run --launch-profile https &
cd BookHaven.OrderApi && dotnet run --launch-profile https-swagger &
cd BookHaven.MVC && dotnet run --launch-profile Development
```

---

## 🔧 **Customization Guide**

### **Adding New Launch Profiles**

**Individual Project** (in `Properties/launchSettings.json`):

```json
{
  "profiles": {
    "YourCustomProfile": {
      "commandName": "Project",
      "dotnetRunMessages": true,
      "launchBrowser": false,
      "applicationUrl": "https://localhost:XXXX",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development",
        "YOUR_CUSTOM_SETTING": "value"
      }
    }
  }
}
```

**Solution Level** (in `BookHaven.slnLaunch`):

```json
{
  "Name": "Your Custom Scenario",
  "Projects": [
    {
      "Path": "ProjectName\\ProjectName.csproj",
      "Action": "Start" // or "StartWithoutDebugging"
    }
  ]
}
```

### **Port Configuration**

**Current Port Assignments**:

- MVC: 5000 (HTTP), 5001 (HTTPS)
- OrderApi: 7000 (HTTP), 7001 (HTTPS)
- IdentityServer: 6000 (HTTP), 6001 (HTTPS)

**To Change Ports**:

1. Update `applicationUrl` in respective `launchSettings.json`
2. Update cross-service configuration in `appsettings.json`
3. Update any hardcoded references

### **Environment Variables**

**Common Options**:

- `ASPNETCORE_ENVIRONMENT`: Development, Staging, Production
- `ASPNETCORE_LOGGING__CONSOLE__DISABLECOLORS`: true/false
- `SERILOG__MINIMUMLEVEL`: Debug, Information, Warning, Error

---

## 🚨 **Troubleshooting**

### **Profile Not Appearing in Visual Studio**

1. Close Visual Studio
2. Delete `.vs` folder
3. Reopen solution
4. Profiles should reappear

### **Services Start But Can't Communicate**

1. Check firewall settings
2. Verify ports aren't blocked
3. Check `appsettings.json` URLs match launch settings
4. Ensure all services are running on expected ports

### **Too Many Browser Windows**

**Problem**: Multiple browser tabs opening
**Solution**: Use profiles with `"launchBrowser": false` for background services

### **Debugging Not Working**

1. Ensure profile uses `"Action": "Start"` not `"StartWithoutDebugging"`
2. Check that project is set to Debug configuration
3. Verify breakpoints are in correct project

### **Hot Reload Not Working**

1. Use profiles with `"hotReloadEnabled": true`
2. Ensure .NET 6+ is being used
3. Check file watchers aren't blocked

---

## 📊 **Performance Comparison**

| Scenario                 | Startup Time | Memory Usage | Debug Capability |
| ------------------------ | ------------ | ------------ | ---------------- |
| All Services (Prod-like) | ~15s         | Low          | MVC Only         |
| Development Mode         | ~25s         | High         | All Services     |
| API Testing              | ~10s         | Medium       | API Only         |
| MVC Only                 | ~5s          | Very Low     | UI Only          |

---

## 🎓 **Best Practices**

### **For Learning/Practice**

- Start with "All Services (Production-like)"
- Use individual profiles to focus on specific areas
- Use "Development Mode" when debugging cross-service issues

### **For Exam Preparation**

- Practice starting services manually via command line
- Understand port configurations
- Know how to check service status

### **For Development**

- Use appropriate profile for your current task
- Don't run unnecessary services
- Monitor resource usage in Task Manager

### **For Debugging**

- Use "Development Mode" sparingly (high resource usage)
- Set breakpoints before starting services
- Use logging levels appropriately

---

## ✅ **Verification Checklist**

**After launch, verify**:

- [ ] Expected console windows are open
- [ ] Correct ports are being used
- [ ] Browser opens to intended services
- [ ] No error messages in console
- [ ] Services can communicate (check MVC → API calls)
- [ ] Authentication flows work (if implemented)

**Quick Test URLs**:

- [ ] `https://localhost:5001` - MVC homepage
- [ ] `https://localhost:7001/swagger` - API documentation
- [ ] `https://localhost:6001` - Identity server status

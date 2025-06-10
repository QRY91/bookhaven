# 🔧 Startup Configuration Troubleshooting

**If Visual Studio only starts one project instead of all three, follow these steps:**

## 🎯 **Method 1: Manual Configuration (Recommended)**

### **1. Right-click the Solution in Solution Explorer**

- Select **"Configure Startup Projects..."** or **"Set Startup Projects..."**

### **2. Select "Multiple startup projects"**

- In the dialog, choose **"Multiple startup projects"** radio button

### **3. Set Action to "Start" for these projects:**

- ✅ **BookHaven.MVC** → Action: **Start**
- ✅ **BookHaven.OrderApi** → Action: **Start**
- ✅ **BookHaven.IdentityServer** → Action: **Start**
- ❌ **BookHaven.Shared** → Action: **None** (it's a library)

### **4. Click OK and press F5**

- Visual Studio should now start all 3 projects
- 3 console windows should appear
- 2 browser tabs should open (MVC + Swagger)

---

## 🎯 **Method 2: Check Existing Configuration**

If the automatic configuration isn't working:

### **1. Verify Files Exist:**

```bash
# Check if startup configuration file exists
ls -la .vs/BookHaven/v17/Solution.VisualStudio.StartupProjects
```

### **2. If file is missing, recreate it:**

- Close Visual Studio
- Delete the `.vs` folder completely
- Reopen the solution in Visual Studio
- Follow Method 1 steps above

### **3. Verify Launch Settings:**

Check that each project has correct `Properties/launchSettings.json`:

- **MVC**: Port 5001, launches browser
- **OrderApi**: Port 7001, launches browser to Swagger
- **IdentityServer**: Port 6001, no browser

---

## 🚨 **Common Issues & Fixes**

### **Issue: "localhost:5001 can't be found" (404 Error)**

**Cause**: Only MVC started, but API isn't running

**Fix**:

1. Ensure **all 3 projects** are set to start (Method 1 above)
2. If still fails, manually start API first:
   ```bash
   cd BookHaven.OrderApi
   dotnet run
   ```
3. Then start MVC in another terminal:
   ```bash
   cd BookHaven.MVC
   dotnet run
   ```

### **Issue: "Port already in use" errors**

**Cause**: Previous instances still running

**Fix**:

1. Stop all debugging (Shift+F5)
2. Check Task Manager for `dotnet.exe` processes and end them
3. Try again

### **Issue: Only one project shows as startup project**

**Cause**: Visual Studio defaulted to single project mode

**Fix**:

1. Look for startup project dropdown in toolbar
2. If it shows single project name, right-click solution → Configure Startup Projects
3. Follow Method 1 steps

### **Issue: Swagger doesn't open automatically**

**Cause**: Launch settings issue

**Fix**:

1. Check `BookHaven.OrderApi/Properties/launchSettings.json`
2. Ensure `"launchUrl": "swagger"` is present
3. Or manually navigate to `https://localhost:7001/swagger`

---

## ✅ **Success Indicators**

**When everything works correctly, you should see:**

### **Console Windows (3 total):**

```
BookHaven.MVC: Now listening on https://localhost:5001
BookHaven.OrderApi: Now listening on https://localhost:7001
BookHaven.IdentityServer: Now listening on https://localhost:6001
```

### **Browser Tabs (2 total):**

- **Tab 1**: `https://localhost:5001` - BookHaven home page with project status
- **Tab 2**: `https://localhost:7001/swagger` - API documentation

### **No Error Messages:**

- No "port in use" errors
- No "can't connect" errors
- No 404 errors

---

## 🛠️ **Manual Testing**

If automatic startup fails, test each service individually:

### **1. Test Order API:**

```bash
cd BookHaven.OrderApi
dotnet run
```

- Should start on port 7001
- Navigate to `https://localhost:7001/swagger`
- Should see API documentation

### **2. Test MVC (with API running):**

```bash
cd BookHaven.MVC
dotnet run
```

- Should start on port 5001
- Navigate to `https://localhost:5001`
- Should see BookHaven homepage with service status

### **3. Test Identity Server:**

```bash
cd BookHaven.IdentityServer
dotnet run
```

- Should start on port 6001
- Navigate to `https://localhost:6001`
- Should see basic identity server page

---

## 📞 **Still Having Issues?**

### **Quick Diagnostic:**

1. **Check ports**: Are other applications using ports 5001, 6001, or 7001?
2. **Check firewall**: Is Windows Firewall blocking the connections?
3. **Check Visual Studio version**: This configuration works with VS 2022
4. **Check project references**: Run `dotnet build BookHaven.sln` to verify all projects compile

### **Last Resort: Command Line Startup**

If Visual Studio configuration continues to fail:

```bash
# Terminal 1 - Start API
cd BookHaven.OrderApi && dotnet run

# Terminal 2 - Start Identity (new terminal)
cd BookHaven.IdentityServer && dotnet run

# Terminal 3 - Start MVC (new terminal)
cd BookHaven.MVC && dotnet run
```

Then manually open:

- `https://localhost:5001` (MVC)
- `https://localhost:7001/swagger` (API)

---

**Remember**: The goal is to have all 3 services running simultaneously so they can communicate with each other! 🚀\*\*

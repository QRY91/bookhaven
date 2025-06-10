var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorPages();

// Add IdentityServer
builder.Services.AddIdentityServer()
    .AddDeveloperSigningCredential(); // Only for demo - use real certificates in production

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();
app.UseIdentityServer();

app.MapRazorPages();

app.Run(); 
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

var app = builder.Build();
app.Urls.Add("http://+:5501");

app.MapGet( "/", () =>  $"Hello World! The time now is {DateTime.Now}" );

app.Run();

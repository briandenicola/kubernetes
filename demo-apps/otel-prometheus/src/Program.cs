var builder = WebApplication.CreateBuilder(args);

builder.WebHost.ConfigureKestrel(serverOptions =>
{
    serverOptions.ListenAnyIP(9090);
    serverOptions.ListenAnyIP(5000);
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddOpenTelemetry()
    .ConfigureResource(resource => resource.AddService(serviceName: builder.Environment.ApplicationName))
    .WithMetrics(metrics => metrics
        .AddAspNetCoreInstrumentation()
        .AddRuntimeInstrumentation()
        .AddHttpClientInstrumentation()
        .AddConsoleExporter()
        .AddPrometheusExporter()
    );

var app = builder.Build();
app.MapGet("/", () => "Hello World!");
app.MapGet("/weather", SendWeatherForecast);
app.MapPrometheusScrapingEndpoint().RequireHost("*:9090");
app.Run();

IEnumerable<WeatherForecast> SendWeatherForecast()
{
    string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    var weatherType = Summaries[Random.Shared.Next(Summaries.Length)];

    return Enumerable.Range(1, 5).Select(index => new WeatherForecast
    {
        Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
        TemperatureC = Random.Shared.Next(-20, 55),
        Summary = weatherType
    })
    .ToArray();
}
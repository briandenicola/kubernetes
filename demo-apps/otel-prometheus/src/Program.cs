var builder = WebApplication.CreateBuilder(args);
https://github.com/open-telemetry/opentelemetry-dotnet/issues/5502
builder.WebHost.ConfigureKestrel(serverOptions =>
{
    serverOptions.ListenAnyIP(9090);
    serverOptions.ListenAnyIP(5000);
});

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddOpenTelemetry()
    .UseAzureMonitor( o => {  
        o.ConnectionString = builder.Configuration["APP_INSIGHTS_CONNECTION_STRING"];
        o.SamplingRatio = 0.1F; 
    })
    .ConfigureResource(resource => resource.AddService(serviceName: builder.Environment.ApplicationName))
    .WithMetrics(metrics => metrics
        .AddAspNetCoreInstrumentation()
        .AddHttpClientInstrumentation()
        .AddRuntimeInstrumentation()
        .AddMeter("Microsoft.AspNetCore.Hosting")
        .AddMeter("Microsoft.AspNetCore.Routing")
        .AddMeter("Microsoft.AspNetCore.Diagnostics")
        .AddMeter("Microsoft.AspNetCore.Server.Kestrel")
        .AddMeter("Microsoft.AspNetCore.Http.Connections")
        .AddMeter("Microsoft.Extensions.Diagnostics.HealthChecks")
        .SetMaxMetricStreams(500)
        .SetMaxMetricPointsPerMetricStream(200)
        .AddConsoleExporter()
        .AddPrometheusExporter(o => o.DisableTotalNameSuffixForCounters = true) //https://github.com/open-telemetry/opentelemetry-dotnet/issues/5502
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
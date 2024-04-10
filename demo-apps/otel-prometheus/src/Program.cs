var builder = WebApplication.CreateBuilder(args);

builder.WebHost.ConfigureKestrel(serverOptions =>
{
    serverOptions.ListenAnyIP(9090);
    serverOptions.ListenAnyIP(5000);
});

var weatherMeter = new Meter("BJD.Example", "1.0.0");
var countWeather = weatherMeter.CreateCounter<int>("weather.count", description: "Counts the number of weather forecasts sent");
var weatherActivitySource = new ActivitySource("BJD.Example");
var tracingOtlpEndpoint = builder.Configuration["OTLP_ENDPOINT_URL"];

var otel = builder.Services.AddOpenTelemetry();
    // .UseAzureMonitor( o => {
    //     o.SamplingRatio = 0.1F;
    // });

otel.ConfigureResource(resource => resource
    .AddService(serviceName: builder.Environment.ApplicationName));

otel.WithMetrics(metrics => metrics
    .AddAspNetCoreInstrumentation()
    .AddMeter(weatherMeter.Name)
    .AddMeter("Microsoft.AspNetCore.Hosting")
    .AddMeter("Microsoft.AspNetCore.Server.Kestrel")
    .AddPrometheusExporter());

otel.WithTracing(tracing =>
{
    tracing.AddAspNetCoreInstrumentation();
    tracing.AddHttpClientInstrumentation();
    tracing.AddSource(weatherActivitySource.Name);
    if (tracingOtlpEndpoint != null)
    {
        tracing.AddOtlpExporter(otlpOptions =>
         {
             otlpOptions.Endpoint = new Uri(tracingOtlpEndpoint);
         });
    }
    else
    {
        tracing.AddConsoleExporter();
    }
});

var app = builder.Build();
app.MapGet("/", () => "Hello World!");
app.MapGet("/weather", SendWeatherForecast);
app.UseOpenTelemetryPrometheusScrapingEndpoint( context =>  context.Connection.LocalPort == 9090 );
app.Run();

IEnumerable<WeatherForecast> SendWeatherForecast(Logger<Program> _logger)
{
    string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    var weatherType = Summaries[Random.Shared.Next(Summaries.Length)];

    using var activity = weatherActivitySource.StartActivity("WeatherForecastActivity");
    _logger.LogInformation("Sending Weather Forecast");
    countWeather.Add(1);
    activity?.SetTag("Weather Forecast", weatherType);

    return Enumerable.Range(1, 5).Select(index => new WeatherForecast
    {
        Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
        TemperatureC = Random.Shared.Next(-20, 55),
        Summary = weatherType
    })
    .ToArray();
}
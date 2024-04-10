var forecastMeter = new Meter("bjd.example.forecasts", "1.0.0");
var countForecasts = forecastMeter.CreateCounter<int>("forecasts.count", description: "Counts the number of forecats sent");
var forecastActivitySource = new ActivitySource("bjd.example");

var builder = WebApplication.CreateBuilder(args);

builder.WebHost.ConfigureKestrel(serverOptions =>
{
    serverOptions.ListenAnyIP(9090);
    serverOptions.ListenAnyIP(5000);
});

var tracingOtlpEndpoint = builder.Configuration["OTLP_ENDPOINT_URL"];

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var otel = builder.Services.AddOpenTelemetry()
    .UseAzureMonitor( o => {
        o.SamplingRatio = 0.1F;
    });

otel.ConfigureResource(resource => resource
    .AddService(serviceName:"bjd-example"));

otel.WithMetrics(metrics => metrics
    .AddAspNetCoreInstrumentation()
    .AddMeter(forecastMeter.Name)
    .AddMeter("Microsoft.AspNetCore.Hosting")
    .AddMeter("Microsoft.AspNetCore.Server.Kestrel")
    .AddPrometheusExporter());

// Add Tracing for ASP.NET Core and our custom ActivitySource and export to Jaeger
otel.WithTracing(tracing =>
{
    tracing.AddAspNetCoreInstrumentation();
    tracing.AddHttpClientInstrumentation();
    tracing.AddSource(forecastActivitySource.Name);
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

app.UseOpenTelemetryPrometheusScrapingEndpoint( context =>  context.Connection.LocalPort == 9090 );
app.MapControllers();

app.Run();

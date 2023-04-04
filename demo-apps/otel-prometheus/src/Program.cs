
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddOpenTelemetry()
    .ConfigureResource(builder => builder.AddService(serviceName: "bjd-example"))
    .WithTracing(builder => builder.AddConsoleExporter())
    .WithMetrics(builder => {
        builder.AddRuntimeInstrumentation()
               .AddHttpClientInstrumentation()
               .AddAspNetCoreInstrumentation()
               .AddConsoleExporter()
               .AddPrometheusExporter();
    });


var app = builder.Build();

app.UseOpenTelemetryPrometheusScrapingEndpoint();
app.MapControllers();

app.Run();


var builder = WebApplication.CreateBuilder(args);

builder.WebHost.ConfigureKestrel(serverOptions =>
{
    serverOptions.ListenAnyIP(9090);
    serverOptions.ListenAnyIP(5000);
});

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

app.UseOpenTelemetryPrometheusScrapingEndpoint( context =>  context.Connection.LocalPort == 9090 );
app.MapControllers();

app.Run();

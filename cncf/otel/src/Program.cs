var serviceName = "bjdazure.otel-demo.hello-service";
var serviceVersion = "1.0.0";
var activitySource = new ActivitySource(serviceName);

var builder = WebApplication.CreateBuilder(args);

var appResourceBuilder = ResourceBuilder.CreateDefault()
    .AddService(serviceName: serviceName, serviceVersion: serviceVersion);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddOpenTelemetry().WithTracing(tracerProviderBuilder =>
{
    tracerProviderBuilder
        .AddConsoleExporter()
        .AddZipkinExporter(o =>
        {
            o.Endpoint = new Uri("otel-collector.otel-system.svc.cluster.local:9411");
        })
        .AddOtlpExporter(opt =>
        {
            opt.Protocol = OtlpExportProtocol.HttpProtobuf;
        })
        .AddSource(activitySource.Name)
        .SetResourceBuilder(appResourceBuilder)
        .AddHttpClientInstrumentation()
        .AddAspNetCoreInstrumentation()
        .AddSqlClientInstrumentation();
});

var meter = new Meter(serviceName);
var counter = meter.CreateCounter<long>("app.request-counter");
builder.Services.AddOpenTelemetry().WithMetrics(metricProviderBuilder =>
{
    metricProviderBuilder
        .AddOtlpExporter(opt =>
        {
            opt.Protocol = OtlpExportProtocol.HttpProtobuf;
        })
        .AddMeter(meter.Name)
        .SetResourceBuilder(appResourceBuilder)
        .AddAspNetCoreInstrumentation()
        .AddHttpClientInstrumentation();
});

var app = builder.Build();

app.MapGet("/hello", () =>
{
    using var activity = activitySource.StartActivity("SayHello");
    activity?.SetTag("foo", 1);
    activity?.SetTag("bar", "Hello, World!");
    activity?.SetTag("baz", new int[] { 1, 2, 3 });
    counter.Add(1);

    return "Hello, World!";
});

app.Run();

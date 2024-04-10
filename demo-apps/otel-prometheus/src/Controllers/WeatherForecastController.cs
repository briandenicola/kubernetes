using System.Diagnostics.Metrics;
using Microsoft.AspNetCore.Mvc;

namespace otel_prometheus.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    private readonly ILogger<WeatherForecastController> _logger;
    private Counter<int> _countForecasts;
    private ActivitySource _forecastActivitySource;

    public WeatherForecastController(ILogger<WeatherForecastController> logger, Counter<int> countForecasts, ActivitySource forecastActivitySource)
    {
        _logger = logger;
        _countForecasts = countForecasts;
        _forecastActivitySource = forecastActivitySource;
    }

    [HttpGet(Name = "GetWeatherForecast")]
    public IEnumerable<WeatherForecast> Get()
    {
        using var activity = _forecastActivitySource.StartActivity("WeatherForecastActivity");
        _logger.LogInformation("Sending Weather Forecast");
        _countForecasts.Add(1);
        activity?.SetTag("greeting", "Hello World!");

        return Enumerable.Range(1, 5).Select(index => new WeatherForecast
        {
            Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
            TemperatureC = Random.Shared.Next(-20, 55),
            Summary = Summaries[Random.Shared.Next(Summaries.Length)]
        })
        .ToArray();
    }
}

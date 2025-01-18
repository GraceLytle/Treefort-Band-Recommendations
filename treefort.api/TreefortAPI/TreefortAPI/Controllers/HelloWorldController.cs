using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace TreefortAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class HelloWorldController : ControllerBase
    {
        private readonly ILogger<HelloWorldController> _logger;

        public HelloWorldController(ILogger<HelloWorldController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        [Route("world")]
        public IActionResult Get()
        {
            var message = new { Message = "Hello" };
            return new JsonResult(message);
        }

        [HttpPost]
        [Route("smallworld")]
        public IActionResult smallWorld([FromBody]WeatherForecast wf)
        {
            var message = new { Message = $"Hello {wf.Summary}" };
            return new JsonResult(message);
        }
    }
}

using Ganss.Xss;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Treefort.lib.DAL.Data.Model;
using Treefort.lib.DAL.Data.Services;
using TreefortAPI.Models;

[Authorize]
[ApiController]
[Route("api/userPreference")]
public class UserPreferenceController : ControllerBase
{

    private UserPreferenceService _userPreferenceService;
    public UserPreferenceController()
    {
        _userPreferenceService = new UserPreferenceService();
    }

    // GET: api/userPreference
    [HttpGet]
    [Route("survey")]
    public IActionResult GetUserPreference()
    {
        var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;

        if (userId == null)
        {
            return Unauthorized("User not authenticated.");
        }

        // Retrieve the user's preferences from the database
        var userEmail = User.FindFirst(ClaimTypes.Email)?.Value;
        var currentUser = _userPreferenceService.GetUser(userEmail);
        if (currentUser != null)
        {
            return new JsonResult(new UserPreference
            {

                Name = currentUser.PreferredName,
                BandOrigin = currentUser.Location,
                Popularity = currentUser.Popularity ?? 1,
                Genres = currentUser.MusicCategories.Select(c => c.Name).ToList(),

            });

        }
        else
        {
            return Ok();
        }

    }


    // POST: api/userPreference/survey
    [HttpPost]
    [Route("survey")]
    public IActionResult SubmitName([FromBody] UserPreference model)
    {
        if (model == null)
        {
            return BadRequest("Name is required.");
        }

        HtmlSanitizer sanitizer = new HtmlSanitizer();
        model.Name = sanitizer.Sanitize(model.Name);
        
        // Get the user's claims
        var userClaims = User.Claims.Select(c => new { c.Type, c.Value }).ToList();

        // Optional: Retrieve specific claims
        var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
        var userEmail = User.FindFirst(ClaimTypes.Email)?.Value;
        var userName = User.FindFirst("profile")?.Value;
        int userID = 0;
        var currentUser = _userPreferenceService.GetUser(userEmail);

        //musicCategories are named Genres on the other side...
        if (currentUser == null)
        {
            userID = _userPreferenceService.InsertUser(userName, model.Name, userEmail, model.Genres, model.BandOrigin, model.Popularity);

        }
        else
        {
            userID = currentUser.ID;
            currentUser.PreferredName = model.Name;
            currentUser.Location = model.BandOrigin;
            currentUser.Popularity = model.Popularity;
            currentUser.Name = userName;
            _userPreferenceService.UpdateUser(currentUser, model.Genres);
        }


        /*
         * TODO need to add categories
         * Get current logged in person auth0 ana
         * Create User Account User in user table
         * If the user table does exsist get their id
         * insert record into userprefernce unless upsert
         * 
         */
        // Create a new entry and save it to the database
        // _userPreferenceService.InsertName(model.Name);

        return Ok(new { message = "Name submitted successfully" });
    }


}








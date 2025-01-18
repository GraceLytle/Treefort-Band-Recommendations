using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Treefort.lib.DAL.Data.Model;
using Treefort.lib.DAL.Data.Services;
using TreefortAPI.Models;


[ApiController]
[Route("api/musician")]
public class MusicianController : ControllerBase
{

    private MusicianService _musicianService;

    public MusicianController()
    {
        _musicianService = new MusicianService();
    }

    [HttpGet]
    [Route("artists")]
    public IActionResult GetArtist()
    {

        var artists = _musicianService.GetArtistInfo();
        var response = new { artists = artists };
        return Ok(response);
    }

    [Authorize]
    [HttpGet]
    [Route("recommendations")]
    public IActionResult GetRecommendation()
    {
        var userEmail = User.FindFirst(ClaimTypes.Email)?.Value;
        if (string.IsNullOrEmpty(userEmail)) {

            return Unauthorized("User email not found.");
        }

        var artistData = _musicianService.GetArtistRecommendation(userEmail);
        var artist = artistData.Select(a => new
            {
                Name = a.Name,
                Hometown = a.Hometown ?? "",
                Location = a.Location ?? "",
                Image = a.Image,
                Popularity = a.Popularity ?? 0,
                Genres = a.GenreList?.Split('|').Distinct().ToList() ?? new List<string>(),
                Categories = a.CategoryList?.Split('|').Distinct().ToList() ?? new List<string>(),
                Tracks = a.TrackTitleList?.Split('|').Distinct().ToList() ?? new List<string>(),
            }).ToList();
        var response = new { artists = artist };
        return Ok(response);
    } 

}

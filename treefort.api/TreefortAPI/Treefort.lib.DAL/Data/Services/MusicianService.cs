using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Treefort.lib.DAL.Data.Model;
using Treefort.lib.DAL.Models;

namespace Treefort.lib.DAL.Data.Services
{

    public class MusicianService
    {
        private Data.Model.Entities _ent;


        public MusicianService()
        {
            _ent = new Data.Model.Entities();
        }

        public int InsertMusician(String name)
        {
            try
            {
                NameEntry item = new NameEntry();
                item.Name = name;

                _ent.NameEntries.Add(item);
                _ent.SaveChanges();

                return item.Id;

            }
            catch (Exception)
            {
                return 0;
            }
        }
      

        public List<ArtistDTO> GetArtistInfo(string categoryFilter = null)
        {
            var artists = _ent.Artists
                .Include("Genres.MusicCategories")
                .Include("Genres")
                .Include("Tracks")
                .Include("Location")
                .ToList();

            var artistDtos = artists
                //.Where(p => p.Name.Contains("Bright"))
                .Select(a => new ArtistDTO
                {
                    Name = a.Name,
                    Hometown = a.Hometown,
                    Location = a.Location?.Name ?? "",
                    Image = a.ImageURL,
                    Popularity = a.Popularity ?? 0,
                    Genres = a.Genres.Select(g => g.Name).ToList(),
                    Categories = a.Genres
                    .SelectMany(g => g.MusicCategories.Select(mc => mc.Name))
                    .Distinct()
                    .ToList(),
                    Tracks = a.Tracks.Select(t => t.Title).ToList(),
                }).ToList();

            return artistDtos;
        }

        public List<UserRecommendation_Result> GetArtistRecommendation(string userEmail)
        {
            var result = _ent.UserRecommendation(userEmail).ToList();

            return result;
        }

    }


}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Treefort.lib.DAL.Models
{
   
    public class ArtistDTO
    {
        public string Name { get; set; }
        public string Hometown { get; set; }
        public List<string> Genres { get; set; }
        public List<string> Tracks { get; set; }
        public List<string> Categories { get; set; }
        public String Location { get; set; }
        public string Image { get; set; }
        public int Popularity { get; set; }
    }

}

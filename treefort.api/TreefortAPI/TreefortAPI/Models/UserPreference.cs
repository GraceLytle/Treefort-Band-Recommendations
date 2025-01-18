namespace TreefortAPI.Models
{
    public class UserPreference
    {
        public string Name { get; set; }
        public List<string> Genres { get; set; }
        public string BandOrigin { get; set; }
        public int Popularity { get; set; }

    }
}

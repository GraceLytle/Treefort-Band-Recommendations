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

    public class UserPreferenceService
    {
        private Data.Model.Entities _ent;


        public UserPreferenceService()
        {
            _ent = new Data.Model.Entities();
        }

        public int InsertUser(string name, string preferredName, string email, List<string> musicCategories, string location, int popularity)
        {
            try
            {
                User item = new User
                {
                    Name = name,
                    PreferredName = preferredName,
                    Email = email,
                    Location = location,
                    Popularity = popularity,
                    MusicCategories = new List<MusicCategory>()
                };

                _ent.Users.Add(item);

                // Only proceed if there are music categories to add
                if (musicCategories != null && musicCategories.Count > 0)
                {
                    // Fetch all available music categories once
                    var availableMC = _ent.MusicCategories.ToList();

                    // Match each category name in musicCategories to the available categories in the database
                    foreach (string categoryName in musicCategories)
                    {
                        var matchedCategory = availableMC
                            .FirstOrDefault(mc => mc.Name.Equals(categoryName, StringComparison.OrdinalIgnoreCase));

                        if (matchedCategory != null)
                        {
                            item.MusicCategories.Add(matchedCategory);
                        }
                    }
                }

                _ent.SaveChanges();
                return item.ID;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error inserting user: {ex.Message}");
                return 0;
            }
        }

        public User GetUser(String email)
        {
            var result = _ent.Users.Include("MusicCategories").FirstOrDefault(x => x.Email == email);
            return result;
        }


        public void UpdateUser(User currentUser, List<string> genres)
        {
            try
            {
                var existingUser = _ent.Users.Include("MusicCategories").FirstOrDefault(x => x.ID == currentUser.ID);

                if (existingUser != null)
                {
                    // Update the basic properties of the existing user
                    existingUser.Name = currentUser.Name;
                    existingUser.PreferredName = currentUser.PreferredName;
                    existingUser.Email = currentUser.Email;
                    existingUser.Location = currentUser.Location;
                    existingUser.Popularity = currentUser.Popularity;

                    // Update Music Categories
                    if (currentUser.MusicCategories != null)
                    {
                        // Clear the existing music categories
                        existingUser.MusicCategories.Clear();
                    }

                        // Find all matching categories in the database
                        var availableMC = _ent.MusicCategories.ToList();
                        foreach (var category in genres)
                        {
                            // Match by category name case insensitive
                            var matchedCategory = availableMC
                                .FirstOrDefault(mc => mc.Name.Equals(category, StringComparison.OrdinalIgnoreCase));

                            if (matchedCategory != null)
                            {
                                existingUser.MusicCategories.Add(matchedCategory);
                            }
                        }

                    // Save changes to the database
                    _ent.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                
                Console.WriteLine($"Error updating user: {ex.Message}");
            }
        }

    }


}

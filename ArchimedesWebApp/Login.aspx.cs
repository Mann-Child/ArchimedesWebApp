using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArchimedesWebApp
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Get the windows user ID, ex. studentnet/000000
            var user = User.Identity.Name;

            // Get the last 6 characters in ID, ex. 000000
            user = user.Substring(user.Length - 6, 6);

            
        }
    }
}
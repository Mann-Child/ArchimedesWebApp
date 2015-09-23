using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArchimedesWebApp
{
    public partial class TeamDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblTeamName.Text = Session["TeamName"].ToString();
        }

        protected void btnAssignToTeam_Click(Object sender, EventArgs e)
        {
            dsUsers.Insert();
            gvTeamMembers.DataBind();
        }

        protected void btnFullName_Command(Object sender, CommandEventArgs e)
        {
            String[] args = new String[2];
            args = e.CommandArgument.ToString().Split(';');
            Session["UserID"] = args[0];
            Session["UserName"] = args[1];

            Response.Redirect("~/MemberDashboard.aspx");
        }
        protected void btnUserDelete_Command(Object sender, CommandEventArgs e)
        {
            hfDeleteUserKey.Value = e.CommandArgument.ToString();
            dsTeamMembers.Delete();
        }
    }
}
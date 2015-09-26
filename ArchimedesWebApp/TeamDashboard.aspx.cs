using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace ArchimedesWebApp
{
    public partial class TeamDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (HttpContext.Current.Session["username"] == null)
            {
                string current_login_id = HttpContext.Current.User.Identity.Name;
                string current_user_id = current_login_id.Substring(current_login_id.LastIndexOf('\\') + 1);
                HttpContext.Current.Session["username"] = current_user_id;
            }
            lblTeamName.Text = Session["TeamName"].ToString();
        }

        protected void btnAssignToTeam_Click(Object sender, EventArgs e)
        {
            dsUsers.Insert();
            gvTeamMembers.DataBind();
        }

        protected void cbTeamLeaderVisible_CheckedChanged(Object sender, EventArgs e)
        {
            hfTeamLeaderVisible.Value = cbTeamLeaderVisible.Checked ? "Y" : "N";
        }

        protected void cbGenerallyVisible_CheckedChanged(Object sender, EventArgs e)
        {
            hfGenerallyVisible.Value = cbGenerallyVisible.Checked ? "Y" : "N";
        }

        protected void btnCreateComment_Click(Object sender, EventArgs e)
        {
            dsTeamComments.Insert();
            txtTeamComment.Text = String.Empty;
        }

        protected void btnFullName_Command(Object sender, CommandEventArgs e)
        {
            String[] args = new String[2];
            args = e.CommandArgument.ToString().Split(';');
            Session["UserID"] = args[0];
            Session["MemberName"] = args[1];

            Response.Redirect("~/MemberDashboard.aspx");
        }
        protected void btnUserDelete_Command(Object sender, CommandEventArgs e)
        {
            hfDeleteUserKey.Value = e.CommandArgument.ToString();
            dsTeamMembers.Delete();
        }
    }
}
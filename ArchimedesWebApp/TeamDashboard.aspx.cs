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
            string tl_id;
            string pm_id;
            if (HttpContext.Current.Session["username"] == null)
            {
                string current_login_id = HttpContext.Current.User.Identity.Name;
                string current_user_id = current_login_id.Substring(current_login_id.LastIndexOf('\\') + 1);
                HttpContext.Current.Session["username"] = current_user_id;
            }
            lblTeamName.Text = Session["TeamName"].ToString();

            string ArchimedesConnectionString = "Data Source=csdb;Initial Catalog=SEI_Archimedes;Integrated Security=True;";
            SqlConnection connection = new SqlConnection(ArchimedesConnectionString);

            using (connection)
            {
                SqlCommand get_team_key = new SqlCommand(@"SELECT ISNULL([team_leader_user_id], ''), ISNULL([pm_user_id], '')
                                                             FROM [SEI_Archimedes].[dbo].[Teams]
                                                            WHERE [SEI_Archimedes].[dbo].[Teams].[team_key] = " + HttpContext.Current.Session["TeamKey"] + ";", connection);
                connection.Open();
                SqlDataReader reader = get_team_key.ExecuteReader();
                reader.Read();
                tl_id = reader.GetString(0);
                pm_id = reader.GetString(1);
                reader.Close();
                connection.Close();
            }

            if (tl_id != String.Empty)
            {
                gvTeamMembers.Columns[4].Visible = false;
            }

            if (HttpContext.Current.Session["username"].ToString() != pm_id && HttpContext.Current.Session["username"].ToString() != tl_id && HttpContext.Current.Session["username"].ToString() != HttpContext.Current.Session["ceo_id"].ToString())
            {
                cbTeamLeaderVisible.Visible = false;
                cbTeamLeaderVisible.Checked = false;
                cbGenerallyVisible.Visible = false;
                lblTeamLeaderVisible.Visible = false;
                lblGenerallyVisible.Visible = false;
                gvTlComments.Visible = false;
            }
            if(HttpContext.Current.Session["username"].ToString() != HttpContext.Current.Session["ceo_id"].ToString())
            {
                CEOseeing.Visible = false;
            }
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
                gvTlComments.DataBind();

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
            hfDeleteUserID.Value = e.CommandArgument.ToString();
            dsTeamMembers.Delete();
        }

        protected void btnMakeTeamLeader_Command(object sender, CommandEventArgs e)
        {
            hfMakeTLUserID.Value = e.CommandArgument.ToString();
            dsTeamMembers.Update();
            gvTeamMembers.DataBind();
        }
    }
}
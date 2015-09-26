using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace ArchimedesWebApp
{
    public partial class CEODashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            String ceo_id;

            // Create Data Source Connection String
            string TimeMachineconnection = "Data Source=csdb;Initial Catalog=SEI_TimeMachine2;Integrated Security=True;";
            SqlConnection connection1 = new SqlConnection(TimeMachineconnection);

            /*if (HttpContext.Current.Session["username"] == null)
            {
                string current_login_id = HttpContext.Current.User.Identity.Name;
                string current_user_id = current_login_id.Substring(current_login_id.LastIndexOf('\\') + 1);
                HttpContext.Current.Session["username"] = current_user_id;
            }*/
            HttpContext.Current.Session["username"] = "mgeary";
            using (connection1)
            {
                // Get CEO ID
                SqlCommand get_ceo_id = new SqlCommand(@"SELECT [user_id]
                                                             FROM [SEI_TimeMachine2].[dbo].[USER]
                                                            WHERE [user_is_manager] = 1
                                                              AND [user_is_teacher] = 1;", connection1);
                connection1.Open();
                SqlDataReader reader = get_ceo_id.ExecuteReader();
                reader.Read();
                ceo_id = reader.GetString(0);
                reader.Close();
                connection1.Close();
            }

            if(ceo_id != HttpContext.Current.Session["username"].ToString())
            {
                // Create Data Source Connection String
                string ArchimedesConnectionString = "Data Source=csdb;Initial Catalog=SEI_Archimedes;Integrated Security=True;";
                SqlConnection connection2 = new SqlConnection(ArchimedesConnectionString);

                using (connection2)
                {
                    // Get Team Key
                    SqlCommand get_team_key = new SqlCommand("SELECT [team_key] FROM[SEI_Archimedes].[dbo].[Team_Linking] WHERE [user_id] = " + HttpContext.Current.Session["username"] + ";", connection2);
                    connection2.Open();
                    SqlDataReader reader = get_team_key.ExecuteReader();
                    reader.Read();
                    HttpContext.Current.Session["TeamKey"] = reader.GetValue(0);
                    reader.Close();
                    connection2.Close();

                    // Get Team Name
                    SqlCommand get_team_name = new SqlCommand("SELECT [team_name] FROM [SEI_Archimedes].[dbo].[Teams] WHERE [team_key] = " + HttpContext.Current.Session["TeamKey"] + ";", connection2);
                    connection2.Open();
                    reader = get_team_name.ExecuteReader();
                    reader.Read();
                    Session["TeamName"] = reader.GetString(0);
                    reader.Close();
                    connection2.Close();
                }
                Response.Redirect("~/TeamDashboard.aspx");
            }
        }

        protected void btnTeamName_Command(Object sender, CommandEventArgs e)
        {
            String[] args = new String[2];
            args = e.CommandArgument.ToString().Split(';');
            Session["TeamKey"] = args[0];
            Session["TeamName"] = args[1];

            Response.Redirect("~/TeamDashboard.aspx");
        }

        protected void cbViewOldTeams_CheckedChanged(Object sender, EventArgs e)
        {
            hfViewOldTeams.Value = cbViewOldTeams.Checked ? "Y" : "N";
            gvTeams.DataBind();
        }

        protected void btnTeamDelete_Command(Object sender, CommandEventArgs e)
        {
            hfDeleteTeamKey.Value = e.CommandArgument.ToString();
            dsTeams.Delete();
            dsUsers.Delete();
        }

        protected void btnCreateTeam_Click(Object sender, EventArgs e)
        {
            dsTeams.Insert();
            gvTeams.DataBind();
        }
    }
}
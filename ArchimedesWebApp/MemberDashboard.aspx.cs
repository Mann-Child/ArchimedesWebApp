using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace ArchimedesWebApp
{
    public partial class MemberDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblMemberName.Text = Session["MemberName"].ToString();
        }

        protected void btnCreateComment_Click(object sender, EventArgs e)
        {
            dsMemberComments.Insert();
            txtMemberComment.Text = String.Empty;

            if (Session["MemberName"] == null)
            {
                string TimeMachineConnectionString = "Data Source=csdb;Initial Catalog=SEI_Archimedes;Integrated Security=True;";
                SqlConnection connection = new SqlConnection(TimeMachineConnectionString);

                using (connection)
                {
                    SqlCommand get_team_key = new SqlCommand(@"SELECT [user_last_name] + ', ' + [user_first_name]
                                                                 FROM [SEI_TimeMachine2].[dbo].[USER]
                                                                WHERE [user_id] = " + HttpContext.Current.Session["username"] + ";", connection);
                    connection.Open();
                    SqlDataReader reader = get_team_key.ExecuteReader();
                    reader.Read();
                    HttpContext.Current.Session["MemberName"] = reader.GetString(0);
                    reader.Close();
                    connection.Close();
                }
            }
            lblMemberName.Text = Session["MemberName"].ToString();
            if (Session["UserID"] == null)
            {
                Session["UserID"] = HttpContext.Current.Session["username"];
            }

        }
    }
}
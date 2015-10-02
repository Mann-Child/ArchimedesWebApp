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
            string tl_id;
            string pm_id;
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

            lblMemberName.Text = Session["MemberName"].ToString();

            if (HttpContext.Current.Session["username"].ToString() != pm_id && HttpContext.Current.Session["username"].ToString() != tl_id && HttpContext.Current.Session["username"].ToString() != HttpContext.Current.Session["ceo_id"].ToString())
            {
                cbTeamLeaderVisible.Visible = false;
                cbTeamLeaderVisible.Checked = false;
                cbGenerallyVisible.Visible = false;
                lblTeamLeaderVisible.Visible = false;
                lblGenerallyVisible.Visible = false;
                gvTlComments.Visible = false;
            }
            if (HttpContext.Current.Session["username"].ToString() != HttpContext.Current.Session["ceo_id"].ToString())
            {
                cbCeoVisible.Visible = false;
                cbCeoVisible.Checked = false;
                lblCeoVisible.Visible = false;
                gv_ceo_private.Visible = false;
            }
        }

        protected void btnCreateComment_Click(object sender, EventArgs e)
        {
            dsMemberComments.Insert();
            txtMemberComment.Text = String.Empty;
            gvTlComments.DataBind();
            gv_ceo_private.DataBind();

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

        protected void cbTeamLeaderVisible_CheckedChanged(Object sender, EventArgs e)
        {
            hfTeamLeaderVisible.Value = cbTeamLeaderVisible.Checked ? "Y" : "N";
        }

        protected void cbGenerallyVisible_CheckedChanged(Object sender, EventArgs e)
        {
            hfGenerallyVisible.Value = cbGenerallyVisible.Checked ? "Y" : "N";
        }

        protected void cbCeoVisible_CheckedChanged(Object sender, EventArgs e)
        {
            hfCeoVisible.Value = cbCeoVisible.Checked ? "Y" : "N";
        }
    }
}
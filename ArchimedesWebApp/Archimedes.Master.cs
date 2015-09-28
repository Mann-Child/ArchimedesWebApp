using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ArchimedesWebApp
{
    public partial class Archimedes : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["TeamKey"] == null)
            {
                btnTeam.Visible = false;
            }
            else
            {
                btnTeam.Text = Session["TeamName"].ToString();
            }

            if (Session["UserID"] == null)
            {
                btnMember.Visible = false;
            }
            else
            {
                btnMember.Text = Session["MemberName"].ToString();
            }
        }

        protected void btnHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/CEODashboard.aspx");
        }

        protected void btnTeam_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/TeamDashboard.aspx");
        }

        protected void btnMember_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/MemberDashboard.aspx");
        }
    }
}
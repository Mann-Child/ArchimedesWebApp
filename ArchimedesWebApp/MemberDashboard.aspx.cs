using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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
        }
    }
}
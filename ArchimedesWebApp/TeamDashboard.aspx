<%@ Page Title="" Language="C#" MasterPageFile="~/Archimedes.Master" AutoEventWireup="true" CodeBehind="TeamDashboard.aspx.cs" Inherits="ArchimedesWebApp.TeamDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2 id="page_title">Team Dashboard &#8226; <span class="team_name"><asp:Label ID="lblTeamName" runat="server" /></span></h2>
    <div class="page_content">
        <div id="leave_comment">
           <h3>Assign Users to Teams</h3>
           <asp:DropDownList ID="ddlUsers" runat="server"
               DataSourceID="dsUsers"
               DataTextField="user_fullname"
               DataValueField="user_id" />
           <asp:Button ID="Button1" runat="server"
               Text="Assign"
               OnClick="btnAssignToTeam_Click" />
           
           <h3>Leave Comment</h3>
           <asp:Label ID="lblTeamComment" runat="server"
               Text="Write Comment:"
               AssociatedControlID="txtTeamComment" />
           <asp:TextBox ID="txtTeamComment" runat="server"
               Rows="5" />
           
           <div class="box">                                         
              <asp:CheckBox ID="cbTeamLeaderVisible" runat="server"
                  Checked="true"
                  OnCheckedChanged="cbTeamLeaderVisible_CheckedChanged"
                  CssClass="checkbox"/>
              <asp:Label ID="lblTeamLeaderVisible" runat="server"
                  AssociatedControlID="cbTeamLeaderVisible"
                  Text="Visible to Team Leader and PM" />
              <asp:HiddenField ID="hfTeamLeaderVisible" runat="server"
                  Value="Y" />
           </div>
           <div class="box">                                 
           <asp:CheckBox ID="cbGenerallyVisible" runat="server"
               Checked="true"
               OnCheckedChanged="cbGenerallyVisible_CheckedChanged"
               CssClass="checkbox"/>
           <asp:Label ID="lblGenerallyVisible" runat="server"
               AssociatedControlID="cbGenerallyVisible"
               Text="Visible to Everyone" />
           <asp:HiddenField ID="hfGenerallyVisible" runat="server"
               Value="Y" />
           </div>

           <asp:Button ID="btnCreateComment" runat="server"
               OnClick="btnCreateComment_Click"
               Text="Leave Comment" />

           <asp:SqlDataSource ID="dsTeamComments" runat="server"
               ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'
               SelectCommand="
               SELECT [visible_to_leaders],
     	               [visible_to_everyone],
     	               [comment],
     	               [comment_timestamp],
     	               [comment_user_id],
     	               [USER].user_last_name + ', ' + [USER].user_first_name AS user_name
                 FROM SEI_Archimedes.dbo.Team_Comments
	                  JOIN SEI_TimeMachine2.dbo.[USER] ON (Team_Comments.comment_user_id = [USER].[user_id])
                ORDER BY comment_timestamp;"
               InsertCommand="
                   INSERT INTO SEI_Archimedes.dbo.Team_Comments (
                       team_key, visible_to_leaders, visible_to_everyone, comment, comment_timestamp, comment_user_id
                   ) VALUES (
                       @team_key, @visible_to_leaders, @visible_to_everyone, @comment, SYSDATETIME(), @comment_user_id
                   );" >
               <InsertParameters>
                   <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
                   <asp:ControlParameter Name="visible_to_leaders" ControlID="hfTeamLeaderVisible" PropertyName="Value" />
                   <asp:ControlParameter Name="visible_to_everyone" ControlID="hfGenerallyVisible" PropertyName="Value" />
                   <asp:ControlParameter Name="comment" ControlID="txtTeamComment" PropertyName="Text" />
                   <asp:SessionParameter Name="comment_user_id" SessionField="username" />
               </InsertParameters>
           </asp:SqlDataSource>
        </div>
        <div id="member_table">
        <asp:GridView ID="gvTeamMembers" runat="server"
            AutoGenerateColumns="false"
            DataSourceID="dsTeamMembers">
            <Columns>
                <asp:TemplateField HeaderText="Member ID">
                    <ItemTemplate>
                        <asp:Label ID="btnID" runat="server"
                            Text='<%# Eval("user_id") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Full Name">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnFullName" runat="server"
                            Text='<%# Eval("user_fullname") %>'
                            CommandArgument='<%# Eval("user_id") + ";" + Eval("user_fullname") %>'
                            OnCommand="btnFullName_Command" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Time Logged">
                    <ItemTemplate>
                        <asp:Label ID="lblTotalTime" runat="server"
                            Text='<%# Eval("user_total_time") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btnDeleteUser" runat="server"
                            Text="Delete User"
                            CommandArgument='<%# Eval("user_id") %>'
                            OnCommand="btnUserDelete_Command" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
         <asp:HiddenField ID="hfDeleteUserKey" runat="server" />
       <div id="comment_section">
        <asp:GridView ID="gvComments" runat="server"
            AllowPaging="true"
            PageSize="5"
            PagerSettings-Position="Bottom"
            AutoGenerateColumns="false"
            DataSourceID="dsTeamComments">
            <Columns>
                <asp:TemplateField HeaderText="Comments">
                    <ItemTemplate>
                        <asp:Label ID="lblCommentHeader" runat="server"
                            Text='<%# Eval("user_name") + " - " + Eval("comment_timestamp") %>' />
                        <br />
                        <asp:Label ID="lblCommentBody" runat="server"
                            Text='<%# Eval("comment") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        </div>
       <div>
        <asp:SqlDataSource ID="dsTeamMembers" runat="server"
            ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'
            SelectCommand="
                    SELECT [USER].[user_id], [USER].user_last_name + ', ' + [USER].user_first_name AS user_fullname, SUM(log_entry.entry_total_time) AS user_total_time
                        FROM SEI_Archimedes.dbo.Teams
                             JOIN SEI_TimeMachine2.dbo.[USER] ON (Teams.pm_user_id = [USER].user_id)
	                         LEFT OUTER JOIN SEI_TimeMachine2.dbo.[ENTRY] log_entry ON ([USER].[user_id] = log_entry.entry_user_id)
                        WHERE Teams.team_key = @team_key
                        GROUP BY [USER].[user_id], [USER].user_last_name, [USER].user_first_name
                    UNION
                        SELECT [USER].[user_id], [USER].user_last_name + ', ' + [USER].user_first_name AS user_fullname, SUM(log_entry.entry_total_time) AS user_total_time
                        FROM SEI_Archimedes.dbo.Teams
                             JOIN SEI_TimeMachine2.dbo.[USER] ON (Teams.team_leader_user_id = [USER].user_id)
	                         LEFT OUTER JOIN SEI_TimeMachine2.dbo.[ENTRY] log_entry ON ([USER].[user_id] = log_entry.entry_user_id)
                        WHERE Teams.team_key = @team_key
                        GROUP BY [USER].[user_id], [USER].user_last_name, [USER].user_first_name
                    UNION
                        SELECT team_user.[user_id], team_user.user_last_name + ', ' + team_user.user_first_name AS user_fullname, SUM(log_entry.entry_total_time) AS user_total_time
                        FROM SEI_Archimedes.dbo.Team_Linking
	                         LEFT OUTER JOIN SEI_TimeMachine2.dbo.[USER] team_user ON (team_user.[user_id] = Team_Linking.[user_id])
	                         LEFT OUTER JOIN SEI_TimeMachine2.dbo.[ENTRY] log_entry ON (team_user.[user_id] = log_entry.entry_user_id)
                        WHERE Team_Linking.team_key = @team_key
                        GROUP BY team_user.[user_id], team_user.user_last_name, team_user.user_first_name"
                DeleteCommand="DELETE FROM SEI_Archimedes.dbo.Team_Linking WHERE Team_Linking.user_id = @team_user">
            <SelectParameters>
                <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
            </SelectParameters>
            <DeleteParameters>
                <asp:ControlParameter Name="team_user" ControlID="hfDeleteUserKey" PropertyName="Value" />
            </DeleteParameters>
        </asp:SqlDataSource>
     </div>
      </div>   
      </div>
     <div>
        <asp:SqlDataSource ID="dsUsers" runat="server"
            ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'
            SelectCommand="
                SELECT user_last_name + ', ' + user_first_name AS user_fullname, [user_id]
                FROM SEI_TimeMachine2.dbo.[USER]
                WHERE user_is_enabled = 1
                  AND [user_id] NOT IN (
                        SELECT DISTINCT [user_id]
                          FROM SEI_Archimedes.dbo.Team_Linking
                        WHERE Team_Linking.team_key = @team_key)
                  AND [user_id] NOT IN (
                        SELECT DISTINCT team_leader_user_id
                          FROM SEI_Archimedes.dbo.Teams
                        WHERE Teams.team_key = @team_key)
                  AND [user_id] NOT IN (
                        SELECT DISTINCT pm_user_id
                          FROM SEI_Archimedes.dbo.Teams
                        WHERE Teams.team_key = @team_key)
                  AND [user_id] IN (
                        SELECT DISTINCT MEMBER.member_user_id
                        FROM SEI_TimeMachine2.dbo.MEMBER
                        WHERE MEMBER.member_course_id IN (
                            SELECT Teams.course_id
                            FROM SEI_Archimedes.dbo.Teams
                            WHERE Teams.team_key = @team_key))
                ORDER BY user_fullname;"
            InsertCommand="
                INSERT INTO SEI_Archimedes.dbo.Team_Linking (
	                team_key, [user_id]
                ) VALUES (
	                @team_key, @user_id
                );"
            DeleteCommand="">
            <SelectParameters>
                <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
            </SelectParameters>
            <InsertParameters>
                <asp:ControlParameter Name="user_id" ControlID="ddlUsers" PropertyName="SelectedValue" />
                <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
            </InsertParameters>
        </asp:SqlDataSource>
       </div>
</asp:Content>



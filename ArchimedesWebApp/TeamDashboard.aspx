<%@ Page Title="" Language="C#" MasterPageFile="~/Archimedes.Master" AutoEventWireup="true" CodeBehind="TeamDashboard.aspx.cs" Inherits="ArchimedesWebApp.TeamDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2 id="page_title">Team Dashboard &#8226; <span class="team_name"><asp:Label ID="lblTeamName" runat="server" /></span></h2>
    <div id="page_data">
        <div id="aux_panel">
            <div id="CEOseeing" runat="server">
           <h3>Assign Users to Teams</h3>
           <asp:DropDownList ID="ddlUsers" runat="server"
               DataSourceID="dsUsers"
               DataTextField="user_fullname"
               DataValueField="user_id" />
           <asp:Button ID="AssignMember" runat="server"
               Text="Assign" CssClass="submit_button"
               OnClick="btnAssignToTeam_Click" />
           </div>
           <h3>Leave Comment</h3>
           <asp:Label ID="lblTeamComment" runat="server"
               Text="Write Comment:"
               AssociatedControlID="txtTeamComment" />
           <asp:TextBox ID="txtTeamComment" runat="server"
               TextMode="MultiLine" Rows="5" />

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
           
           <div class="box">                                         
              <asp:CheckBox ID="cbTeamLeaderVisible" runat="server"
                  Checked="false"
                  OnCheckedChanged="cbTeamLeaderVisible_CheckedChanged"
                  CssClass="checkbox"/>
              <asp:Label ID="lblTeamLeaderVisible" runat="server"
                  AssociatedControlID="cbTeamLeaderVisible"
                  Text="Visible in Team Leader and PM box" />
              <asp:HiddenField ID="hfTeamLeaderVisible" runat="server"
                  Value="N" />
           </div>

            <div class="box">                                         
              <asp:CheckBox ID="cbCeoVisible" runat="server"
                  Checked="false"
                  OnCheckedChanged="cbCeoVisible_CheckedChanged"
                  CssClass="checkbox"/>
              <asp:Label ID="lblCeoVisible" runat="server"
                  AssociatedControlID="cbCeoVisible"
                  Text="Make Private CEO Comment" />
              <asp:HiddenField ID="hfCeoVisible" runat="server"
                  Value="N" />
           </div>

           <asp:Button ID="btnCreateComment" runat="server"
               OnClick="btnCreateComment_Click" CssClass="submit_button"
               Text="Leave Comment" />

           <asp:SqlDataSource ID="dsTeamComments" runat="server"
               ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'
               SelectCommand="
               SELECT  [comment],
     	               [comment_timestamp],
     	               [comment_user_id],
     	               [USER].user_last_name + ', ' + [USER].user_first_name AS user_name
                 FROM SEI_Archimedes.dbo.Team_Comments
	                  JOIN SEI_TimeMachine2.dbo.[USER] ON (Team_Comments.comment_user_id = [USER].[user_id])
                WHERE SEI_Archimedes.dbo.Team_Comments.team_key = @team_key
                  AND SEI_Archimedes.dbo.Team_Comments.visible_to_everyone = 'Y'
                ORDER BY comment_timestamp DESC;"
               InsertCommand="
                   INSERT INTO SEI_Archimedes.dbo.Team_Comments (
                       team_key, visible_to_leaders, visible_to_everyone, comment, comment_timestamp, comment_user_id, ceo_private
                   ) VALUES (
                       @team_key, @visible_to_leaders, @visible_to_everyone, @comment, SYSDATETIME(), @comment_user_id, @ceo_private
                   );" >
               <SelectParameters>
                   <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
               </SelectParameters>
               <InsertParameters>
                   <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
                   <asp:ControlParameter Name="visible_to_leaders" ControlID="hfTeamLeaderVisible" PropertyName="Value" />
                   <asp:ControlParameter Name="visible_to_everyone" ControlID="hfGenerallyVisible" PropertyName="Value" />
                   <asp:ControlParameter Name="ceo_private" ControlID="hfCeoVisible" PropertyName="Value" />
                   <asp:ControlParameter Name="comment" ControlID="txtTeamComment" PropertyName="Text" />
                   <asp:SessionParameter Name="comment_user_id" SessionField="username" />
               </InsertParameters>
           </asp:SqlDataSource>

            <!-- Data Source for PL/TL Grid View -->

            <asp:SqlDataSource ID="SqlDataSource2" runat="server"
               ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'
               SelectCommand="
               SELECT  [comment],
     	               [comment_timestamp],
     	               [comment_user_id],
     	               [USER].user_last_name + ', ' + [USER].user_first_name AS user_name
                 FROM SEI_Archimedes.dbo.Team_Comments
	                  JOIN SEI_TimeMachine2.dbo.[USER] ON (Team_Comments.comment_user_id = [USER].[user_id])
                WHERE SEI_Archimedes.dbo.Team_Comments.team_key = @team_key
                  AND SEI_Archimedes.dbo.Team_Comments.[visible_to_leaders] = 'Y'
                ORDER BY comment_timestamp DESC;"
               InsertCommand="
                   INSERT INTO SEI_Archimedes.dbo.Team_Comments (
                       team_key, visible_to_leaders, visible_to_everyone, comment, comment_timestamp, comment_user_id, ceo_private
                   ) VALUES (
                       @team_key, @visible_to_leaders, @visible_to_everyone, @comment, SYSDATETIME(), @comment_user_id, @ceo_private
                   );" >
               <SelectParameters>
                   <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
               </SelectParameters>
               <InsertParameters>
                   <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
                   <asp:ControlParameter Name="visible_to_leaders" ControlID="hfTeamLeaderVisible" PropertyName="Value" />
                   <asp:ControlParameter Name="visible_to_everyone" ControlID="hfGenerallyVisible" PropertyName="Value" />
                   <asp:ControlParameter Name="ceo_private" ControlID="hfCeoVisible" PropertyName="Value" />
                   <asp:ControlParameter Name="comment" ControlID="txtTeamComment" PropertyName="Text" />
                   <asp:SessionParameter Name="comment_user_id" SessionField="username" />
               </InsertParameters>
           </asp:SqlDataSource>


            <!-- Data Source for CEO Grid View -->
            <asp:SqlDataSource ID="SqlDataSource3" runat="server"
               ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'
               SelectCommand="
               SELECT  [comment],
     	               [comment_timestamp],
     	               [comment_user_id],
     	               [USER].user_last_name + ', ' + [USER].user_first_name AS user_name
                 FROM SEI_Archimedes.dbo.Team_Comments
	                  JOIN SEI_TimeMachine2.dbo.[USER] ON (Team_Comments.comment_user_id = [USER].[user_id])
                WHERE SEI_Archimedes.dbo.Team_Comments.team_key = @team_key
                  AND SEI_Archimedes.dbo.Team_Comments.[ceo_private]  = 'Y'
                ORDER BY comment_timestamp DESC;"
               InsertCommand="
                   INSERT INTO SEI_Archimedes.dbo.Team_Comments (
                       team_key, visible_to_leaders, visible_to_everyone, comment, comment_timestamp, comment_user_id, ceo_private
                   ) VALUES (
                       @team_key, @visible_to_leaders, @visible_to_everyone, @comment, SYSDATETIME(), @comment_user_id, @ceo_private
                   );" >
               <SelectParameters>
                   <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
               </SelectParameters>
               <InsertParameters>
                   <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
                   <asp:ControlParameter Name="visible_to_leaders" ControlID="hfTeamLeaderVisible" PropertyName="Value" />
                   <asp:ControlParameter Name="visible_to_everyone" ControlID="hfGenerallyVisible" PropertyName="Value" />
                   <asp:ControlParameter Name="ceo_private" ControlID="hfCeoVisible" PropertyName="Value" />
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
                <asp:TemplateField HeaderText="Total Hours Logged">
                    <ItemTemplate>
                        <asp:Label ID="lblTotalTime" runat="server"
                            Text='<%# Eval("user_total_time") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btnDeleteUser" runat="server"
                            Text="Remove"
                            CommandArgument='<%# Eval("user_id") %>'
                            OnCommand="btnUserDelete_Command" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btnMakeTeamLeader" runat="server"
                            Text="Make Team Leader"
                            CommandArgument='<%# Eval("user_id") %>'
                            OnCommand="btnMakeTeamLeader_Command" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:HiddenField ID="hfDeleteUserID" runat="server" />
        <asp:HiddenField ID="hfMakeTLUserID" runat="server" />

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
                        <asp:Label ID="lblCommentHeader" runat="server" CssClass="comment_header"
                            Text='<%# Eval("user_name") + " - " + Eval("comment_timestamp") %>' />
                        <br />
                        <asp:Label ID="lblCommentBody" runat="server" CssClass="comment_body"
                            Text='<%# Eval("comment") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
       <div id="private_comments">
       <asp:GridView ID="gvTlComments" runat="server"
            AllowPaging="true"
            PageSize="5"
            PagerSettings-Position="Bottom"
            AutoGenerateColumns="false"
            DataSourceID="SqlDataSource2">
            <Columns>
                <asp:TemplateField HeaderText="PM/TL Comments">
                    <ItemTemplate>
                        <asp:Label ID="lblCommentHeader" runat="server" CssClass="comment_header"
                            Text='<%# Eval("user_name") + " - " + Eval("comment_timestamp") %>' />
                        <br />
                        <asp:Label ID="lblCommentBody" runat="server" CssClass="comment_body"
                            Text='<%# Eval("comment") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

           <asp:GridView ID="gv_ceo_private" runat="server"
            AllowPaging="true"
            PageSize="5"
            PagerSettings-Position="Bottom"
            AutoGenerateColumns="false"
            DataSourceID="SqlDataSource3">
            <Columns>
                <asp:TemplateField HeaderText="CEO Private Comments">
                    <ItemTemplate>
                        <asp:Label ID="lblCommentHeader" runat="server" CssClass="comment_header"
                            Text='<%# Eval("user_name") + " - " + Eval("comment_timestamp") %>' />
                        <br />
                        <asp:Label ID="lblCommentBody" runat="server" CssClass="comment_body"
                            Text='<%# Eval("comment") %>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

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
                        SELECT [USER].[user_id], [USER].user_last_name + ', ' + [USER].user_first_name AS user_fullname, CAST(SUM([ENTRY].entry_total_time / 60.0) AS numeric(36,2)) AS user_total_time
                        FROM SEI_TimeMachine2.dbo.[USER]
	                         JOIN SEI_Archimedes.dbo.Team_Linking ON ([USER].[user_id] = Team_Linking.[user_id])
	                         JOIN SEI_Archimedes.dbo.Teams ON ([Team_Linking].team_key = Teams.team_key)
	                         LEFT OUTER JOIN SEI_TimeMachine2.dbo.[ENTRY] ON ([ENTRY].entry_project_id = Teams.project_id
										                                      AND [ENTRY].entry_user_id = [USER].[user_id])
                        WHERE Teams.team_key = @team_key
                        GROUP BY [USER].[user_id], [USER].user_last_name, [USER].user_first_name"
            DeleteCommand="DELETE FROM SEI_Archimedes.dbo.Team_Linking WHERE Team_Linking.user_id = @team_user"
            UpdateCommand="UPDATE SEI_Archimedes.dbo.Teams
                           SET team_leader_user_id = @team_leader_user_id
                           WHERE team_key = @team_key">
            <SelectParameters>
                <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
            </SelectParameters>
            <DeleteParameters>
                <asp:ControlParameter Name="team_user" ControlID="hfDeleteUserID" PropertyName="Value" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:ControlParameter Name="team_leader_user_id" ControlID="hfMakeTLUserID" PropertyName="Value" />
                <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
            </UpdateParameters>
        </asp:SqlDataSource>
     </div>
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

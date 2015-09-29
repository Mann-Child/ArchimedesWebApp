<%@ Page Title="" Language="C#" MasterPageFile="~/Archimedes.Master" AutoEventWireup="true" CodeBehind="CEODashboard.aspx.cs" Inherits="ArchimedesWebApp.CEODashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2 id="page_title">CEO Dashboard</h2>
    <div id="page_content">
       <div id="add_team">
          <div>
             <h3>Add a Team</h3>
              <asp:CheckBox ID="cbViewOldTeams" runat="server"
                  OnCheckedChanged="cbViewOldTeams_CheckedChanged"
                 CssClass="checkbox"/>
              <asp:Label ID="lblViewOldTeams" runat="server"
                  AssociatedControlID="cbViewOldTeams"
                  Text="Show Old Teams"/>
              <asp:HiddenField ID="hfViewOldTeams" runat="server" Value="N"/>
          </div>
          <div>
              <asp:Label ID="lblTeamName" runat="server"
                  AssociatedControlID="txtTeamName"
                  Text="Team Name:" />
              <asp:TextBox ID="txtTeamName" runat="server" />
              <br />

              <asp:Label ID="lblProject" runat="server"
                  AssociatedControlID="ddlProject"
                  Text="Team Project:" />
              <asp:DropDownList ID="ddlProject" runat="server"
                  DataSourceID="dsProject"
                  DataTextField="project_name"
                  DataValueField="project_id" />
              <asp:SqlDataSource ID="dsProject" runat="server"
                  SelectCommand="
                      SELECT PROJECT.project_name, PROJECT.project_id
                      FROM SEI_TimeMachine2.dbo.PROJECT
                      WHERE PROJECT.project_is_enabled = 1;"
                  ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'>
              </asp:SqlDataSource>
              <br />

              <asp:Label ID="lblCourse" runat="server"
                  AssociatedControlID="ddlCourse"
                  Text="Team Course:" />
              <asp:DropDownList ID="ddlCourse" runat="server"
                  DataSourceID="dsCourse"
                  DataTextField="course_name"
                  DataValueField="course_id" />
              <asp:SqlDataSource ID="dsCourse" runat="server"
                  SelectCommand="
                      SELECT COURSE.course_name, COURSE.course_id
                      FROM SEI_TimeMachine2.dbo.COURSE
                      WHERE COURSE.course_is_enabled = 1;"
                  ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'>
              </asp:SqlDataSource>
              <br />

              <asp:Label ID="lblTeamLeader" runat="server"
                  AssociatedControlID="ddlTeamLeader"
                  Text="Team Leader:" />
              <asp:DropDownList ID="ddlTeamLeader" runat="server"
                  DataSourceID="dsUsers"
                  DataTextField="user_fullname"
                  DataValueField="user_id" />
              <br />
              <asp:Label ID="lblProjectManager" runat="server"
                  AssociatedControlID="ddlProjectManager"
                  Text="Project Manager:" />
              <asp:DropDownList ID="ddlProjectManager" runat="server"
                  DataSourceID="dsUsers"
                  DataTextField="user_fullname"
                  DataValueField="user_id" />
              <asp:SqlDataSource ID="dsUsers" runat="server"
                  ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'
                  SelectCommand="
                      SELECT user_last_name + ', ' + user_first_name AS user_fullname, [user_id]
                      FROM SEI_TimeMachine2.dbo.[USER]
                      WHERE user_is_enabled = 1
                        AND [user_id] NOT IN (
                              SELECT DISTINCT team_leader_user_id
                                FROM SEI_Archimedes.dbo.Teams)
                        AND [user_id] NOT IN (
                              SELECT DISTINCT pm_user_id
                                FROM SEI_Archimedes.dbo.Teams)
                      ORDER BY user_fullname;"
                  DeleteCommand="DELETE FROM SEI_Archimedes.dbo.Team_Linking WHERE team_key = @team_key">
                  <DeleteParameters>
                      <asp:ControlParameter Name="team_key" ControlID="hfDeleteTeamKey" PropertyName="Value" />
                  </DeleteParameters>
              </asp:SqlDataSource>
              <br />

              <asp:Button ID="btnCreateTeam" runat="server"
                  Text="Add Team"
                  OnClick="btnCreateTeam_Click" />
          </div>
       </div>
       <div id="member_table">
           <asp:GridView ID="gvTeams" runat="server"
               AutoGenerateColumns="false"
               DataSourceID="dsTeams">
               <Columns>
                   <asp:TemplateField HeaderText="Team Name">
                       <ItemTemplate>
                           <asp:LinkButton ID="btnTeamName" runat="server"
                               Text='<%# Eval("team_name") %>'
                               CommandArgument='<%# Eval("team_key") + ";" + Eval("team_name") %>'
                               OnCommand="btnTeamName_Command" />
                       </ItemTemplate>
                   </asp:TemplateField>
                   <asp:TemplateField HeaderText="Course">
                       <ItemTemplate>
                           <asp:Label ID="lblCourseName" runat="server"
                               Text='<%# Eval("course_name") %>' />
                       </ItemTemplate>
                   </asp:TemplateField>
                   <asp:TemplateField HeaderText="Project">
                       <ItemTemplate>
                           <asp:Label ID="lblProjectName" runat="server"
                               Text='<%# Eval("project_name") %>' />
                       </ItemTemplate>
                   </asp:TemplateField>
                   <asp:TemplateField HeaderText="Team Leader">
                       <ItemTemplate>
                           <asp:Label ID="lblTeamLeader" runat="server"
                               Text='<%# Eval("team_leader_user_id") %>' />
                       </ItemTemplate>
                   </asp:TemplateField>
                   <asp:TemplateField HeaderText="Project Manager">
                       <ItemTemplate>
                           <asp:Label ID="lblProjectManager" runat="server"
                               Text='<%# Eval("pm_user_id") %>' />
                       </ItemTemplate>
                   </asp:TemplateField>
                   <asp:TemplateField HeaderText="Total Time Logged">
                       <ItemTemplate>
                           <asp:Label ID="lblTotalTime" runat="server"
                               Text='<%# Eval("time_logged") %>' />
                       </ItemTemplate>
                   </asp:TemplateField>
                   <asp:TemplateField>
                       <ItemTemplate>
                           <asp:LinkButton ID="btnDeleteTeam" runat="server"
                               Text="Delete Team"
                               CommandArgument='<%# Eval("team_key") %>'
                               OnCommand="btnTeamDelete_Command" />
                       </ItemTemplate>
                   </asp:TemplateField>
               </Columns>
           </asp:GridView>
           <asp:HiddenField ID="hfDeleteTeamKey" runat="server" />

           <asp:SqlDataSource ID="dsTeams" runat="server"
               ConnectionString="Data Source=csdb;Initial Catalog=SEI_Archimedes;Integrated Security=True"
               ProviderName="System.Data.SqlClient"
               SelectCommand="
                   SELECT Teams.team_key,
                          Teams.team_name,
                          Teams.course_id,
                          COURSE.course_name,
                          Teams.project_id,
                          PROJECT.project_name,
                          Teams.team_leader_user_id,
                          Teams.pm_user_id,
                          ISNULL(SUM([ENTRY].entry_total_time), 0) AS time_logged
                   FROM SEI_Archimedes.dbo.Teams
                       JOIN SEI_TimeMachine2.dbo.COURSE ON (COURSE.course_id = Teams.course_id)
                       JOIN SEI_TimeMachine2.dbo.PROJECT ON (PROJECT.project_id = Teams.project_id)
	                   LEFT OUTER JOIN SEI_Archimedes.dbo.Team_Linking ON (Teams.team_key = Team_Linking.team_key)
	                   LEFT OUTER JOIN SEI_TimeMachine2.dbo.[USER] team_user ON (Team_Linking.[user_id] = team_user.[user_id])
	                   LEFT OUTER JOIN SEI_TimeMachine2.dbo.[ENTRY] ON ([ENTRY].entry_user_id = team_user.[user_id])
                   WHERE Teams.active = 'Y' OR @show_old_teams = 'Y'
                   GROUP BY Teams.team_key,
                            Teams.team_name,
                            Teams.course_id,
                            COURSE.course_name,
                            Teams.project_id,
                            PROJECT.project_name,
                            Teams.team_leader_user_id,
                            Teams.pm_user_id;"
               InsertCommand="
                   INSERT INTO SEI_Archimedes.dbo.Teams(
	                   team_name, active, course_id, project_id, team_leader_user_id, pm_user_id
                   ) VALUES (
	                   @team_name, 'Y', @course_id, @project_id, @team_leader_user_id, @pm_user_id
                   );
                   INSERT INTO SEI_Archimedes.dbo.Team_Linking
                       (user_id, team_key)
                    VALUES
                       (@team_leader_user_id, @team_key)"
               DeleteCommand="DELETE FROM SEI_Archimedes.dbo.Teams WHERE Teams.team_key = @team_key">
               <SelectParameters>
                   <asp:ControlParameter Name="show_old_teams" ControlID="hfViewOldTeams" PropertyName="Value" />
               </SelectParameters>
               <InsertParameters>
                   <asp:ControlParameter Name="team_name" ControlID="txtTeamName" PropertyName="Text" />
                   <asp:ControlParameter Name="project_id" ControlID="ddlProject" PropertyName="SelectedValue" />
                   <asp:ControlParameter Name="course_id" ControlID="ddlCourse" PropertyName="SelectedValue" />
                   <asp:ControlParameter Name="team_leader_user_id" ControlID="ddlTeamLeader" PropertyName="SelectedValue" />
                   <asp:ControlParameter Name="pm_user_id" ControlID="ddlProjectManager" PropertyName="SelectedValue" />
               </InsertParameters>
               <DeleteParameters>
                   <asp:ControlParameter Name="team_key" ControlID="hfDeleteTeamKey" PropertyName="Value" />
               </DeleteParameters>
           </asp:SqlDataSource>
       </div>
    </div>
</asp:Content>

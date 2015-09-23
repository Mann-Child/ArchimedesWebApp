<%@ Page Title="" Language="C#" MasterPageFile="~/Archimedes.Master" AutoEventWireup="true" CodeBehind="TeamDashboard.aspx.cs" Inherits="ArchimedesWebApp.TeamDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h1 id="page_title">Team Dashboard</h1>
    <div class="team_block">
        <h2 class="team_name"><asp:Label ID="lblTeamName" runat="server" /></h2>
        <div>
        <h3>Assign Users to Teams</h3>
        <asp:DropDownList ID="ddlUsers" runat="server"
            DataSourceID="dsUsers"
            DataTextField="user_fullname"
            DataValueField="user_id" />
        <asp:Button ID="Button1" runat="server"
            Text="Assign"
            OnClick="btnAssignToTeam_Click" />

        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'
            SelectCommand="
                SELECT user_last_name + ', ' + user_first_name AS user_fullname, [user_id]
                FROM SEI_TimeMachine2.dbo.[USER]
                WHERE user_is_enabled = 1
                  AND [user_id] NOT IN (
                        SELECT DISTINCT [user_id]
                          FROM SEI_Archimedes.dbo.Team_Linking)
                  AND [user_id] NOT IN (
                        SELECT DISTINCT team_leader_user_id
                          FROM SEI_Archimedes.dbo.Teams)
                  AND [user_id] NOT IN (
                        SELECT DISTINCT pm_user_id
                          FROM SEI_Archimedes.dbo.Teams)
                ORDER BY user_fullname;"
            InsertCommand="
                INSERT INTO SEI_Archimedes.dbo.Team_Linking (
	                team_key, [user_id]
                ) VALUES (
	                @team_key, @user_id
                );"
            DeleteCommand="">
            <InsertParameters>
                <asp:ControlParameter Name="user_id" ControlID="ddlUsers" PropertyName="SelectedValue" />
                <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
            </InsertParameters>
        </asp:SqlDataSource>
    </div>
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
        <asp:SqlDataSource ID="dsUsers" runat="server"
            ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'
            SelectCommand="
                SELECT user_last_name + ', ' + user_first_name AS user_fullname, [user_id]
                FROM SEI_TimeMachine2.dbo.[USER]
                WHERE user_is_enabled = 1
                  AND [user_id] NOT IN (
                        SELECT DISTINCT [user_id]
                          FROM SEI_Archimedes.dbo.Team_Linking)
                  AND [user_id] NOT IN (
                        SELECT DISTINCT team_leader_user_id
                          FROM SEI_Archimedes.dbo.Teams)
                  AND [user_id] NOT IN (
                        SELECT DISTINCT pm_user_id
                          FROM SEI_Archimedes.dbo.Teams)
                ORDER BY user_fullname;"
            InsertCommand="
                INSERT INTO SEI_Archimedes.dbo.Team_Linking (
	                team_key, [user_id]
                ) VALUES (
	                @team_key, @user_id
                );"
            DeleteCommand="">
            <InsertParameters>
                <asp:ControlParameter Name="user_id" ControlID="ddlUsers" PropertyName="SelectedValue" />
                <asp:SessionParameter Name="team_key" SessionField="TeamKey" />
            </InsertParameters>
        </asp:SqlDataSource>
</asp:Content>

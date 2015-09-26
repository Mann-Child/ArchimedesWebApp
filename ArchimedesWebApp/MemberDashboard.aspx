<%@ Page Title="" Language="C#" MasterPageFile="~/Archimedes.Master" AutoEventWireup="true" CodeBehind="MemberDashboard.aspx.cs" Inherits="ArchimedesWebApp.MemberDashboard" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2 id="page_title">Member Dashboard &#8226; <span>
        <asp:Label ID="lblMemberName" runat="server" /></span></h2>

     <asp:Label ID="lblMemberComment" runat="server"
            Text="Write Comment:"
            AssociatedControlID="txtMemberComment" />

    <asp:TextBox ID="txtMemberComment" runat="server"
            Rows="5" />

    <asp:Button ID="CreateCommentButton" runat="server"
            OnClick="btnCreateComment_Click"
            Text="Leave Comment" />

    <asp:HiddenField ID="hfTeamLeaderVisible" runat="server"
            Value="Y" />

    <asp:HiddenField ID="hfGenerallyVisible" runat="server"
            Value="Y" />

    <asp:GridView ID="GVTimeLogs" runat="server" AutoGenerateColumns="False" DataSourceID="DSTimeLogs">
        <Columns>
            <asp:TemplateField HeaderText="Date/Time Created">
                <ItemTemplate>
                    <asp:Label ID ="lblEntryStartTime" 
                        runat="server" 
                        Text='<%#Eval("entry_begin_time") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Hours Logged">
                <ItemTemplate>
                    <asp:Label ID ="lblEntryTotalTime" 
                        runat="server" 
                        Text='<%#Eval("hours_logged") %>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Category">
                <ItemTemplate>
                    <asp:Label ID ="lblCategoryName" 
                        runat="server" 
                        Text='<%#Eval("category_name") %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

     <asp:GridView ID="gvComments" runat="server"
            AllowPaging="true"
            PageSize="5"
            PagerSettings-Position="Bottom"
            AutoGenerateColumns="false"
            DataSourceID="dsMemberComments">
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

<asp:SqlDataSource ID="DSTimeLogs" 
                   runat="server" 
    ConnectionString="<%$ ConnectionStrings:SEI_TimeMachine2ConnectionString %>" 
    SelectCommand="SELECT entry.entry_begin_time, entry.entry_total_time / 60.0 AS hours_logged, category.category_name 
                    FROM [SEI_TimeMachine2].[dbo].[ENTRY] 
                    JOIN [SEI_TimeMachine2].[dbo].[CATEGORY] ON (entry.entry_category_id = category.category_id) 
                    WHERE entry.[entry_user_id] = @UserID;">
    <SelectParameters>
        <asp:SessionParameter Name="UserID" SessionField="UserID"/>
    </SelectParameters>
</asp:SqlDataSource>

    <asp:SqlDataSource ID="dsMemberComments"
                    runat="server"
   ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>' 
   SelectCommand=
                "SELECT [visible_to_leaders],
     	            [visible_to_everyone],
     	            [comment],
     	            [comment_timestamp],
     	            [comment_user_id],
     	            [USER].user_last_name + ', ' + [USER].user_first_name AS user_name
              FROM SEI_Archimedes.dbo.Member_Comments
	               JOIN SEI_TimeMachine2.dbo.[USER] ON (Member_Comments.comment_user_id = [USER].[user_id])
                ORDER BY comment_timestamp DESC"
    InsertCommand="
                INSERT INTO SEI_Archimedes.dbo.Member_Comments (
                    user_id, visible_to_leaders, visible_to_everyone, comment, comment_timestamp, comment_user_id
                ) VALUES (
                    @user_id, @visible_to_leaders, @visible_to_everyone, @comment, SYSDATETIME(), @comment_user_id
                );" >
    <InsertParameters>
         <asp:SessionParameter Name="user_id" SessionField="UserID" />
         <asp:ControlParameter Name="visible_to_leaders" ControlID="hfTeamLeaderVisible" PropertyName="Value" />
         <asp:ControlParameter Name="visible_to_everyone" ControlID="hfGenerallyVisible" PropertyName="Value" />
         <asp:ControlParameter Name="comment" ControlID="txtMemberComment" PropertyName="Text" />
         <asp:SessionParameter Name="comment_user_id" SessionField="username" />
    </InsertParameters>
</asp:SqlDataSource>
</asp:Content>

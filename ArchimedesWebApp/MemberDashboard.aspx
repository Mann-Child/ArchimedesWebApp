<%@ Page Title="" Language="C#" MasterPageFile="~/Archimedes.Master" AutoEventWireup="true" CodeBehind="MemberDashboard.aspx.cs" Inherits="ArchimedesWebApp.MemberDashboard" %>
<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2 id="page_title">Member Dashboard &#8226; <span>
        <asp:Label ID="lblMemberName" runat="server" /></span></h2>
       <div id="page_data">
          <div id="member_table">
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
     <div id="comment_section">
     <asp:GridView ID="gvComments" runat="server"
            AllowPaging="true"
            PageSize="5"
            PagerSettings-Position="Bottom"
            AutoGenerateColumns="false"
            DataSourceID="dsMemberComments">
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
        </div>



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
        </div>    

           </div>
          <div id="aux_panel">
           <h3>Leave Comment</h3>
        <asp:Label ID="lblMemberComment" runat="server"
               Text="Write Comment:"
               AssociatedControlID="txtMemberComment" />


       <asp:TextBox ID="txtMemberComment" runat="server"
               TextMode="multiline" Rows="5" />
              <div class="box">                                 
           <asp:CheckBox ID="cbGenerallyVisible" runat="server"
               Checked="true"
               OnCheckedChanged="cbGenerallyVisible_CheckedChanged"
               CssClass="checkbox"/>
           <asp:Label ID="lblGenerallyVisible" runat="server"
               AssociatedControlID="cbGenerallyVisible"
               Text="Visible to Everyone" />
           <asp:HiddenField ID="HiddenField1" runat="server"
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



       <asp:HiddenField ID="hfGenerallyVisible" runat="server"
               Value="Y" />
       <asp:Button ID="leaveComment" runat="server"
               OnClick="btnCreateComment_Click" CssClass="submit_button"
               Text="Leave Comment" />
           </div>
        </div>
<asp:SqlDataSource ID="DSTimeLogs"
                   runat="server"
    ConnectionString="<%$ ConnectionStrings:SEI_TimeMachine2ConnectionString %>" 
    SelectCommand="SELECT entry.entry_begin_time, CAST((entry.entry_total_time / 60.0) AS numeric(36,2)) AS hours_logged, category.category_name 
                    FROM [SEI_TimeMachine2].[dbo].[ENTRY] 
                    JOIN [SEI_TimeMachine2].[dbo].[CATEGORY] ON (entry.entry_category_id = category.category_id) 
                    WHERE entry.[entry_user_id] = @UserID
                    ORDER BY entry.entry_begin_time DESC;">
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
                   WHERE Member_Comments.user_id = @user_id
        And visible_to_everyone = 'Y'
                ORDER BY comment_timestamp DESC"
    InsertCommand="
                INSERT INTO SEI_Archimedes.dbo.Member_Comments (
                    user_id, visible_to_leaders, visible_to_everyone, comment, comment_timestamp, comment_user_id, ceo_private
                ) VALUES (
                    @user_id, @visible_to_leaders, @visible_to_everyone, @comment, SYSDATETIME(), @comment_user_id, @ceo_private
                );" >
    <SelectParameters>
        <asp:SessionParameter Name="user_id" SessionField ="UserID" />
    </SelectParameters>
    <InsertParameters>
         <asp:SessionParameter Name="user_id" SessionField="UserID" />
         <asp:ControlParameter Name="visible_to_leaders" ControlID="hfTeamLeaderVisible" PropertyName="Value" />
         <asp:ControlParameter Name="visible_to_everyone" ControlID="hfGenerallyVisible" PropertyName="Value" />
         <asp:ControlParameter Name="comment" ControlID="txtMemberComment" PropertyName="Text" />
         <asp:SessionParameter Name="comment_user_id" SessionField="username" />
        <asp:ControlParameter Name="ceo_private" ControlID="hfCeoVisible" PropertyName="Value"/>
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
                 FROM SEI_Archimedes.dbo.Member_Comments
                 JOIN SEI_TimeMachine2.dbo.[USER] ON (Member_Comments.comment_user_id = [USER].[user_id])
                WHERE SEI_Archimedes.dbo.Member_Comments.user_id = @user_id
                  AND SEI_Archimedes.dbo.Member_Comments.[visible_to_leaders] = 'Y'
                ORDER BY comment_timestamp DESC;">
               <SelectParameters>
                   <asp:SessionParameter Name="user_id" SessionField ="UserID" />
               </SelectParameters>
           </asp:SqlDataSource>

            <!-- Data Source for CEO Grid View -->
            <asp:SqlDataSource ID="SqlDataSource3" runat="server"
               ConnectionString='<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>'
               SelectCommand="
               SELECT  [comment],
                    [comment_timestamp],
                    [comment_user_id],
                    [USER].user_last_name + ', ' + [USER].user_first_name AS user_name
                 FROM SEI_Archimedes.dbo.Member_Comments
                 JOIN SEI_TimeMachine2.dbo.[USER] ON (Member_Comments.comment_user_id = [USER].[user_id])
                WHERE SEI_Archimedes.dbo.Member_Comments.user_id = @user_id
                  AND SEI_Archimedes.dbo.Member_Comments.[ceo_private] = 'Y'
                ORDER BY comment_timestamp DESC;">
               <SelectParameters>
                   <asp:SessionParameter Name="user_id" SessionField ="UserID" />
               </SelectParameters>
           </asp:SqlDataSource>
</asp:Content>
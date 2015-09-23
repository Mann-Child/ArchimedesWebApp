<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ArchimedesWebApp.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <asp:SqlDataSource ID="LoginSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:SEI_ArchimedesConnectionString %>" 
        SelectCommand="SELECT [user_id] FROM [SEI_TimeMachine2].[dbo].[USER] WHERE [USER_ID] = @user">
        <SelectParameters>
            <asp:SessionParameter Name="user" SessionField="username"/>
        </SelectParameters>
    </asp:SqlDataSource>
    <form runat="server">
        <asp:FormView ID="FormView1" runat="server" DataSourceID="LoginSource">
            <ItemTemplate>
                <asp:HiddenField ID="hfUserID" runat="server" Value='<%# Eval("userid") %>' />
            </ItemTemplate>
        </asp:FormView>
    </form>
</body>

</html>

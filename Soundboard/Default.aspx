<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Soundboard.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Soundboard</title>
    <script>
        function play(id) {
            var x = document.getElementById(id);
            if (x.paused) {
                x.currentTime = 0;
                x.play();
            }
            else {
                x.pause();
            }
            return false;
        }

        function audio_onplay(id) {
            var btn = document.getElementById("btn" + id);
            btn.style.backgroundColor = "#ff0000";
            document.getElementById("figure" + id).style.display = "inline";
        }

        function audio_onstop(id) {
            var btn = document.getElementById("btn" + id);
            btn.style.backgroundColor = "";
            document.getElementById("figure" + id).style.display = "";
        }
    </script>
    <style>
            body {
                    background-color: #000000;
            }
            button {
                    height: 100px;
                    width: 100px;
                    margin: 25px;
            }
            figure {
                    display: none;
            }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="lblOutput" runat="server" Text="Label"></asp:Label>
        </div>
    </form>
</body>
</html>

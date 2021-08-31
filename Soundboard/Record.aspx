<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Record.aspx.cs" Inherits="Soundboard.Record" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Add Recordings</title>
    <style>
        body {
                background-color: #000000;
                color: #ffffff;
        }

        .readyToBlink { display: none; }
        .blinking{
            display: inline;
            animation:blinkingText 2.0s infinite;
        }
        @keyframes blinkingText{
            0%{     color: #fb3f3f;    }
            25%{     color: #fb3f3f;    }
            50%{    color: transparent; }
            75%{     color: #fb3f3f;    }
            100%{   color: #fb3f3f;    }
        }

        .largeButton {
            height: 200px;
            width: 200px;
            margin: 100px;
        }

        .medButton {
            margin: 25px;
        }

        #lblSuccess { color: #00ff21; }
        #lblUploadError { color: #fb0c0c; }

    </style>
    <script>
        var recorder, gumStream, myPromise;
        var recordButton = document.getElementById("recordButton");

        function toggleRecording() {
            document.getElementById("spanRecording").classList.toggle("blinking");
            document.getElementById("spanRecording").classList.toggle("readyToBlink");

            if (recorder && recorder.state == "recording") {
                recorder.stop();
                gumStream.getAudioTracks()[0].stop();
            } else {
                navigator.mediaDevices.getUserMedia({
                    audio: true
                }).then(function (stream) {
                    gumStream = stream;
                    recorder = new MediaRecorder(stream);
                    recorder.ondataavailable = function (e) {
                        // Remove previous object if it exists
                        var audObj = document.getElementById("audioObject");
                        if (audObj) { audObj.remove(); }

                        var url = URL.createObjectURL(e.data);
                        var preview = document.createElement('audio');
                        preview.controls = true;
                        preview.id = "audioObject";
                        preview.src = url;
                        document.getElementById("audioObjectContainer").appendChild(preview);

                        let myPromise = blobToBase64(e.data);
                        myPromise.then(
                            function (value) {
                                document.getElementById("hddnBase64Data").value = value;
                                console.log(value);
                            },
                            function (error) {
                                console.error(error);
                            }
                        );
                    };
                    recorder.start();
                });
            }
            return false;
        }

        const blobToBase64 = blob => {
            const reader = new FileReader();
            reader.readAsDataURL(blob);
            return new Promise(resolve => {
                reader.onloadend = () => {
                    resolve(reader.result);
                };
            });
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Panel ID="pnlChoose" ClientIDMode="Static" runat="server">
                <asp:Label id="lblSuccess" ClientIDMode="Static" Runat="server"></asp:Label>
                <h1>Choose Your Own Adventure</h1>
                <asp:Button ID="btnUpload" CssClass="largeButton" runat="server" Text="Upload a sound file" OnClick="btnUpload_Click" />
                <asp:Button ID="btnRecord" CssClass="largeButton" runat="server" Text="Record audio" OnClick="btnRecord_Click" /><br />
                <asp:Button ID="btn" CssClass="medButton" runat="server" Text="Open Soundboard" OnClick="btn_Click" Width="275px" />
            </asp:Panel>
            <asp:Panel ID="pnlUpload" runat="server" Visible="false">
                <h2>Upload Audio File</h2>
                <asp:Label id="lblUploadError" ClientIDMode="Static" Runat="server"></asp:Label>
                <br />
                <asp:Label ID="Label2" runat="server" Text="Select audio file to upload:"></asp:Label>
                <br />
                <asp:FileUpload ID="FileUpload1" runat="server" />
                <br />
                <br />
                <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Upload" />
            </asp:Panel>
            <asp:Panel ID="pnlRecord" runat="server" Visible="false">
                <h2>Record Audio</h2>
                <ol>
                    <li><asp:Button CssClass="medButton" ID="recordButton" OnClientClick="return toggleRecording();" ClientIDMode="Static" runat="server" Text="Record/Stop" UseSubmitBehavior="False" CausesValidation="False" />
                <span id="spanRecording" class="readyToBlink">Recording...</span></li>
                    <li>Review recording<br />
                        <span id="audioObjectContainer"></span>
                    </li>
                    <li>
                        Name your recording: <asp:TextBox ID="txtRecordingName" runat="server"></asp:TextBox>
                    </li>
                    <li><asp:Button ID="btnSaveRecording" CssClass="medButton" runat="server" Text="Save recording" OnClick="btnSaveRecording_Click" /></li>
                </ol>
                <asp:HiddenField ID="hddnBase64Data" ClientIDMode="Static" runat="server" />
            </asp:Panel>
        </div>
    </form>
</body>
</html>


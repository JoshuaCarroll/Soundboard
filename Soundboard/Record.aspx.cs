using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Soundboard
{
    public partial class Record : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string strFileName;
            string strFilePath;
            string strFolder;
            strFolder = Server.MapPath("./sounds");
            // Retrieve the name of the file that is posted.
            strFileName = FileUpload1.PostedFile.FileName;
            strFileName = Path.GetFileName(strFileName);

            if (FileUpload1.FileName != "")
            {
                string[] allowedFileTypes = { ".M4A", ".MP3", ".WAV", ".WEBM" };
                if (allowedFileTypes.Contains(Path.GetExtension(strFileName).ToUpper()))
                {
                    // Create the folder if it does not exist.
                    if (!Directory.Exists(strFolder))
                    {
                        Directory.CreateDirectory(strFolder);
                        
                    }
                    // Save the uploaded file to the server.
                    strFilePath = GetUnusedFilename(strFolder + "\\" + strFileName);
                    FileUpload1.PostedFile.SaveAs(strFilePath);
                    lblSuccess.Text = string.Format("File saved as {0}", Path.GetFileName(strFilePath));

                    lblUploadError.Text = "";
                    pnlUpload.Visible = false;
                    pnlChoose.Visible = true;
                }
                else
                {
                    lblUploadError.Text = "<p>Only M4A, MP3, WAV, and WEBM files allowed.</p>";
                }
            }
            else
            {
                lblUploadError.Text = "<p>Click 'Browse' to select the file to upload.</p>";
            }
        }

        protected void btnSaveRecording_Click(object sender, EventArgs e)
        {
            string data = hddnBase64Data.Value;
            if (data.StartsWith("data:"))
            {
                data = data.Substring(data.IndexOf("base64,") + 7);
            }
            byte[] bytes = Convert.FromBase64String(data);
            string strFolder = Server.MapPath("./sounds");
            string strFilename = string.Format("{0}.webm", txtRecordingName.Text);
            string strPath = GetUnusedFilename(Path.Combine(strFolder, strFilename));
            File.WriteAllBytes(strPath, bytes);

            lblSuccess.Text = string.Format("Recording saved as {0}", Path.GetFileName(strPath));
            pnlChoose.Visible = true;
            txtRecordingName.Text = "";
            pnlRecord.Visible = false;
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            lblSuccess.Text = "";
            pnlChoose.Visible = false;
            pnlUpload.Visible = true;

        }

        protected void btnRecord_Click(object sender, EventArgs e)
        {
            lblSuccess.Text = "";
            pnlChoose.Visible = false;
            pnlRecord.Visible = true;
        }

        protected string GetUnusedFilename(string strFilePath)
        {
            int intSuffix = 0;

            while (File.Exists(strFilePath))
            {
                intSuffix++;
                strFilePath = string.Format("{0}\\{1}-{2}{3}", Path.GetDirectoryName(strFilePath), Path.GetFileNameWithoutExtension(strFilePath), intSuffix.ToString(), Path.GetExtension(strFilePath));
            }
            return strFilePath;
        }

        protected void btn_Click(object sender, EventArgs e)
        {
            Response.Redirect(".");
        }
    }
}
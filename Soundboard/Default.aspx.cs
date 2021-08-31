using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace Soundboard
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string[] allowedFileTypes = { ".M4A", ".MP3", ".WAV", ".WEBM" };
            string path = "sounds\\";
            string physicalPath = Server.MapPath(path);
            string[] files = Directory.GetFiles(physicalPath, "*.*", SearchOption.TopDirectoryOnly);
            string htmlButtons = "";
            string htmlObjects = "";

            foreach (string file in files)
            {
                string extension = Path.GetExtension(file).ToUpper();

                if (allowedFileTypes.Contains(extension))
                {
                    string filenameWithoutExtension = Path.GetFileNameWithoutExtension(file);
                    string virtualFilePath = path + Path.GetFileName(file);
                    htmlButtons += string.Format("<button id='btn{0}' onclick='return play(\"{0}\")'>{1}</button>", filenameWithoutExtension, filenameWithoutExtension.ToUpper());
                    htmlObjects += string.Format("<figure id='figure{1}'><figcaption>{1}</figcaption><audio id='{1}' controls onplay='audio_onplay(this.id);' onended='audio_onstop(this.id);' onpause='audio_onstop(this.id);'><source src='{0}' type='audio/mpeg'></audio></figure>", virtualFilePath, filenameWithoutExtension);
                }
            }

            lblOutput.Text = htmlButtons + htmlObjects;
        }
    }
}
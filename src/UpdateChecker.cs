using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Reflection;
using System.Windows.Forms;

namespace SwitchInputLanguage
{
    public static class UpdateChecker
    {
        private const string Owner = "sumonchai";
        private const string Repo = "Switch-Input-Language";
        private const string ApiUrl = "https://api.github.com/repos/" + Owner + "/" + Repo + "/releases/latest";

        private static readonly Version CurrentVersion = Assembly.GetExecutingAssembly().GetName().Version;

        public static void CheckForUpdate(Form owner)
        {
            try
            {
                var request = (HttpWebRequest)WebRequest.Create(ApiUrl);
                request.UserAgent = "SwitchInputLanguage";
                request.Timeout = 8000;

                using var response = request.GetResponse();
                using var reader = new StreamReader(response.GetResponseStream());
                string json = reader.ReadToEnd();

                string tag = ParseTag(json);
                if (string.IsNullOrEmpty(tag)) return;

                string versionStr = tag.TrimStart('v', 'V', 'r');
                if (!Version.TryParse(versionStr, out Version latest)) return;

                if (latest > CurrentVersion)
                {
                    var result = MessageBox.Show(
                        $"มีเวอร์ชันใหม่: {tag}\nเวอร์ชันปัจจุบัน: {CurrentVersion}\n\nต้องการดาวน์โหลดเลยหรือไม่?",
                        "พบการอัปเดต",
                        MessageBoxButtons.YesNo,
                        MessageBoxIcon.Information);

                    if (result == DialogResult.Yes)
                    {
                        string downloadUrl = ParseDownloadUrl(json);
                        if (!string.IsNullOrEmpty(downloadUrl))
                            Process.Start(new ProcessStartInfo(downloadUrl) { UseShellExecute = true });
                    }
                }
                else
                {
                    MessageBox.Show("คุณใช้เวอร์ชันล่าสุดแล้ว", "ไม่มีการอัปเดต", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
            }
            catch (WebException)
            {
                MessageBox.Show("ไม่สามารถเชื่อมต่ออินเทอร์เน็ตได้", "ข้อผิดพลาด", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
            catch (Exception ex)
            {
                MessageBox.Show($"เกิดข้อผิดพลาด: {ex.Message}", "ข้อผิดพลาด", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private static string ParseTag(string json)
        {
            int i = json.IndexOf("\"tag_name\"");
            if (i < 0) return null;
            int q1 = json.IndexOf('"', i + 10);
            int q2 = json.IndexOf('"', q1 + 1);
            return q1 >= 0 && q2 > q1 ? json.Substring(q1 + 1, q2 - q1 - 1) : null;
        }

        private static string ParseDownloadUrl(string json)
        {
            int i = json.IndexOf("\"browser_download_url\"");
            if (i < 0) return null;
            int q1 = json.IndexOf('"', i + 23);
            int q2 = json.IndexOf('"', q1 + 1);
            return q1 >= 0 && q2 > q1 ? json.Substring(q1 + 1, q2 - q1 - 1) : null;
        }
    }
}
using System;
using System.Diagnostics;
using System.Drawing;
using System.Windows.Forms;

namespace SwitchInputLanguage
{
    static class Program
    {
        private const string MutexName = "SwitchInputLanguage_SingleInstance";

        [STAThread]
        static void Main()
        {
            var mutex = new System.Threading.Mutex(true, MutexName, out bool isNew);
            if (!isNew) return;

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            Settings.Load();
            using var hook = new KeyboardHook();

            var tray = new NotifyIcon
            {
                Text    = "Switch Input Language\nCaps Lock = เปลี่ยนภาษา",
                Icon    = LoadIcon(),
                Visible = true,
            };

            var menu = new ContextMenuStrip();
            menu.Items.Add("ตั้งค่า Hold Duration...", null, (s, e) =>
            {
                hook.Paused = true;
                new SettingsForm().ShowDialog();
                hook.Paused = false;
                hook.ResetState();
            });
            menu.Items.Add(new ToolStripSeparator());
            menu.Items.Add("ตรวจหาการอัปเดต...", null, (s, e) =>
            {
                UpdateChecker.CheckForUpdate(null);
            });
            menu.Items.Add("เกี่ยวกับ", null, (s, e) =>
                Process.Start(new ProcessStartInfo("https://github.com/sumonchai/Switch-Input-Language") { UseShellExecute = true }));
            menu.Items.Add(new ToolStripSeparator());
            menu.Items.Add("ออก", null, (s, e) => Application.Exit());
            tray.ContextMenuStrip = menu;

            Application.ApplicationExit += (s, e) => { tray.Visible = false; tray.Dispose(); };
            Application.Run();
        }

        static Icon LoadIcon()
        {
            // โหลดจากไฟล์ที่อยู่ข้างๆ EXE → media\LJ LOGO.ico
            string exeDir  = AppDomain.CurrentDomain.BaseDirectory;
            string icoPath = System.IO.Path.Combine(exeDir, "media", "LJ LOGO.ico");
            if (System.IO.File.Exists(icoPath))
                return new Icon(icoPath, 16, 16);

            // fallback: วาด icon เองถ้าไม่พบไฟล์
            using var bmp = new Bitmap(16, 16);
            using var g   = Graphics.FromImage(bmp);
            g.Clear(Color.FromArgb(0, 103, 192));
            using var font = new Font("Segoe UI Emoji", 10, FontStyle.Regular, GraphicsUnit.Pixel);
            g.DrawString("\u2328", font, Brushes.White, -1, 0);
            return Icon.FromHandle(bmp.GetHicon());
        }
    }
}

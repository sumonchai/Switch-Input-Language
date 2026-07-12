using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

namespace SwitchInputLanguage
{
    static class Program
    {
        private const string MutexName = "SwitchInputLanguage_SingleInstance";

        public static string LogPath { get; } =
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
                "SwitchInputLanguage", "startup.log");

        public static void Log(string msg)
        {
            try
            {
                Directory.CreateDirectory(Path.GetDirectoryName(LogPath));
                File.AppendAllText(LogPath,
                    $"{DateTime.Now:yyyy-MM-dd HH:mm:ss} {msg}{Environment.NewLine}");
            }
            catch { }
        }

        [STAThread]
        static void Main()
        {
            var mutex = new System.Threading.Mutex(true, MutexName, out bool isNew);
            if (!isNew) { Log("MUTEX: already running, exit"); return; }

            Log("START: v" + System.Reflection.Assembly.GetExecutingAssembly().GetName().Version);

            AppDomain.CurrentDomain.UnhandledException += (s, e) =>
            {
                Log("CRASH: " + e.ExceptionObject);
                MessageBox.Show("เกิดข้อผิดพลาด:\n" + e.ExceptionObject,
                    "Switch Input Language", MessageBoxButtons.OK, MessageBoxIcon.Error);
            };

            try
            {
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);

                Settings.Load();
                Log("HOOK: installing...");
                using var hook = new KeyboardHook();
                Log("HOOK: OK");

                var tray = new NotifyIcon
                {
                    Text    = "Switch Input Language\nCaps Lock = เปลี่ยนภาษา",
                    Icon    = LoadIcon(),
                    Visible = true,
                };

                string exePath = Application.ExecutablePath;

                var menu = new ContextMenuStrip();
                menu.Items.Add("ตั้งค่า Hold Duration...", null, (s, e) =>
                {
                    hook.Paused = true;
                    new SettingsForm().ShowDialog();
                    hook.Paused = false;
                    hook.ResetState();
                });

                var startupItem = new ToolStripMenuItem("เริ่มต้นพร้อม Windows")
                {
                    Checked = StartupHelper.IsStartupEnabled()
                };
            startupItem.Click += (s, e) =>
            {
                bool newState = !startupItem.Checked;
                bool ok = StartupHelper.SetStartup(newState, exePath);
                Program.Log($"AUTOSTART: toggle={newState} ok={ok} enabled={StartupHelper.IsStartupEnabled()}");
                startupItem.Checked = ok ? newState : StartupHelper.IsStartupEnabled();
            };
                menu.Items.Add(startupItem);

                menu.Items.Add(new ToolStripSeparator());

                var passItem = new ToolStripMenuItem("ส่งต่อให้เครื่องรีโมท (Passthrough)")
                {
                    Checked = hook.Passthrough
                };
                passItem.Click += (s, e) =>
                {
                    passItem.Checked = !passItem.Checked;
                    hook.Passthrough = passItem.Checked;
                    hook.ResetState();
                };
                menu.Items.Add(passItem);

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
        catch (Exception ex)
        {
            Log("FATAL: " + ex);
            MessageBox.Show("ข้อผิดพลาดร้ายแรง:\n" + ex.Message,
                "Switch Input Language", MessageBoxButtons.OK, MessageBoxIcon.Error);
        }
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

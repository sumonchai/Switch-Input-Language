using System;
using System.IO;
using System.Windows.Forms;
using Microsoft.Win32;

namespace SwitchInputLanguage
{
    public static class StartupHelper
    {
        private const string RunKey = @"SOFTWARE\Microsoft\Windows\CurrentVersion\Run";
        private const string AppName = "SwitchInputLanguage";

        private static string StartupShortcutPath =>
            Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.Startup),
                "SwitchInputLanguage.lnk");

        public static bool IsStartupEnabled()
        {
            return RegistryEntryExists() || ShortcutExists();
        }

        private static bool RegistryEntryExists()
        {
            try
            {
                using (RegistryKey key = Registry.CurrentUser.OpenSubKey(RunKey))
                {
                    return key?.GetValue(AppName) != null;
                }
            }
            catch
            {
                return false;
            }
        }

        private static bool ShortcutExists()
        {
            return File.Exists(StartupShortcutPath);
        }

        public static bool SetStartup(bool enabled, string appPath)
        {
            bool ok = true;

            if (enabled)
            {
                ok &= SetRegistryEntry(true, appPath);
                ok &= CreateShortcut(appPath);
            }
            else
            {
                ok &= SetRegistryEntry(false, appPath);
                ok &= RemoveShortcut();
            }

            return ok;
        }

        private static bool SetRegistryEntry(bool enabled, string appPath)
        {
            try
            {
                using (RegistryKey key = Registry.CurrentUser.OpenSubKey(RunKey, true))
                {
                    if (key == null) return false;
                    if (enabled)
                        key.SetValue(AppName, "\"" + appPath + "\"");
                    else
                        key.DeleteValue(AppName, false);
                }
                return true;
            }
            catch (Exception ex)
            {
                MessageBox.Show(
                    "ไม่สามารถเขียน Registry AutoRun:\n" + ex.Message,
                    "Switch Input Language",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return false;
            }
        }

        private static bool CreateShortcut(string appPath)
        {
            try
            {
                string path = StartupShortcutPath;
                Directory.CreateDirectory(Path.GetDirectoryName(path));

                Type shellType = Type.GetTypeFromProgID("WScript.Shell");
                dynamic shell = Activator.CreateInstance(shellType);
                dynamic shortcut = shell.CreateShortcut(path);
                shortcut.TargetPath = appPath;
                shortcut.WorkingDirectory = Path.GetDirectoryName(appPath);
                shortcut.Description = "Switch Input Language";
                shortcut.Save();

                return true;
            }
            catch
            {
                return false;
            }
        }

        private static bool RemoveShortcut()
        {
            try
            {
                string path = StartupShortcutPath;
                if (File.Exists(path))
                    File.Delete(path);
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}

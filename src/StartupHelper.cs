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

        public static bool IsStartupEnabled()
        {
            try
            {
                using (RegistryKey key = Registry.CurrentUser.OpenSubKey(RunKey))
                {
                    if (key == null) return false;
                    return key.GetValue(AppName) != null;
                }
            }
            catch
            {
                return false;
            }
        }

        public static bool SetStartup(bool enabled, string appPath)
        {
            try
            {
                using (RegistryKey key = Registry.CurrentUser.OpenSubKey(RunKey, true))
                {
                    if (key == null)
                    {
                        Program.Log("STARTUP: OpenSubKey(RunKey, writable) returned null");
                        return false;
                    }
                    if (enabled)
                    {
                        string val = "\"" + appPath + "\"";
                        key.SetValue(AppName, val);
                        Program.Log($"STARTUP: enabled, path={val}");
                    }
                    else
                    {
                        key.DeleteValue(AppName, false);
                        Program.Log("STARTUP: disabled");
                    }
                }
                return true;
            }
            catch (Exception ex)
            {
                Program.Log($"STARTUP: error={ex.Message}");
                MessageBox.Show(
                    "ไม่สามารถเขียน Registry AutoRun:\n" + ex.Message,
                    "Switch Input Language",
                    MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return false;
            }
        }
    }
}

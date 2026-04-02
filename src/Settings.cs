using System;
using System.IO;

namespace SwitchInputLanguage
{
    static class Settings
    {
        private static readonly string _path = Path.Combine(
            Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
            "SwitchInputLanguage", "settings.txt");

        public static int HoldMs { get; private set; } = 500;

        public static void Load()
        {
            try
            {
                if (File.Exists(_path) &&
                    int.TryParse(File.ReadAllText(_path).Trim(), out int v))
                    HoldMs = Math.Max(100, Math.Min(900, v));
            }
            catch { }
        }

        public static void Save(int ms)
        {
            HoldMs = Math.Max(100, Math.Min(900, ms));
            try
            {
                Directory.CreateDirectory(Path.GetDirectoryName(_path));
                File.WriteAllText(_path, HoldMs.ToString());
            }
            catch { }
        }
    }
}

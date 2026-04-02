using System;
using System.Drawing;
using System.Windows.Forms;

namespace SwitchInputLanguage
{
    public class SettingsForm : Form
    {
        private TrackBar _slider;
        private Label    _label;

        public SettingsForm()
        {
            Text            = "ตั้งค่า CapsLock Hold";
            FormBorderStyle = FormBorderStyle.FixedDialog;
            MaximizeBox     = false;
            MinimizeBox     = false;
            StartPosition   = FormStartPosition.CenterScreen;
            ClientSize      = new Size(340, 140);
            Font            = new Font("Segoe UI", 10);

            var desc = new Label
            {
                Text      = "กดค้าง CapsLock นานแค่ไหน → Toggle Caps Lock จริง",
                AutoSize  = false,
                Size      = new Size(320, 20),
                Location  = new Point(10, 10),
                ForeColor = Color.Gray,
                Font      = new Font("Segoe UI", 8),
            };

            _label = new Label
            {
                Text      = $"{Settings.HoldMs} ms",
                AutoSize  = false,
                Size      = new Size(320, 26),
                Location  = new Point(10, 32),
                TextAlign = ContentAlignment.MiddleCenter,
                Font      = new Font("Segoe UI", 12, FontStyle.Bold),
            };

            // 1–9 steps → 100–900 ms (snap ตรงๆ ทุกขั้น)
            _slider = new TrackBar
            {
                Minimum       = 1,
                Maximum       = 9,
                TickFrequency = 1,
                SmallChange   = 1,
                LargeChange   = 1,
                Value         = Math.Max(1, Math.Min(9, Settings.HoldMs / 100)),
                Location      = new Point(10, 60),
                Size          = new Size(320, 36),
            };
            _slider.ValueChanged += (s, e) => _label.Text = $"{_slider.Value * 100} ms";

            var btnOk = new Button
            {
                Text     = "ตกลง",
                Size     = new Size(90, 28),
                Location = new Point(130, 104),
            };
            btnOk.Click += (s, e) =>
            {
                Settings.Save(_slider.Value * 100);
                Close();
            };

            Controls.AddRange(new Control[] { desc, _label, _slider, btnOk });
        }
    }
}

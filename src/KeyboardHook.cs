using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace SwitchInputLanguage
{
    public class KeyboardHook : IDisposable
    {
        // ── Hook ──────────────────────────────────────────────────────────────
        private const int  WH_KEYBOARD_LL = 13;
        private const int  WM_KEYDOWN     = 0x0100;
        private const int  WM_KEYUP       = 0x0101;
        private const uint VK_CAPITAL     = 0x14;

        // ── Language ──────────────────────────────────────────────────────────
        private const uint WM_INPUTLANGCHANGEREQUEST = 0x0050;
        private const uint KLF_ACTIVATE              = 0x00000001;

        // ── SendInput ─────────────────────────────────────────────────────────
        private const uint     INPUT_KEYBOARD  = 1;
        private const uint     KEYEVENTF_KEYUP = 0x0002;
        private static readonly UIntPtr OwnMark = (UIntPtr)0xCAFEF00D; // marker injection ของเรา

        // ── P/Invoke ──────────────────────────────────────────────────────────
        [DllImport("user32.dll")] static extern IntPtr SetWindowsHookEx(int id, LowLevelKeyboardProc fn, IntPtr mod, uint tid);
        [DllImport("user32.dll")] static extern bool   UnhookWindowsHookEx(IntPtr h);
        [DllImport("user32.dll")] static extern IntPtr CallNextHookEx(IntPtr h, int c, IntPtr w, IntPtr l);
        [DllImport("kernel32.dll")] static extern IntPtr GetModuleHandle(string n);

        [DllImport("user32.dll")] static extern IntPtr GetForegroundWindow();
        [DllImport("user32.dll")] static extern uint   GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
        [DllImport("user32.dll")] static extern IntPtr GetKeyboardLayout(uint tid);
        [DllImport("user32.dll")] static extern int    GetKeyboardLayoutList(int n, IntPtr[] list);
        [DllImport("user32.dll")] static extern IntPtr ActivateKeyboardLayout(IntPtr hkl, uint flags);
        [DllImport("user32.dll")] static extern bool   AttachThreadInput(uint from, uint to, bool attach);
        [DllImport("user32.dll")] static extern bool   PostMessage(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);
        [DllImport("kernel32.dll")] static extern uint  GetCurrentThreadId();
        [DllImport("user32.dll")] static extern uint   SendInput(uint n, INPUT[] inputs, int size);

        // ── Structs ───────────────────────────────────────────────────────────
        private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

        [StructLayout(LayoutKind.Sequential)]
        private struct KBDLLHOOKSTRUCT { public uint vkCode, scanCode, flags, time; public UIntPtr extra; }

        [StructLayout(LayoutKind.Sequential)]
        private struct INPUT { public uint type; public INPUTUNION u; }

        // union ต้องใหญ่เท่า MOUSEINPUT (member ที่ใหญ่สุด) เพื่อให้ sizeof(INPUT) ถูกต้อง
        [StructLayout(LayoutKind.Explicit)]
        private struct INPUTUNION
        {
            [FieldOffset(0)] public KEYBDINPUT ki;
            [FieldOffset(0)] public MOUSEINPUT mi;   // padding ให้ union ถูกขนาด
        }

        [StructLayout(LayoutKind.Sequential)]
        private struct MOUSEINPUT { public int dx, dy, mouseData, dwFlags, time; public UIntPtr extra; }

        [StructLayout(LayoutKind.Sequential)]
        private struct KEYBDINPUT { public ushort wVk, wScan; public uint dwFlags, time; public UIntPtr extra; }

        // ── State ─────────────────────────────────────────────────────────────
        private readonly LowLevelKeyboardProc _proc;
        private IntPtr   _hook;
        private bool     _isDown;
        private DateTime _downTime;
        public  bool     Paused { get; set; }

        private static int _layoutIdx = -1;

        // ── ctor / Dispose ────────────────────────────────────────────────────
        public KeyboardHook()
        {
            _proc = Callback;
            using var p = Process.GetCurrentProcess();
            using var m = p.MainModule;
            _hook = SetWindowsHookEx(WH_KEYBOARD_LL, _proc, GetModuleHandle(m.ModuleName), 0);
        }

        public void Dispose() => UnhookWindowsHookEx(_hook);
        public void ResetState() { _isDown = false; }

        // ── Hook callback ─────────────────────────────────────────────────────
        private IntPtr Callback(int nCode, IntPtr wParam, IntPtr lParam)
        {
            if (nCode >= 0)
            {
                var kb = Marshal.PtrToStructure<KBDLLHOOKSTRUCT>(lParam);

                if (kb.vkCode == VK_CAPITAL)
                {
                    // injection ของเราเอง → ปล่อยผ่านทันที
                    if (kb.extra == OwnMark)
                        return CallNextHookEx(_hook, nCode, wParam, lParam);

                    // ขณะ dialog เปิด → block ทั้งหมด
                    if (Paused)
                        return (IntPtr)1;

                    if (wParam == (IntPtr)WM_KEYDOWN)
                    {
                        if (!_isDown) { _isDown = true; _downTime = DateTime.Now; }
                        return (IntPtr)1;
                    }

                    if (wParam == (IntPtr)WM_KEYUP && _isDown)
                    {
                        _isDown = false;
                        double held = (DateTime.Now - _downTime).TotalMilliseconds;
                        if (held < Settings.HoldMs)
                            SwitchLanguage();
                        else
                            ToggleCapsLock();
                        return (IntPtr)1;
                    }
                }
            }
            return CallNextHookEx(_hook, nCode, wParam, lParam);
        }

        // ── เปลี่ยนภาษา ──────────────────────────────────────────────────────
        private static void SwitchLanguage()
        {
            IntPtr hWnd     = GetForegroundWindow();
            uint   fgThread = GetWindowThreadProcessId(hWnd, out _);
            uint   myThread = GetCurrentThreadId();

            int      count   = GetKeyboardLayoutList(0, null);
            IntPtr[] layouts = new IntPtr[count];
            GetKeyboardLayoutList(count, layouts);

            if (_layoutIdx < 0)
            {
                IntPtr current = GetKeyboardLayout(fgThread);
                _layoutIdx = Array.IndexOf(layouts, current);
                if (_layoutIdx < 0) _layoutIdx = 0;
            }

            _layoutIdx = (_layoutIdx + 1) % count;
            IntPtr next = layouts[_layoutIdx];

            AttachThreadInput(myThread, fgThread, true);
            ActivateKeyboardLayout(next, KLF_ACTIVATE);
            AttachThreadInput(myThread, fgThread, false);

            PostMessage(hWnd, WM_INPUTLANGCHANGEREQUEST, IntPtr.Zero, next);
        }

        // ── Toggle Caps Lock ──────────────────────────────────────────────────
        private static void ToggleCapsLock()
        {
            // รัน task หลัง callback return เพื่อหลีกเลี่ยง re-entrancy
            System.Threading.Tasks.Task.Run(() =>
            {
                System.Threading.Thread.Sleep(20);
                var inputs = new[]
                {
                    MakeKey(VK_CAPITAL, 0),
                    MakeKey(VK_CAPITAL, KEYEVENTF_KEYUP),
                };
                SendInput((uint)inputs.Length, inputs, Marshal.SizeOf(typeof(INPUT)));
            });
        }

        private static INPUT MakeKey(uint vk, uint flags) => new INPUT
        {
            type = INPUT_KEYBOARD,
            u    = new INPUTUNION { ki = new KEYBDINPUT { wVk = (ushort)vk, dwFlags = flags, extra = OwnMark } }
        };
    }
}

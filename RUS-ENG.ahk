keybd_event("down", 250)

keybd_event(key, duration=20)
{
  start := A_TickCount
  Loop
  {
    dllcall("keybd_event", uchar, GetKeyVK(key), uchar, GetKeySC(key), uint, 0, ptr, 0)  ;key down
    sleepTime := A_Index = 1 ? 400 : 40
    if (duration - A_TickCount + start > sleepTime)  ;if we have enough time before key up to sleep to the next key down
      sleep, sleepTime
    else
      sleep duration - A_TickCount + start + 1 ;sleep the remaining time
  } until (A_TickCount - start >= duration)
  dllcall("keybd_event", uchar, GetKeyVK(key), uchar, GetKeySC(key), uint, 2, ptr, 0)  ;key up
; https://autohotkey.com/boards/viewtopic.php?t=4357
GetArgs(CmdLine := "", Skip := 2) {
    Local pArgs := 0, nArgs := 0, A := []

    If (CmdLine == "") {
        CmdLine := DllCall("Kernel32.dll\GetCommandLineW", "WStr")
    }

    If (A_IsCompiled && Skip) {
        Skip--
    }

    pArgs := DllCall("Shell32.dll\CommandLineToArgvW", "WStr", CmdLine, "PtrP", nArgs, "Ptr") 

    Loop % (nArgs) {
        If (A_Index > Skip) {
            A[A_Index - Skip] := StrGet(NumGet((A_Index - 1) * A_PtrSize + pArgs), "UTF-16")
        }
    }

    A[0] := nArgs - Skip
    DllCall("Kernel32.dll\LocalFree", "Ptr", pArgs)
    Return A
}

GetLongPathName(FileName) {
    VarSetCapacity(Buffer, 4096, 0)
    DllCall("Kernel32.dll\GetLongPathNameW", "WStr", FileName, "Ptr", &Buffer, "UInt", 4096)
    Return StrGet(&Buffer)
}

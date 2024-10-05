MsgBox % UUID()
Clipboard := UUID() ; put UUID on clipboard for easy pasting

; Function UUID
; 	returns UUID member of the System Information structure in the SMBIOS information
;	this should be unique to a particular computer
UUID()
{
	For obj in ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\cimv2").ExecQuery("Select * From Win32_ComputerSystemProduct")
		return obj.UUID	; http://msdn.microsoft.com/en-us/library/aa394105%28v=vs.85%29.aspx
}
/* ---------------------------------------------------------------------------------------
	File: HiddenGem/GUID.ahk
	
	Globally Unique IDentifier (GUID) & Universally Unique IDentifier (UUID) 

	About: Author: 
		jNizm 

	About: Source: 
		https://autohotkey.com/boards/viewtopic.php?t=4732

	About: Categories: 
		misc, guid, uuid	

	About: License: 
		No license given
*/ 
/* Creates a GUID, a unique 128-bit integer used for CLSIDs and interface identifiers. */
CreateGUID()
{
  VarSetCapacity(pguid, 16, 0)
  if (DllCall("ole32.dll\CoCreateGuid", "ptr", &pguid) != 0)
    return (ErrorLevel := 1) & 0
  size := VarSetCapacity(sguid, 38 * (A_IsUnicode ? 2 : 1) + 1, 0)
  if !(DllCall("ole32.dll\StringFromGUID2", "ptr", &pguid, "ptr", &sguid, "int", size))
    return (ErrorLevel := 2) & 0
  return StrGet(&sguid)
}

/* Determines whether two GUIDs are equal. */
IsEqualGUID(guid1, guid2)
{
  return DllCall("ole32\IsEqualGUID", "ptr", &guid1, "ptr", &guid2)
}

/* Creates a new UUID. */
CreateUUID()
{
  VarSetCapacity(UUID, 16, 0)
  if (DllCall("rpcrt4.dll\UuidCreate", "ptr", &UUID) != 0)
    return (ErrorLevel := 1) & 0
  if (DllCall("rpcrt4.dll\UuidToString", "ptr", &UUID, "uint*", suuid) != 0)
    return (ErrorLevel := 2) & 0
  return StrGet(suuid), DllCall("rpcrt4.dll\RpcStringFree", "uint*", suuid)
}

/* Compare two UUIDs and determine whether they are equal. */
UuidEqual(uuid1, uuid2)
{
  return DllCall("rpcrt4.dll\UuidEqual", "ptr", &uuid1, "ptr", &uuid2, "ptr", &RPC_S_OK)
}


GUID_1 := CreateGUID()
GUID_2 := CreateGUID()
MsgBox % IsEqualGUID(GUID_1, GUID_2)    ; ==> 0
MsgBox % IsEqualGUID(GUID_1, GUID_1)    ; ==> 1

UUID_1 := CreateUUID()
UUID_2 := CreateUUID()
MsgBox % UuidEqual(UUID_1, UUID_2)    ; ==> 0
MsgBox % UuidEqual(UUID_1, UUID_1)    ; ==> 1
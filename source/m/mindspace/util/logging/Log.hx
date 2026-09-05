package m.mindspace.util.logging;

enum abstract Log(String) from String to String
{
	var PACKSTATE_CASE_NO_PACKS:String = '[PACKSTATE] No Packs installed!';
	var PACKSTATE_CASE_ONE_PACK:String = '[PACKSTATE] Only one Pack installed!';
	var PACKSTATE_CASE_MULTIPLE_PACKS:String = '[PACKSTATE] 2+ Packs installed!';
}

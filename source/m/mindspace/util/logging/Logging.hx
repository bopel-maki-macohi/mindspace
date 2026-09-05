package m.mindspace.util.logging;

import flixel.util.typeLimit.OneOfTwo;
import haxe.PosInfos;

class Logging
{
	public static var ogTrace:Dynamic->PosInfos->Void;

	public static function log(message:OneOfTwo<Log, String>)
	{
		trace('$message');
	}
}

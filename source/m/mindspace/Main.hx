package m.mindspace;

import openfl.events.Event;
import flixel.FlxGame;

class Main extends FlxGame
{
	public function new()
	{
		super(0, 0, PackState, 60, 60, true, false);
	}

	override function create(_:Event)
	{
		setupLogging();

		super.create(_);
	}

	function setupLogging()
	{
		Logging.ogTrace = haxe.Log.trace;

		haxe.Log.trace = function(str, ?infos)
		{
			#if js
			if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
				(untyped console).log(str);
			#elseif lua
			untyped __define_feature__("use._hx_print", _hx_print(str));
			#elseif sys
			Sys.println(str);
			#else
			throw new haxe.exceptions.NotImplementedException()
			#end
		}
	}
}

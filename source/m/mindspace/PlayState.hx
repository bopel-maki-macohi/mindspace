package m.mindspace;

import flixel.FlxState;

class PlayState extends FlxState
{
	var pack = 'base';

	override public function new(pack:String)
	{
		super();

		this.pack = pack;
	}
}

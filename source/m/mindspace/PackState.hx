package m.mindspace;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxSpriteContainer;
import flixel.FlxState;

class PackState extends FlxState
{
	final packs:Array<String> = [];

	var packIcons:FlxSpriteContainer;

	var uiCam:FlxCamera;
	var uiCamTarget:FlxObject;

	override function create()
	{
		super.create();

		getPacks();

		uiCam = new FlxCamera();
		FlxG.cameras.reset(uiCam);

		uiCamTarget = new FlxObject();
		add(uiCamTarget);

		uiCam.focusOn(uiCamTarget.getPosition());
        uiCam.follow(uiCamTarget, LOCKON, 0.04);

		packIcons = new FlxSpriteContainer();
		add(packIcons);

		for (pack in packs)
		{
			var packIconPath:String = 'packs/$pack/icon.png';

			if (!FileSystem.exists(packIconPath))
				packIconPath = 'ui/pack/noicon.png';

			var packIcon = new FlxSprite().loadGraphic(packIconPath);

			packIcon.setGraphicSize(160);
            packIcon.updateHitbox();

			packIcon.x = packIcon.width * 1.25;

			packIcons.add(packIcon);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

        uiCamTarget.x = packIcons.members[0].getGraphicMidpoint().x;
	}

	function getPacks()
	{
		var packDirs = FileSystem.readDirectoryForFolders('packs', RECURSIVE, ALLOW_SYS);

		for (dir in packDirs)
			if (dir.split('/').length != 2)
				packDirs.remove(dir);

		for (packDir in packDirs)
			packs.push(packDir.split('/')[1]);

		trace('packs', packs);
	}
}

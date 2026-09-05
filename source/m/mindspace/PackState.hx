package m.mindspace;

import flixel.text.FlxText;
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

	var uiSelection:Int = 0;

	override function create()
	{
		super.create();

		getPacks();

		if (packs.length < 2)
		{
			if (packs.length < 1)
			{
				var noPacks = new FlxText(0, 0, 0, 'NO PACKS ARE INSTALLED!\n\nPUT SOME PACKS INSIDE OF THE PACKS FOLDER', 16);
				noPacks.screenCenter();
				add(noPacks);

				return;
			}

			select();

			return;
		}

		uiCam = new FlxCamera();
		FlxG.cameras.reset(uiCam);

		uiCamTarget = new FlxObject();
		add(uiCamTarget);

		uiCam.focusOn(uiCamTarget.getPosition());
		uiCam.follow(uiCamTarget, LOCKON, 0.04);

		packIcons = new FlxSpriteContainer();
		add(packIcons);

		for (i => pack in packs)
		{
			var packIconPath:String = 'packs/$pack/icon.png';

			if (!FileSystem.exists(packIconPath))
				packIconPath = 'ui/pack/noicon.png';

			var packIcon = new FlxSprite().loadGraphic(packIconPath);

			packIcon.setGraphicSize(160);
			packIcon.updateHitbox();

			packIcon.x = i * (packIcon.width * 1.5);

			packIcon.ID = i;

			packIcons.add(packIcon);
		}

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([A, LEFT]))
			changeSelection(-1);
		if (FlxG.keys.anyJustPressed([D, RIGHT]))
			changeSelection(1);
		if (FlxG.keys.anyJustPressed([ENTER]))
			select();
	}

	function select()
	{
		FlxG.switchState(() -> new PlayState(packs[uiSelection]));
	}

	function changeSelection(amount:Int)
	{
		uiSelection += amount;

		if (uiSelection < 0)
			uiSelection = packIcons.length - 1;

		if (uiSelection > packIcons.length - 1)
			uiSelection = 0;

		for (packIcon in packIcons)
			packIcon.alpha = 0.5;

		uiCamTarget.x = packIcons.members[uiSelection].getGraphicMidpoint().x;
		uiCamTarget.y = packIcons.members[uiSelection].getGraphicMidpoint().y;
		packIcons.members[uiSelection].alpha = 1;
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

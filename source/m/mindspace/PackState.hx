package m.mindspace;

import flixel.FlxState;

class PackState extends FlxState
{
	override function create()
	{
		super.create();

		var packDirs = FileSystem.readDirectoryForFolders('packs', RECURSIVE);

		for (dir in packDirs)
			if (dir.split('/').length != 2)
				packDirs.remove(dir);

		trace(packDirs);
	}
}

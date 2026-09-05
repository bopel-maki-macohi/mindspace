package m.mindspace.util;

import lime.utils.Assets;
import haxe.io.Path;

class FileSystem
{
	public static function readDirectory(directory:String, recursive:Recursive):Array<Path>
	{
		var dir:Array<Path> = [];

		#if sys
		for (file in sys.FileSystem.readDirectory(directory))
		{
			final path = '${Path.removeTrailingSlashes(directory)}/$file';

			if (sys.FileSystem.isDirectory(path) && recursive)
			{
				for (filepath in readDirectory(path, recursive))
					dir.push(filepath);
			}
			else
				dir.push(new Path(path));
		}
		#else
		for (asset in Assets.list())
		{
			var path = new Path(asset);

			if (recursive)
			{
				if (path.dir.startsWith(directory))
					dir.push(path);
			}
			else
			{
				if (path.dir == directory)
					dir.push(path);
			}
		}
		#end

		return dir;
	}

	public static function readDirectoryForFolders(directory:String, recursive:Recursive):Array<String>
	{
		var dir = readDirectory(directory, recursive);
		var dirs = [];

		for (path in dir)
		{
			if (path == null)
				continue;

			if (!dirs.contains(path.dir))
				dirs.push(path.dir);
		}

		return dirs;
	}

	public static function getFile(filepath:String):String
	{
		#if sys
		return sys.io.File.getContent(filepath);
		#end

		return Assets.getText(filepath) ?? null;
	}
}

package m.mindspace.util;

import lime.utils.Assets;
import haxe.io.Path;

class FileSystem
{
	public static function readDirectory(directory:String, recursive:Recursive, allow_sys:AllowSys):Array<Path>
	{
		var dir:Array<Path> = [];

		var useAssets = function()
		{
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
		};

		#if sys
		if (allow_sys == ALLOW_SYS)
			for (file in sys.FileSystem.readDirectory(directory))
			{
				final path = '${Path.removeTrailingSlashes(directory)}/$file';

				if (sys.FileSystem.isDirectory(path) && recursive)
				{
					for (filepath in readDirectory(path, recursive, allow_sys))
						dir.push(filepath);
				}
				else
					dir.push(new Path(path));
			}
		else
			useAssets();
		#else
		useAssets();
		#end

		return dir;
	}

	public static function readDirectoryForFolders(directory:String, recursive:Recursive, allow_sys:AllowSys):Array<String>
	{
		var dir = readDirectory(directory, recursive, allow_sys);
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

	overload extern inline public static function getFile(filepath:String):String
	{
		#if sys
		return sys.io.File.getContent(filepath);
		#end

		return Assets.getText(filepath) ?? null;
	}

	overload extern inline public static function getFile(filepath:String, allow_sys:AllowSys):String
	{
		#if sys
		if (allow_sys == ALLOW_SYS)
			return sys.io.File.getContent(filepath);
		#end

		return Assets.getText(filepath) ?? null;
	}

	overload extern inline public static function exists(filepath:String):Bool
	{
		#if sys
		return sys.FileSystem.exists(filepath);
		#else
		return Assets.exists(filepath);
		#end
	}

	overload extern inline public static function exists(filepath:String, allow_sys:AllowSys):Bool
	{
		#if sys
		if (allow_sys == ALLOW_SYS)
			return sys.FileSystem.exists(filepath);
		#end

		return Assets.exists(filepath);
	}

	public static function reloadLibrary()
	{
		Assets.unloadLibrary('default');
		Assets.loadLibrary('default');
	}
}

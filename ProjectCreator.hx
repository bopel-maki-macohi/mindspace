import sys.io.File;

using StringTools;

class ProjectCreator
{
	final debug = #if debug true #else false #end;

	final mobile = #if (air && ios || air && android || android || blackberry || ios || tizen || webos || tvos) true #else false #end;
	final html5 = #if (flash || html5 || firefox || webassembly) true #else false #end;
	final desktop = #if (hashlink || windows || mac || linux || air && !android && !ios) true #else false #end;

	static function main()
	{
		new ProjectCreator();
	}

	final app_title = 'mindspace';
	final app_file = 'mindspace';
	final app_main = 'm.mindspace.Main';
	final app_version = '0.0.1';
	final app_company = 'M.';

	var window_background = '#000000';
	var window_width = 1280;
	var window_height = 720;
	var window_framerate = 60;
	var window_resizable = false;
	var window_orientation = 'auto';
	var window_fullscreen = false;

	var haxelibs:Array<String> = [];

	var defines:Array<String> = [];

	public function new()
	{
		downloadBaseProject();

		window_resizable = html5 || desktop;

		if (mobile)
		{
			window_width = 0;
			window_height = 0;
			window_fullscreen = true;
		}

		if (mobile || desktop)
			window_orientation = 'landscape';

		replaceTag('app_title', createTag('app', 'title', app_title));
		replaceTag('app_file', createTag('app', 'file', app_file));
		replaceTag('app_main', createTag('app', 'main', app_main));
		replaceTag('app_version', createTag('app', 'version', app_version));
		replaceTag('app_company', createTag('app', 'company', app_company));

		replaceTag('window_background', createTag('window', 'background', window_background));
		replaceTag('window_dimensions', [
			createTag('window', 'width', window_width),
			createTag('window', 'height', window_height)
		]);
		replaceTag('window_framerate', createTag('window', 'fps', window_framerate));
		replaceTag('window_resizable', createTag('window', 'resizable', window_resizable));
		replaceTag('window_orientation', createTag('window', 'orientation', window_orientation));
		replaceTag('window_fullscreen', createTag('window', 'fullscreen', window_fullscreen));

		replaceTag('build_directory', [
			createTag('set name="BUILD_DIR"', 'value', (debug) ? 'export/debug' : 'export/release'),
		]);

		replaceTag('path_assets', [
			createTag('assets rename="packs"', 'path', 'assets/packs'),
			createTag('assets rename="" embed="true"', 'path', 'assets/embed')
		]);

		usingHaxelib('flixel');
		replaceTag('haxelibs', haxelibs);

		addDefine('--dce', 'full');
		addDefine('FLX_NO_HEALTH');

		if (mobile)
		{
			addDefine('FLX_NO_MOUSE');
			addDefine('FLX_NO_KEYBOARD');
		}

		if (desktop)
		{
			addDefine('FLX_NO_TOUCH');
		}

		if (!debug)
		{
			addDefine('FLX_NO_DEBUG');
			addDefine('NAPE_RELEASE_BUILD');
		}

		replaceTag('defines', defines);

		saveProject();
	}

	var project:String = '';

	function downloadBaseProject()
	{
		project = File.getContent('dev/project-template.xml');
	}

	function saveProject()
	{
		File.saveContent('project.xml', project);
	}

	public overload inline extern function replaceTag(tag:String, replacement:Array<String>)
	{
		if (tag == null)
			return;
		if (replacement == null)
			replacement = [];

		replaceTag(tag, replacement.join('\n'));
	}

	public overload inline extern function replaceTag(tag:String, replacement:String)
	{
		if (tag == null)
			return;
		if (replacement == null)
			replacement = '';

		project = project.replace('<$tag />', replacement);
	}

	public overload inline extern function createTag(tag:String, property_name:String, property_value:Dynamic)
	{
		if (tag == null)
			return '';
		if (property_name == null || property_value == null)
			return '';

		return '<$tag $property_name="${property_value}"/>';
	}

	public function usingHaxelib(haxelib:String)
	{
		haxelibs.push('<haxelib name="${haxelib}"/>');
	}

	public function addDefine(define:String, ?value:String)
	{
		if (value != null)
			defines.push('<haxedef name="${define}" value="$value" />');
		else
			defines.push('<haxedef name="${define}" />');
	}
}

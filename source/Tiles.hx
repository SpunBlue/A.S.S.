package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Tiles extends FlxSprite
{
	public var type:String = "";

	public function new(tile:String, x:Float, y:Float)
	{
		super(x, y);

		type = tile;

		switch (tile)
		{
			default:
				makeGraphic(32, 32, FlxColor.PURPLE);
			case 'moon':
				loadGraphic(AssetPaths.moon__png, false, 32, 32);
		}

		immovable = true;

		allowCollisions = ANY;
		antialiasing = false;
	}
}

typedef TileData =
{
	type:String,
	x:Float,
	y:Float
}

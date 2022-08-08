package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var player:Player;
	var tempFloor:FlxSprite;

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF1D1D1D);

		player = new Player(24, 24);
		add(player);

		tempFloor = new FlxSprite(0, FlxG.height - 32).makeGraphic(FlxG.width, 32, FlxColor.WHITE);
		tempFloor.immovable = true;
		add(tempFloor);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		player.movement();
		player.jump();

		super.update(elapsed);

		FlxG.collide(player, tempFloor);
	}
}

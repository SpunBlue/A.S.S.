package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	public var speed:Int = 120;
	public var deceleration:Int = 15;

	public var gravity:Int = 100;

	public function new(x:Float, y:Float)
	{
		super();

		loadGraphic(AssetPaths.player__png, true, 32, 32);
		animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 12, true);
		animation.add("walk", [10, 11, 12, 13, 14, 15, 16, 17], 12, true);
		animation.play("idle");

		acceleration.y = gravity;
	}

	public function movement()
	{
		var left:Bool = FlxG.keys.anyPressed([A, LEFT]);
		var right:Bool = FlxG.keys.anyPressed([D, RIGHT]);

		if (left)
			velocity.x = -speed;
		else if (right)
			velocity.x = speed;
		else
		{
			if (velocity.x > 0)
				velocity.x -= deceleration;
			else if (velocity.x < 0)
				velocity.x += deceleration;
			else
			{
				velocity.x = 0;
				animation.play("idle");
			}
		}

		if (left || right)
			animation.play('walk');

		if (left && flipX == false)
			flipX = true;
		else if (right && flipX == true)
			flipX = false;
	}

	public function jump()
	{
		var jump:Bool = FlxG.keys.anyJustPressed([SPACE, UP]);

		if (jump && isTouching(FLOOR))
			velocity.y = -(gravity * 1.6);
	}
}

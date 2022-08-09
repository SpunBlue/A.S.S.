package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Enemy extends FlxSprite
{
	public var speed:Int;
	public var deceleration:Int;

	public var gravity:Int;

	public var type:String;

	public function new(x:Float, y:Float, enemy:String)
	{
		super(x, y);

		type = enemy;

		switch (enemy)
		{
			default:
				speed = 120;
				deceleration = 15;
				gravity = 100;
				loadGraphic(AssetPaths.alien__png, false, 32, 32);
				setSize(16, 32);
				offset.x += 8;
		}
	}

	public function aiMovement()
	{
		if (acceleration.y == 0)
		{
			velocity.x = -speed;
			acceleration.y = gravity;
		}

		if (isTouching(LEFT))
		{
			velocity.x = speed;
			// trace('I am touching the left wall');
		}
		else if (isTouching(RIGHT))
		{
			velocity.x = -speed;
			// trace('I am touching the right wall');
		}
	}
}

typedef EnemyData =
{
	type:String,
	x:Float,
	y:Float
}

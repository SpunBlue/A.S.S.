package;

import Enemy.EnemyData;
import Tiles.TileData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import haxe.Json;
import sys.io.File;

class PlayState extends FlxState
{
	var player:Player;
	var daEnemy:Enemy;

	var tempFloor:FlxSprite;

	var funnyTile:Tiles;

	var tileGroup:FlxTypedGroup<Tiles> = new FlxTypedGroup<Tiles>();
	var enemyGroup:FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();

	var bullets:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	override public function create()
	{
		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFF1D1D1D);
		bg.scrollFactor.set(0, 0);
		add(bg);

		add(tileGroup);
		add(bullets);
		add(enemyGroup);

		player = new Player(24, 24);
		add(player);

		FlxG.camera.follow(player, PLATFORMER, 0.65);

		FlxG.worldBounds.set(0, 0, 9999999, 9999999);

		/*tempFloor = new FlxSprite(0, FlxG.height - 32).makeGraphic(FlxG.width, 32, FlxColor.WHITE);
			tempFloor.immovable = true;
			add(tempFloor); */

		super.create();

		load();
	}

	override public function update(elapsed:Float)
	{
		if (player != null)
		{
			player.movement();
			player.jump();
		}

		for (enemy in enemyGroup.members)
		{
			enemy.aiMovement();

			for (bullet in bullets)
			{
				if (FlxG.overlap(bullet, enemy))
				{
					enemy.kill();
					bullet.kill();
				}
			}
		}

		for (bullet in bullets)
		{
			if (FlxG.overlap(bullet, tileGroup))
				bullet.kill();

			if (bullet.isOnScreen() == false)
				bullet.kill();
		}

		if (daEnemy != null)
			daEnemy.aiMovement();

		super.update(elapsed);

		FlxG.collide(player, tileGroup);
		FlxG.collide(enemyGroup, tileGroup);

		if (FlxG.overlap(player, enemyGroup))
		{
			FlxG.switchState(new TitleState());
		}

		if (FlxG.keys.anyJustPressed([E, Q, CONTROL]))
			createBullet();

		if (FlxG.keys.anyJustPressed([R]))
			FlxG.switchState(new PlayState());
	}

	function load()
	{
		var json = Json.parse(File.getContent("assets/data/lvl1.json"));

		player.x = json.playerPos[0];
		player.y = json.playerPos[1];

		var daTiles:Array<TileData> = json.tiles;
		var daEnemies:Array<EnemyData> = json.enemies;

		for (tile in daTiles)
		{
			var data:TileData = tile;
			funnyTile = new Tiles(data.type, data.x, data.y);
			// trace('type: ' + data.type + ' x: ' + data.x + ' y: ' + data.y);
			tileGroup.add(funnyTile);
		}

		for (enemy in daEnemies)
		{
			if (enemy != null)
			{
				var data:EnemyData = enemy;

				daEnemy = new Enemy(data.x, data.y, data.type);
				enemyGroup.add(daEnemy);
			}
		}
	}

	function createBullet()
	{
		var bullet = new FlxSprite(player.x, player.y + 8).makeGraphic(8, 6, FlxColor.ORANGE);
		bullets.add(bullet);

		if (player.facing == LEFT)
			bullet.velocity.x = -180;
		else
			bullet.velocity.x = 180;
	}
}

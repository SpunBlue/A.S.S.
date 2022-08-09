package;

import Enemy.EnemyData;
import Tiles.TileData;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;

class LevelEditor extends FlxState
{
	var uiCordText:FlxText;

	var funnyTile:Tiles;
	var funnyEnemy:Enemy;
	var playerPos:FlxSprite;

	var levelName:String = 'lvl1';
	var cursor:FlxSprite;

	var tileSelected:String = 'moon';

	var tileArray:Array<Tiles> = new Array<Tiles>();
	var enemyArray:Array<Enemy> = new Array<Enemy>();

	var tileGroup:FlxTypedGroup<Tiles> = new FlxTypedGroup<Tiles>();
	var enemyGroup:FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();
	var uiGroup:FlxGroup = new FlxGroup();

	override public function create()
	{
		cursor = new FlxSprite(0, 0).makeGraphic(32, 32, FlxColor.RED);
		cursor.alpha = 0.6;
		uiGroup.add(cursor);

		uiCordText = new FlxText(0, 0, 512, "x: 0 y: 0", 16);
		uiCordText.setFormat(null, 16, FlxColor.WHITE, "center");
		uiCordText.scrollFactor.set(0, 0);
		uiGroup.add(uiCordText);

		playerPos = new FlxSprite(0, 0).makeGraphic(32, 32, FlxColor.BLUE);
		add(playerPos);

		add(tileGroup);
		add(enemyGroup);
		add(uiGroup);

		FlxG.camera.setScrollBounds(0, 9999999, 0, 9999999);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		uiCordText.text = "x: " + cursor.x + " y: " + cursor.y;

		cursor.x = Math.floor(FlxG.mouse.x / 32) * 32;
		cursor.y = Math.floor(FlxG.mouse.y / 32) * 32;

		if (FlxG.mouse.justPressed)
		{
			funnyTile = new Tiles(tileSelected, cursor.x, cursor.y);
			funnyTile.setPosition(cursor.x, cursor.y);
			tileGroup.add(funnyTile);
			tileArray.push(funnyTile);
		}

		if (FlxG.mouse.pressedMiddle)
		{
			playerPos.setPosition(cursor.x, cursor.y);
		}

		if (FlxG.keys.anyJustPressed([E]))
		{
			funnyEnemy = new Enemy(cursor.x, cursor.y, 'default');
			enemyArray.push(funnyEnemy);
			enemyGroup.add(funnyEnemy);
		}

		for (tile in tileArray)
		{
			if (FlxG.mouse.justPressedRight && cursor.overlaps(tile))
			{
				tileArray.remove(tile);
				tile.kill();
			}
		}

		for (enemy in enemyArray)
		{
			if (FlxG.mouse.justPressedRight && cursor.overlaps(enemy))
			{
				enemyArray.remove(enemy);
				enemy.kill();
			}
		}

		if (FlxG.keys.anyPressed([LEFT, A]))
		{
			FlxG.camera.scroll.x -= 25;
		}
		else if (FlxG.keys.anyPressed([RIGHT, D]))
		{
			FlxG.camera.scroll.x += 25;
		}

		if (FlxG.keys.anyPressed([UP, W]))
		{
			FlxG.camera.scroll.y -= 25;
		}
		else if (FlxG.keys.anyPressed([DOWN, S]))
		{
			FlxG.camera.scroll.y += 25;
		}

		if (FlxG.keys.anyJustPressed([ENTER, SPACE]))
		{
			save();
		}

		if (FlxG.keys.anyJustPressed([L]))
		{
			load();
		}

		if (FlxG.keys.anyJustPressed([ESCAPE]))
		{
			FlxG.switchState(new TitleState());
		}
	}

	function save()
	{
		var playerPosArray:Array<Float> = new Array<Float>();
		playerPosArray = [playerPos.x, playerPos.y];

		var tileData:Array<TileData> = [];
		var enemyData:Array<EnemyData> = [];

		for (tile in tileArray)
		{
			if (tile != null)
				tileData.push({x: tile.x, y: tile.y, type: tile.type});
		}

		for (enemy in enemyArray)
		{
			if (enemy != null)
				enemyData.push({x: enemy.x, y: enemy.y, type: enemy.type});
		}

		var json = Json.stringify({playerPos: playerPosArray, tiles: tileData, enemies: enemyData}, '\t');

		// trace(json);
		File.saveContent('assets/data/$levelName.json', json);

		// File.saveContent('stuff.txt', tempTileArray.toString());
	}

	function load()
	{
		var json = Json.parse(File.getContent("assets/data/lvl1.json"));

		playerPos.x = json.playerPos[0];
		playerPos.y = json.playerPos[1];

		var daTiles:Array<TileData> = json.tiles;
		var daEnemies:Array<EnemyData> = json.enemies;

		for (tile in daTiles)
		{
			var data:TileData = tile;
			funnyTile = new Tiles(data.type, data.x, data.y);
			// trace('type: ' + data.type + ' x: ' + data.x + ' y: ' + data.y);
			tileGroup.add(funnyTile);
			tileArray.push(funnyTile);
		}

		for (enemy in daEnemies)
		{
			if (enemy != null)
			{
				var data:EnemyData = enemy;

				funnyEnemy = new Enemy(data.x, data.y, data.type);
				enemyGroup.add(funnyEnemy);
				enemyArray.push(funnyEnemy);
			}
		}
	}
}

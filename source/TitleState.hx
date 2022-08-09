package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

class TitleState extends FlxState
{
	override public function create()
	{
		super.create();

		var titleText:FlxText = new FlxText(0, 0, FlxG.width, "A.S.S. (Alien Shooting Simulator)", 8);
		titleText.setFormat(null, 8, 0xffffffff, "center");
		add(titleText);

		var instructionsText:FlxText = new FlxText(0, FlxG.height - 64, FlxG.width, "Press space to start", 8);
		instructionsText.setFormat(null, 8, 0xffffffff, "center");
		add(instructionsText);

		var levelEditorInstructionsText:FlxText = new FlxText(0, FlxG.height - 24, FlxG.width, "Press L to edit levels", 8);
		levelEditorInstructionsText.setFormat(null, 8, 0xffffffff, "center");
		add(levelEditorInstructionsText);

		// control instructions
		var controlInstructionsText:FlxText = new FlxText(0, FlxG.height - 48, FlxG.width,
			"Controls: A, D | Left, Right = Movement. E, Q, Control = Shoot. R = Reset.", 8);

		controlInstructionsText.setFormat(null, 8, 0xffffffff, "center");
		add(controlInstructionsText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE)
			FlxG.switchState(new PlayState());

		if (FlxG.keys.justPressed.L)
			FlxG.switchState(new LevelEditor());
	}
}

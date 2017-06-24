//  Containers
var characterList:Array = new Array(); /// holds a list of all character ‘slots’
var characterGrid:Array = new Array(); /// represents the character select screen via a 2D array

//  Grid Settings
/// Make sure ’characterRows’ × ’characterColumns’ is equal to the length of ’characterList’
var characterRows:uint = 4; /// number of rows
var characterColumns:uint = 8; /// number of columns
var gridSpacingX:uint = 20;
var gridSpacingY:uint = 20;

//  Control Settings
/// Change the control keys here
var selectedColumn = 0; /// used to manage the current selected column
var selectedRow = 0; /// used to manage the current selected row
var leftPress, rightPress, upPress, downPress; /// used to manage key presses
var leftKey = Keyboard.LEFT;
var rightKey = Keyboard.RIGHT;
var upKey = Keyboard.UP;
var downKey = Keyboard.DOWN;

//  Selection variables
/// used to manage graphic selection
var currentSelection;
var currentTarget:MovieClip
var prevTarget:MovieClip;

//  The Character Roster
/// Arrange these in order of how you want them to appear on the select screen (right to left)
characterList = [
	'Astaroth',
	'Cervantes',
	'Chie',
	'Hwang',
	'Ivy',
	'Kilik',
	'Li Long',
	'Maxi',
	'Mitsurugi',
	'Monkasei',
	'Nightmare',
	'Rock',
	'Seong Mi-na',
	'Siegfried',
	'Sophitia',
	'Taki',
	'Voldo',
	'Xianghua',
	'Yoshimitsu',
	'Cassandra',
	'Charade',
	'Necrid',
	'Raphael',
	'Talim',
	'Yunsung',
	'Heihachi',
	'Spawn',
	'Link',
	'Assassin',
	'Berserker',
	'Lizardman',
	'Inferno'
];

//  Main function to setup the grid (in data)
function setupCharacterGrid(rows:uint, columns:uint):void {
	if(rows * columns < characterList.length) {
		trace('Error: Grid (' + rows + '×' + columns + '=' + (rows * columns) + ') is less than the amount of characters (' + characterList.length + ').\n');
		return;
	}else if(rows * columns > characterList.length) {
		trace('Warning: Grid (' + rows + '×' + columns + '=' + (rows * columns) + ') is greater than the amount of characters (' + characterList.length + '). Empty slots will be used.\n');
	}else {
		trace('Grid okay!\n');
	}

	var characterCount:uint = 0;

	for(var i:uint = 0; i < rows; i++) {
		characterGrid[i] = [];

		for(var j:uint = 0; j < columns; j++) {
			if(characterList[characterCount]) {
				characterGrid[i][j] = (characterList[characterCount]);
			}else {
				characterGrid[i][j] = ('empty');
			}
			characterCount++;
		}

		trace('Row' + (i + 1) + ': ' + characterGrid[i]);
	}
}

//  Main function to render character select screen into the SWF
function createSelectionScreen(spacingX:uint, spacingY:uint, split:Boolean):void {
	var columnSpacing = spacingX;
	var rowSpacing = spacingY;
	var currentX = 0;
	var currentY = 0;
	var horizontalSplit;

	currentX = rowSpacing;
	currentY = columnSpacing;

	trace(currentX + ', ' + currentY);

	for(var i:uint = 0; i < characterGrid.length; i++) {
		var tempHeight;

		if(split) {
			horizontalSplit = characterGrid[i].length / 2;
			trace('horizontalSplit: ' + horizontalSplit);
		}

		for(var j:uint = 0; j < characterGrid[i].length; j++) {
			var characterIcon = new CharacterIcon();
			var characterName:TextField = new TextField();

			characterName.text = characterGrid[i][j];

			addChild(characterIcon);
			characterIcon.name = characterGrid[i][j];
			characterIcon.addChild(characterName);

			if(split) {
				if(j == horizontalSplit) {
					currentX = stage.stageWidth - characterIcon.width - columnSpacing;
					trace('currentX: ' + currentX);
				}
			}

			characterIcon.x = currentX;
			characterIcon.y = currentY;

			if(split) {
				if(j >= horizontalSplit) {
					currentX -= (characterIcon.width + columnSpacing);
					trace('Split: ' + currentX);
				}else {
					currentX += (characterIcon.width + columnSpacing);
					trace('No split yet: ' + currentX);
				}
			}else {
				currentX += (characterIcon.width + columnSpacing);
			}

			tempHeight = characterIcon.height;
		}

		currentX = 0 + columnSpacing;
		currentY += tempHeight + rowSpacing;
	}
}

//  Controls functionality of key presses
function keyDowns(event:KeyboardEvent):void {
	if(event.keyCode == leftKey) {
		if(!leftPress) {
			leftPress = true;
			moveLeft();
			updateSelection();
		}
	}else if(event.keyCode == rightKey) {
		if(!rightPress) {
			rightPress = true;
			moveRight();
			updateSelection();
		}
	}else if(event.keyCode == upKey) {
		if(!upPress) {
			upPress = true;
			moveUp();
			updateSelection();
		}
	}else if(event.keyCode == downKey) {
		if(!downPress) {
			downPress = true;
			moveDown();
			updateSelection();
		}
	}
}

//  Controls functionality of key releases
function keyUps(event:KeyboardEvent):void {
	if(event.keyCode == leftKey) {
		if(leftPress) {
			leftPress = false;
			event.keyCode = 0;
		}
	}else if(event.keyCode == rightKey) {
		if(rightPress) {
			rightPress = false;
			event.keyCode = 0;
		}
	}else if(event.keyCode == upKey) {
		if(upPress) {
			upPress = false;
			event.keyCode = 0;
		}
	}else if(event.keyCode == downKey) {
		if(downPress) {
			downPress = false;
			event.keyCode = 0;
		}
	}
}

function moveLeft():void {
	selectedColumn--;

	if(selectedColumn < 0) {
		selectedColumn = (characterColumns - 1);
	}
}

function moveRight():void {
	selectedColumn++;

	if(selectedColumn > (characterColumns - 1)) {
		selectedColumn = 0;
	}
}

function moveUp():void {
	selectedRow--;

	if(selectedRow < 0) {
		selectedRow = (characterRows - 1);
	}
}

function moveDown():void {
	selectedRow++;

	if(selectedRow > (characterRows - 1)) {
		selectedRow = 0;
	}
}

function updateSelection():void {
	currentSelection = characterGrid[selectedRow][selectedColumn];
	currentTarget = this.getChildByName('' + currentSelection) as MovieClip;

	if(prevTarget) {
		trace('prevTarget: ' + prevTarget.name);
		prevTarget.gotoAndStop(1);
	}

	trace(selectedRow + ', ' + selectedColumn);
	trace('currentSelection: ' + currentSelection);
	trace('currentTarget: ' + currentTarget.name);
	trace('—————\n');

	currentTarget.gotoAndStop(2);
	prevTarget = currentTarget;

}

//  Call setup functions
setupCharacterGrid(characterRows, characterColumns);
createSelectionScreen(gridSpacingX, gridSpacingY, false);
updateSelection();

//  Call event functions
stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDowns);
stage.addEventListener(KeyboardEvent.KEY_UP, keyUps);
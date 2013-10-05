package net.jonstout.miner.control
{
	import net.jonstout.miner.data.Notification;
	import net.jonstout.miner.model.GameState;
	import net.jonstout.miner.model.TileState;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GenerateGameCommand extends SimpleCommand
	{
		private var gameState:GameState;
		
		public function GenerateGameCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void 
		{
			gameState = new GameState(notification.getBody().width, notification.getBody().height, notification.getBody().bombs);
			var baseMap:Vector.<Boolean> = generateMap(gameState.width, gameState.height, gameState.totalBombs);
			var index:int = 0;
			var tile:TileState;
			// generate tiles for game state
			// for each row
			for (var y:int=0; y<gameState.height; ++y) {
				// for each column
				for (var x:int=0; x<gameState.width; ++x) {
					tile = new TileState();
					tile.index = index;
					tile.mapX = x;
					tile.mapY = y;
					tile.isBomb = baseMap[index];
					gameState.addTile(tile);
					// increment index for next pass
					index++;
				}
			}
			// now we're done, go back through and calculate bombCounts for the non-bomb tiles
			for each (tile in gameState.map) {
				if (!tile.isBomb) {
					tile.bombCount = getBombCount(tile.mapX, tile.mapY);
				}
			}
			// send on game state and shut down
			sendNotification(Notification.SHOW_GAME_VIEW);
			sendNotification(Notification.DISPLAY_GAME, gameState);
			gameState=null;
		}
		
		private function generateMap(width:int, height:int, bombNum:int):Vector.<Boolean> {
			var totalTiles:int = width * height;
			// generate base game map populated with bombs
			var map:Vector.<Boolean> = new Vector.<Boolean>(totalTiles, true);
			for (var i:int = 0; i<totalTiles; ++i) {
				if (i < bombNum) {
					map[i] = true;
				} else {
					map[i] = false;
				}
			}
			// shuffle vector map
			var counter:int = totalTiles;
			var temp:Boolean;
			var index:int;
			// while there are elements in vector
			while (counter > 0) {
				// pick random index
				index = Math.floor(Math.random()*counter);
				// swap last element with it
				counter--;
				temp = map[counter];
				map[counter] = map[index];
				map[index] = temp;
			}
			return map;
		}
		
		private function getBombCount(tileX:int, tileY:int):int {
			var count:int = 0;
			var xBehind:int = tileX-1;
			var xForward:int = tileX+1;
			var yUp:int = tileY-1;
			var yDown:int = tileY+1;
			var temp:TileState;
			// search row above tile
			if (yUp >= 0) {
				for (var tempX:int=xBehind; tempX<=xForward; tempX++) {
					temp = gameState.getTile(tempX, yUp); // this function will return null if topX is less than 0
					if ( isTileBomb(temp) ) {
						count++;
					}
				}
			}
			// check tiles to the left and the right
			temp = gameState.getTile(xBehind, tileY);
			if ( isTileBomb(temp) ) {
				count++;
			}
			temp = gameState.getTile(xForward, tileY);
			if ( isTileBomb(temp) ) {
				count++;
			}
			// search row below tile
			if (yDown < gameState.height) {
				for (tempX=xBehind; tempX<=xForward; tempX++) {
					temp = gameState.getTile(tempX, yDown);
					if ( isTileBomb(temp) ) {
						count++;
					}
				}
			}
			// return total count
			return count;
		}
		
		private function isTileBomb(tile:TileState):Boolean {
			return (tile != null && tile.isBomb);
		}
	}
}
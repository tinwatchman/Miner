package net.jonstout.miner.control
{
	import net.jonstout.miner.data.NotificationName;
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
			var baseMap:Vector.<Boolean> = generateBaseMap(gameState.width, gameState.height, gameState.totalBombs);
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
			for (y=0; y<gameState.height; ++y) {
				for (x=0; x<gameState.width; ++x) {
					tile = gameState.map[y][x] as TileState;
					if ( !isBombTile(tile) ) {
						tile.bombCount = getBombCount(x, y);
					}
				}
			}
			// send on game state and shut down
			sendNotification(NotificationName.SHOW_GAME_VIEW);
			sendNotification(NotificationName.DISPLAY_GAME, gameState);
			gameState=null;
		}
		
		/**
		 * This function generates a random distribution of bombs across a map of a given area.
		 * @param map width
		 * @param map height
		 * @param number of bombs
		 * @return Vector of Booleans (representing whether or not that tile is a bomb)
		 */
		private function generateBaseMap(width:int, height:int, bombNum:int):Vector.<Boolean> {
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
		
		/**
		 * @param tile's x coordinate
		 * @param tile's y coordinate
		 * @return count of bomb tiles around the given tile's position
		 */
		private function getBombCount(tileX:int, tileY:int):int {
			var vicinity:Vector.<TileState> = gameState.getTileVicinity(tileX, tileY);
			var len:int = vicinity.length;
			var count:int = 0;
			for (var i:int=0; i<len; ++i) {
				if ( isBombTile(vicinity[i]) ) {
					count++;
				}
			}			
			// return total count
			return count;
		}
		
		/**
		 * Checks to see if the tile exists and if it is a bomb tile.
		 * @param tile
		 * @return true or false
		 */
		private function isBombTile(tile:TileState):Boolean {
			return (tile != null && tile.isBomb);
		}
	}
}
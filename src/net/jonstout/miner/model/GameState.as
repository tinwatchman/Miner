package net.jonstout.miner.model
{
	public class GameState
	{
		private var _width:int;
		private var _height:int;
		private var _numBombs:int;
		private var _totalBombs:int=0;		
		private var _map:Object;
		private var _bombTiles:Vector.<TileState>;
		private var _isGameOver:Boolean=false;
		private var getTileKey:String;
		
		public function GameState(width:int, height:int, numBombs:int)
		{
			_width = width;
			_height = height;
			_numBombs = numBombs;
			_totalBombs = numBombs;
			_map = new Object();
			_bombTiles = new Vector.<TileState>();
		}
		
		// getters-setters
		
		public function get width():int
		{
			return _width;
		}
		
		public function get height():int
		{
			return _height;
		}
		
		public function get numBombs():int
		{
			return _numBombs;
		}
		
		public function set numBombs(value:int):void
		{
			_numBombs = value;
		}
		
		public function get totalBombs():int
		{
			return _totalBombs;
		}
		
		public function get map():Object
		{
			return _map;
		}
		
		public function get bombTiles():Vector.<TileState>
		{
			return _bombTiles;
		}
		
		public function get isGameOver():Boolean
		{
			return _isGameOver;
		}
		
		public function set isGameOver(value:Boolean):void
		{
			_isGameOver = value;
		}
		
		// tile functions
		
		public function addTile(tile:TileState):void {
			_map[ String(tile.mapX + "_" + tile.mapY) ] = tile;
			if (tile.isBomb) {
				_bombTiles.push(tile);
			}
		}
		
		public function getTile(x:int, y:int):TileState {
			if (x >= 0 && y >= 0 && x < _width && y < _height) {
				getTileKey = x + "_" + y;
				return _map[ getTileKey ] as TileState;
			}
			return null;
		}
		
		/**
		 * Get all tiles immediately surrounding coordinates of given tile 
		 * @param x
		 * @param y
		 * @return Vector of neighboring TileStates
		 */
		public function getTileVicinity(x:int, y:int):Vector.<TileState> {
			var xBehind:int = x-1;
			var xForward:int = x+1;
			var yUp:int = y-1;
			var yDown:int = y+1;
			const searchPattern:Array = [
				{'x':xBehind,'y':yUp}, // top-left
				{'x':x, 'y':yUp}, // top
				{'x':xForward, 'y':yUp}, // top-right
				{'x':xBehind, 'y':y}, // left
				{'x':xForward, 'y':y}, // right
				{'x':xBehind, 'y':yDown}, // bottom-left
				{'x':x, 'y':yDown}, // bottom
				{'x':xForward, 'y':yDown} // bottom-right
			];
			var vicinity:Vector.<TileState> = new Vector.<TileState>();
			var temp:TileState;
			for (var i:int = 0; i<8; ++i) {
				temp = getTile( searchPattern[i]['x'], searchPattern[i]['y'] );
				if (temp != null) {
					vicinity.push(temp);
				}
			}
			return vicinity;
		}
				
		public function dispose():void 
		{
			for (var key:String in _map) {
				delete _map[key];
			}
			_map = null;
			_bombTiles.splice(0, _bombTiles.length);
			_width = -1;
			_height = -1;
			_totalBombs = -1;
			isGameOver = false;
		}
	}
}
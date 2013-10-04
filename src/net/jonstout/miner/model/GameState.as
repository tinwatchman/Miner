package net.jonstout.miner.model
{
	/**
	 * Contains and organizes all data related to a single game
	 */
	public class GameState
	{
		private var _width:int;
		private var _height:int;
		private var _numBombs:int;
		private var _totalBombs:int=0;		
		private var _bombTiles:Vector.<TileState>;
		private var _isGameOver:Boolean=false;
		private var _map:Array;
		
		public function GameState(width:int, height:int, numBombs:int)
		{
			_width = width;
			_height = height;
			_numBombs = numBombs;
			_totalBombs = numBombs;
			_bombTiles = new Vector.<TileState>();
			// create map and create a dictionary for each row
			_map = new Array();
			for (var yCoord:int=0; yCoord<_height; yCoord++) {
				_map[yCoord] = new Array();
			}
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
		
		public function get map():Array
		{
			return _map;
		}
				
		// tile functions
		
		public function addTile(tile:TileState):void {
			_map[tile.mapY][tile.mapX] = tile;
			if (tile.isBomb) {
				_bombTiles.push(tile);
			}
		}
		
		public function getTile(x:int, y:int):TileState {
			if (x >= 0 && y >= 0 && x < _width && y < _height) {
				return _map[y][x] as TileState;
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
			const searchPattern:Array = new Array(
				[(x-1),(y-1)], // top-left
				[x, (y-1)], // top
				[(x+1), (y-1)], // top-right
				[(x-1), y], // left
				[(x+1), y], // right
				[(x-1), (y+1)], // bottom-left
				[x, (y+1)], // bottom
				[(x+1), (y+1)] // bottom-right
			);
			var vicinity:Vector.<TileState> = new Vector.<TileState>();
			var temp:TileState;
			for (var i:int = 0; i<8; ++i) {
				temp = getTile( searchPattern[i][0], searchPattern[i][1] );
				if (temp != null) {
					vicinity.push(temp);
				}
			}
			return vicinity;
		}
		
		// destructor
		
		public function dispose():void 
		{
			for (var y:int=0; y<_height; ++y) {
				for (var x:int=0; x<_width; ++x) {
					_map[y][x] = null;
				}
				_map[y] = null;
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
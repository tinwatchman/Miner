package net.jonstout.miner.model
{
	/**
	 * Contains all necessary state information relating to a single tile
	 * in the grid.
	 */
	public class TileState
	{
		public var index:int;
		public var mapX:int;
		public var mapY:int;
		public var isBomb:Boolean=false;
		public var bombCount:int=0;
		public var isRevealed:Boolean=false;
		public var isMarked:Boolean=false;
		public var isChanged:Boolean=false;
		
		public function TileState()
		{
		}
	}
}
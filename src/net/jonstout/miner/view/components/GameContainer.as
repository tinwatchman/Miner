package net.jonstout.miner.view.components
{
	import feathers.controls.ScrollContainer;
	
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.utils.Color;
	
	public class GameContainer extends ScrollContainer
	{
		public static const BOMB:String = "GameContainer_BOMB";
		public static const TILE_REVEAL:String = "GameContainer_TILE_REVEAL";
		public static const REFRESH_COMPLETE:String = "GameContainer_REFRESH_COMPLETE";
		
		private static const CONTENT_PADDING:int = 50;
		private static const BACKGROUND_COLOR:uint = Color.WHITE;
		
		private var tiles:Vector.<Tile>;
		private var background:QuadBatch;
		
		private var contentWidth:Number;
		private var contentHeight:Number;
		private var isRefreshed:Boolean=false;
		
		public function GameContainer()
		{
			super();
			tiles = new Vector.<Tile>();
			this.verticalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
			this.horizontalScrollPolicy = ScrollContainer.SCROLL_POLICY_ON;
		}
		
		// COMPONENT FUNCTIONS
		
		override protected function initialize():void {
			super.initialize();
			if (!background) {
				background = new QuadBatch();
				addChild(background);
			}
		}
		
		override protected function draw():void {
			super.draw();
			if (background) {
				background.reset();
				// draw background
				background.addQuad(new Quad(Math.max(this.width, contentWidth), Math.max(this.height, contentHeight), BACKGROUND_COLOR));
			}
			if (isRefreshed) {
				isRefreshed = false;
				dispatchEventWith(REFRESH_COMPLETE);
			}
		}
		
		// PUBLIC FUNCTIONS - INVOKED BY PARENT
		
		public function setGameArea(mapX:int, mapY:int):void {
			contentWidth = (mapX*Tile.TILE_WIDTH)+(CONTENT_PADDING*2);
			contentHeight = (mapY*Tile.TILE_HEIGHT)+(CONTENT_PADDING*2);
		}
				
		public function addTile(tile:Tile):void {
			tile.owner = this;
			tiles.push(tile);
			tile.x = CONTENT_PADDING + (tile.state.mapX * Tile.TILE_WIDTH);
			tile.y = CONTENT_PADDING + (tile.state.mapY * Tile.TILE_HEIGHT);
			addChild(tile);
		}
		
		public function refresh():void {
			isRefreshed = true;
			for (var i:int=0; i<tiles.length; ++i) {
				if (tiles[i].state.isChanged) {
					tiles[i].state.isChanged=false;
					tiles[i].invalidate();
				}
			}
			invalidate();
		}
				
		public function gameOver():void {
			var len:int = tiles.length;
			for (var i:int=0; i<len; ++i) {
				tiles[i].gameOver();
			}
		}
		
		public function clear():void {
			for (var i:int=0; i<tiles.length; ++i) {
				tiles[i].dispose();
				tiles[i] = null;
			}
			tiles = null;
			contentWidth = -1;
			contentHeight = -1;
		}
		
		// PUBLIC FUNCTIONS - INVOKED BY TILES/CHILDREN
		
		public function onTileReveal(tile:Tile):void {
			if (tile.state.isBomb) {
				tile.explode();
				dispatchEventWith(BOMB, false, tile.state);
			} else {
				dispatchEventWith(TILE_REVEAL, false, tile.state);
			}
		}
		
		public function setSelection(selectedTile:Tile):void {
			for (var i:int = 0; i<tiles.length; ++i) {
				tiles[i].checkSelection(selectedTile);
			}
		}
	}
}
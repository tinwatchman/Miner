package net.jonstout.miner.view
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.controls.PanelScreen;
	
	import net.jonstout.miner.data.Config;
	import net.jonstout.miner.view.components.GameContainer;
	import net.jonstout.miner.view.components.Tile;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class GameView extends PanelScreen
	{
		public static const BOMB:String = "GameView_BOMB";
		public static const TILE_REVEAL:String = "GameView_TILE_REVEAL";
		public static const REFRESH_COMPLETE:String = "GameView_REFRESH_COMPLETE";
		public static const BACK:String = "GameView_BACK";
		
		private var container:GameContainer;
		private var backButton:Button;
		private var bombsLeftLabel:Label;
		private var bombsLeftField:Label;
		private var bombsTotalLabel:Label;
		private var bombsTotalField:Label;
		
		private var bombsLeft:int=-1;
		private var totalBombs:int=-1;
		private var isBombsLeftDirty:Boolean=false;
		private var isTotalBombsDirty:Boolean=false;
		
		private static const PADDING:int = 20;
		private static const LABELS_BOTTOM_PADDING:int = 0;
		private static const FIELDS_BOTTOM_PADDING:int = 20;
		private static const CENTER_GAP:int = 20;
		
		public function GameView()
		{
			super();
			// set up header
			this.headerProperties.title = Config.GAME_TITLE;
			backButton = new Button();
			backButton.label = Config.getBackButtonLabel();
			backButton.addEventListener(Event.TRIGGERED, onBackButton);
			backButton.nameList.add( Button.ALTERNATE_NAME_BACK_BUTTON );
			this.headerProperties.leftItems = new Vector.<DisplayObject>();
			this.headerProperties.leftItems.push(backButton);
			this.backButtonHandler = onBack;
			
			// turn off scrollers
			this.horizontalScrollPolicy = SCROLL_POLICY_OFF;
			this.verticalScrollPolicy = SCROLL_POLICY_OFF;
		}
		
		public function setGameArea(mapX:int, mapY:int):void {
			if (container) {
				container.setGameArea(mapX, mapY);
			}
		}
		
		public function setBombsLeft(value:int):void {
			if (value != bombsLeft) {
				bombsLeft = value;
				isBombsLeftDirty=true;
				invalidate();
			}
		}
		
		public function setTotalBombs(value:int):void {
			if (value != totalBombs) {
				totalBombs = value;
				isTotalBombsDirty=true;
				invalidate();
			}
		}
		
		public function addTile(tile:Tile):void {
			if (container) {
				container.addTile(tile);
			}
		}
		
		public function refreshMap():void {
			if (container) {
				container.addEventListener(GameContainer.REFRESH_COMPLETE, onRefreshComplete);
				container.refresh();
			}
		}
		
		public function gameOver():void {
			container.gameOver();
		}
		
		public function clearMap():void {
			container.clear();
		}
		
		override protected function initialize():void {
			super.initialize();
			if (!container) {
				container = new GameContainer();
				container.addEventListener(GameContainer.BOMB, onBomb);
				container.addEventListener(GameContainer.TILE_REVEAL, onTileReveal);
				addChild(container);
			}
			// bombs left display
			if (!bombsLeftLabel) {
				bombsLeftLabel = new Label();
				bombsLeftLabel.text = Config.BOMBS_LEFT;
				bombsLeftLabel.name = "rightAlign";
				addChild(bombsLeftLabel);
			}
			if (!bombsLeftField) {
				bombsLeftField = new Label();
				bombsLeftField.text = " ";
				bombsLeftField.name = "header,rightAlign";
				addChild(bombsLeftField);
			}
			// total bombs display
			if (!bombsTotalLabel) {
				bombsTotalLabel = new Label();
				bombsTotalLabel.text = Config.BOMBS_TOTAL;
				addChild(bombsTotalLabel);
			}
			if (!bombsTotalField) {
				bombsTotalField = new Label();
				bombsTotalField.text = " ";
				bombsTotalField.name = "header";
				addChild(bombsTotalField);
			}
		}
		
		override protected function draw():void {
			super.draw();
			if (bombsLeftLabel && bombsLeftField && bombsTotalLabel && bombsTotalField && container) {
				// BOMBS LEFT DISPLAY
				bombsLeftLabel.x = (stage.stageWidth*0.5) - bombsLeftLabel.width - CENTER_GAP;
				bombsLeftLabel.y = PADDING;
				bombsLeftLabel.maxWidth = (stage.stageWidth*0.5) - PADDING - CENTER_GAP;
				
				if (isBombsLeftDirty) {
					isBombsLeftDirty=false;
					bombsLeftField.text = String(bombsLeft);
					bombsLeftField.validate();
				}
				bombsLeftField.x = (stage.stageWidth*0.5) - bombsLeftField.width - CENTER_GAP;
				bombsLeftField.y = PADDING + bombsLeftLabel.height + LABELS_BOTTOM_PADDING;
				bombsLeftField.maxWidth = (stage.stageWidth*0.5) - PADDING - CENTER_GAP;
				
				// TOTAL BOMBS DISPLAY
				bombsTotalLabel.x = (stage.stageWidth*0.5) + CENTER_GAP;
				bombsTotalLabel.y = PADDING;
				bombsTotalLabel.maxWidth = (stage.stageWidth*0.5) - PADDING - CENTER_GAP;
				
				if (isTotalBombsDirty) {
					isTotalBombsDirty=false;
					bombsTotalField.text = String(totalBombs);
					bombsTotalField.validate();
				}
				bombsTotalField.x = (stage.stageWidth*0.5) + CENTER_GAP;
				bombsTotalField.y = PADDING + bombsTotalLabel.height + LABELS_BOTTOM_PADDING;
				bombsTotalField.maxWidth = (stage.stageWidth*0.5) - PADDING - CENTER_GAP;
				
				// GAME CONTAINER
				container.x = PADDING;
				container.y = PADDING + bombsLeftLabel.height + LABELS_BOTTOM_PADDING + bombsLeftField.height + FIELDS_BOTTOM_PADDING;
				container.width = stage.stageWidth - (PADDING*2);
				container.height = stage.stageHeight - header.height - bombsLeftLabel.height - LABELS_BOTTOM_PADDING - bombsLeftField.height - FIELDS_BOTTOM_PADDING - (PADDING*2);
			}
		}
		
		private function onBomb(event:Event):void {
			dispatchEventWith(BOMB, false, event.data);
		}
		
		private function onTileReveal(event:Event):void {
			dispatchEventWith(TILE_REVEAL, false, event.data);
		}
		
		private function onRefreshComplete(event:Event):void {
			trace("GameContainer Refresh Complete");
			container.removeEventListener(GameContainer.REFRESH_COMPLETE, onRefreshComplete);
			dispatchEventWith(REFRESH_COMPLETE);
		}
		
		private function onBack():void {
			dispatchEventWith(BACK);
		}
		
		private function onBackButton(event:Event):void {
			dispatchEventWith(BACK);
		}
	}
}
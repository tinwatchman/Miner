package net.jonstout.miner.view
{
	import net.jonstout.miner.data.AlertRequest;
	import net.jonstout.miner.data.Config;
	import net.jonstout.miner.data.NotificationName;
	import net.jonstout.miner.model.GameState;
	import net.jonstout.miner.model.TileState;
	import net.jonstout.miner.view.components.Tile;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.events.Event;

	/**
	 * Mediator that manages the Game View. Contains most of the business logic
	 * related to the game.
	 */
	public class GameMediator extends BaseMediator
	{
		public static const NAME:String = "GameMediator";
		
		private var state:GameState;
		private var frameCount:int;
		private var isAlertShown:Boolean=false;
		
		public function GameMediator()
		{
			super(NAME, null);
			addInterest(NotificationName.GAME_VIEW_UPDATED, onGameViewUpdate);
			addInterest(NotificationName.DISPLAY_GAME, onDisplayGame);
		}
		
		private function get view():GameView {
			return getViewComponent() as GameView;
		}
		
		// View Handling Boilerplate
		
		private function onGameViewUpdate(note:INotification):void {
			if (note.getBody() is GameView) {
				attachView(note.getBody());
			} else if (view && note.getBody() == null) {
				detachView();
				setViewComponent(null);
			}
		}
		
		override protected function attachView(viewComponent:Object):void {
			super.attachView(viewComponent);
			view.addEventListener(GameView.BOMB, onBomb);
			view.addEventListener(GameView.TILE_REVEAL, onTileReveal);
			view.addEventListener(GameView.BACK, onBack);
		}
		
		override protected function detachView():void {
			view.removeEventListener(GameView.BOMB, onBomb);
			view.removeEventListener(GameView.TILE_REVEAL, onTileReveal);
			view.removeEventListener(GameView.BACK, onBack);
		}
		
		// Display / Render Game Area
		
		private function onDisplayGame(note:INotification):void {
			state = note.getBody() as GameState;
			// even though we have the state now, let's wait a few frames
			// and let Flash catch up with garbage collection
			frameCount=0;
			view.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void {
			frameCount++;
			if (frameCount >= Config.GAME_RENDER_FRAME_DELAY) {
				view.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				renderGame();
			}
		}
		
		private function renderGame():void {
			view.setGameArea(state.width, state.height);
			view.setBombsLeft(state.numBombs);
			view.setTotalBombs(state.totalBombs);
			var tile:Tile;
			var tileState:TileState;
			for (var y:int=0; y<state.height; ++y) {
				for (var x:int=0; x<state.height; ++x) {
					tileState = state.getTile(x, y);
					if (tileState) {
						tile = new Tile(tileState);
						view.addTile(tile);
					}
				}
			}
			view.addEventListener(GameView.REFRESH_COMPLETE, onFirstRefreshComplete);
			view.refreshMap();
		}
		
		/**
		 * hide the loading message when we've refreshed the game screen 
		 */
		private function onFirstRefreshComplete(event:Event):void {
			// remove the event listener - we're only interested in this function
			// being triggered by the first refresh.
			view.removeEventListener(GameView.REFRESH_COMPLETE, onFirstRefreshComplete);
			sendNotification(NotificationName.HIDE_ALERT);
		}
		
		// Event Listeners
		
		/**
		 * Handles when user hits the back button / presses the device's back button
		 */
		private function onBack(event:Event):void {
			if (isAlertShown) {
				// if back button on Android is pressed while an alert is being shown, exit the alert
				sendNotification(NotificationName.HIDE_ALERT);
			} else if (state.isGameOver) {
				// if the game is over, let the user leave without needing to confirm
				closeGame();
			} else {
				// show user a confirm alert to make sure they want to leave the game
				var request:AlertRequest = new AlertRequest(Config.QUIT_GAME_MESSAGE);
				request.setButtons(Config.QUIT_CONFIRM_LABEL, Config.QUIT_CANCEL_LABEL);
				request.setResponder(this, onQuitConfirmed, onAlertClosed);
				isAlertShown = true;
				sendNotification(NotificationName.CONFIRM, request);
			}
		}
		
		/**
		 * Handles the player clicking on a bomb
		 */
		private function onBomb(event:Event):void {
			var request:AlertRequest = new AlertRequest( Config.getLoseMessage() );
			request.okText = Config.getLoseButtonLabel();
			request.setResponder(this, onAlertClosed);
			state.isGameOver = true;
			view.gameOver();
			isAlertShown = true;
			sendNotification(NotificationName.ALERT, request);
		}
				
		/**
		 * Runs every time the game state changes. Every time a tile is revealed,
		 * we need to check to see if (a) it cascades and reveals other tiles, 
		 * (b) if any bombs have been isolated by the player and need to be
		 * marked, and (c) if the player has won.
		 */
		private function onTileReveal(event:Event):void {
			var isRefreshNecessary:Boolean = false;
			var vicinity:Vector.<TileState>;
			var i:int;
			var n:int;
			// check for cascades
			if ( (event.data as TileState).bombCount == 0 ) {
				var zeroList:Vector.<TileState> = new Vector.<TileState>();
				zeroList.push( (event.data as TileState) );
				for (i=0; i<zeroList.length; ++i) {
					vicinity = state.getTileVicinity( zeroList[i].mapX, zeroList[i].mapY );
					for (n=0; n<vicinity.length; ++n) {
						// if tile's bomb count is zero and it is not revealed
						if ( vicinity[n].bombCount == 0 && !vicinity[n].isRevealed ) {
							vicinity[n].isRevealed = true;
							vicinity[n].isChanged = true;
							zeroList.push( vicinity[n] );
						}
					}
				}
				if (zeroList.length > 1) {
					isRefreshNecessary = true;
				}
			}
			// check for marked bombs (bomb tiles that haven't been clicked on and are surrounded by revealed tiles).
			var revealedCount:int;
			var nonBombTileCount:int;
			for (i=0; i<state.bombTiles.length; ++i) {
				if (!state.bombTiles[i].isMarked) {
					revealedCount = 0;
					nonBombTileCount = 0;
					vicinity = state.getTileVicinity( state.bombTiles[i].mapX, state.bombTiles[i].mapY );
					for (n=0; n<vicinity.length; ++n) {
						if (!vicinity[n].isBomb) {
							nonBombTileCount++;
						}
						if (vicinity[n].isRevealed && !vicinity[n].isBomb) {
							revealedCount++;
						}
					}
					if (revealedCount == nonBombTileCount) {
						// if all non-bomb tiles touching this bomb are revealed, show this bomb as marked to the player
						state.bombTiles[i].isMarked = true;
						state.bombTiles[i].isChanged = true;
						// decrement number of bombs still unknown to the player
						state.numBombs--;
						isRefreshNecessary = true;
					}
				}
			}
			// refresh if necessary
			if (isRefreshNecessary) {
				view.setBombsLeft(state.numBombs);
				view.refreshMap();
			}
			// check for win condition
			if (state.numBombs == 0) {
				gameWon();
			}
		}
		
		// Confirm and Alert Responder functions
		
		private function onQuitConfirmed():void {
			isAlertShown = false;
			closeGame();
		}
		
		private function onAlertClosed():void {
			isAlertShown = false;
		}
		
		// Private Functions
		
		private function gameWon():void {
			// show all tiles
			state.isGameOver = true;
			view.gameOver();
			// alert player they've won
			isAlertShown = true;
			var request:AlertRequest = new AlertRequest( Config.getWinMessage() );
			request.okText = Config.WIN_BUTTON_LABEL;
			request.setResponder(this, onAlertClosed);
			sendNotification(NotificationName.ALERT, request);
		}
		
		private function closeGame():void {
			state.dispose();
			state = null;
			view.clearMap();
			sendNotification(NotificationName.SHOW_START_VIEW);
		}
	}
}
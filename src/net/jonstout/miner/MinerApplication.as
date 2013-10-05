package net.jonstout.miner
{
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	
	import net.jonstout.miner.view.GameView;
	import net.jonstout.miner.view.StartView;
	import net.jonstout.miner.view.theme.MinimalMobileTheme;
	import net.jonstout.miner.view.theme.Theme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MinerApplication extends Sprite
	{
		private var theme:Theme;
		private var navigator:ScreenNavigator;
		
		public static const NOTIFY_START_MEDIATOR:String = "notifyStartMediator";
		public static const NOTIFY_GAME_MEDIATOR:String = "notifyGameMediator";
		
		private static const START_VIEW_ID:String = "startView";
		private static const GAME_VIEW_ID:String = "gameView";
		
		public function MinerApplication()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.addEventListener(Event.RESIZE, onResize);
			theme = new MinimalMobileTheme();
			navigator = new ScreenNavigator();
			addChild(navigator);
			MinerFacade.getInstance().start(this);
		}
		
		public function showStartView():void {
			if (navigator.activeScreenID == GAME_VIEW_ID) {
				dispatchEvent(new Event(NOTIFY_GAME_MEDIATOR, false, null));
				navigator.clearScreen();
			}
			if (!navigator.hasScreen(START_VIEW_ID)) {
				navigator.addScreen(START_VIEW_ID, new ScreenNavigatorItem(StartView));
			}
			navigator.showScreen(START_VIEW_ID);
			dispatchEvent(new Event(NOTIFY_START_MEDIATOR, false, navigator.activeScreen));
		}
		
		public function showGameView():void {
			if (navigator.activeScreenID == START_VIEW_ID) {
				dispatchEvent(new Event(NOTIFY_START_MEDIATOR, false, null));
				navigator.clearScreen();
			}
			if (!navigator.hasScreen(GAME_VIEW_ID)) {
				navigator.addScreen(GAME_VIEW_ID, new ScreenNavigatorItem(GameView));
			}
			navigator.showScreen(GAME_VIEW_ID);
			dispatchEvent(new Event(NOTIFY_GAME_MEDIATOR, false, navigator.activeScreen));
		}
				
		private function onResize(event:Event):void {
			this.width = stage.stageWidth;
			this.height = stage.stageHeight;
		}
	}
}
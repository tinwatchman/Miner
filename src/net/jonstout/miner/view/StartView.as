package net.jonstout.miner.view
{
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.data.ListCollection;
	
	import net.jonstout.miner.data.Config;
	
	import starling.events.Event;
	
	public class StartView extends PanelScreen
	{
		public static const OPTION_SELECTED:String = "StartView_OPTION_SELECTED";
		
		private var title:Label;
		private var subtitle:Label;
		private var options:List;
		
		private static const PADDING:int = 20;
		private static const GAP_TITLE_SUBTITLE:int = 20;
		private static const GAP_SUBTITLE_OPTIONS:int = 30;

		public function StartView()
		{
			super();
			this.headerProperties.title = Config.GAME_TITLE;
		}
		
		override protected function initialize():void {
			super.initialize();
			if (!title) {
				title = new Label();
				title.text = Config.GAME_TITLE;
				title.name = "gameTitle";
				title.maxWidth = stage.stageWidth-(PADDING*2);
				addChild(title);
			}
			if (!subtitle) {
				subtitle = new Label();
				subtitle.text = Config.getGameSelect();
				subtitle.maxWidth = stage.stageWidth-(PADDING*2);
				addChild(subtitle);
			}
			if (!options) {
				options = new List();
				options.dataProvider = new ListCollection(Config.GAME_DIFFICULTY_OPTIONS);
				options.addEventListener(Event.CHANGE, onSelection);
				addChild(options);
			}
		}
		
		override protected function draw():void {
			super.draw();
			if (title && subtitle && options) {
				title.x = PADDING;
				title.y = PADDING;
				title.width = this.width-(PADDING*2);
				title.validate();
				
				subtitle.x = PADDING;
				subtitle.y = PADDING + title.height + GAP_TITLE_SUBTITLE;
				subtitle.validate();
				
				options.x = PADDING;
				options.y = PADDING + title.height + GAP_TITLE_SUBTITLE + subtitle.height + GAP_SUBTITLE_OPTIONS;
				options.width = this.width-(PADDING*2);
				//options.height = this.height-(PADDING*2)-title.height-subtitle.height-GAP_TITLE_SUBTITLE-GAP_SUBTITLE_OPTIONS;
				options.invalidate();
			}
		}
		
		private function onSelection(event:Event):void {
			if (options.selectedItem != null) {
				dispatchEvent(new Event(OPTION_SELECTED, false, options.selectedItem.value));
				options.selectedIndex = -1;
			}
		}
	}
}
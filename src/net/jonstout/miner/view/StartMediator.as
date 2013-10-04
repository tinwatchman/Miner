package net.jonstout.miner.view
{
	import net.jonstout.miner.data.AlertRequest;
	import net.jonstout.miner.data.Config;
	import net.jonstout.miner.data.NotificationName;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.events.Event;
	
	public class StartMediator extends BaseMediator
	{
		public static const NAME:String = "StartMediator";
		
		public function StartMediator()
		{
			super(NAME, null);
			addInterest(NotificationName.START_VIEW_UPDATED, onStartViewUpdate);
		}
		
		private function get view():StartView {
			return getViewComponent() as StartView;
		}
		
		// VIEW HANDLING BOILERPLATE
		
		private function onStartViewUpdate(note:INotification):void {
			if (note.getBody() is StartView) {
				attachView(note.getBody());
			} else if (view && note.getBody() == null) {
				detachView();
				setViewComponent(null);
			}
		}
		
		override protected function attachView(viewComponent:Object):void {
			super.attachView(viewComponent);
			view.addEventListener(StartView.OPTION_SELECTED, onOptionSelected);
		}
		
		override protected function detachView():void {
			view.removeEventListener(StartView.OPTION_SELECTED, onOptionSelected);
		}
				
		// EVENT HANDLERS
		
		private function onOptionSelected(event:Event):void {
			// send loading message
			sendNotification( NotificationName.MESSAGE, new AlertRequest(Config.LOADING_MESSAGE) );
			// generate the requested game
			sendNotification( NotificationName.GENERATE_GAME, event.data );
		}
	}
}
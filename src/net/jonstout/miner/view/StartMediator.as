package net.jonstout.miner.view
{
	import net.jonstout.miner.data.AlertRequest;
	import net.jonstout.miner.data.Config;
	import net.jonstout.miner.data.Notification;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.events.Event;
	
	public class StartMediator extends BaseMediator
	{
		public static const NAME:String = "StartMediator";
		
		public function StartMediator()
		{
			super(NAME, null);
			addInterest(Notification.START_VIEW_UPDATED, onStartViewUpdate);
		}
		
		private function get view():StartView {
			return getViewComponent() as StartView;
		}
		
		override protected function attachView(viewComponent:Object):void {
			super.attachView(viewComponent);
			view.addEventListener(StartView.OPTION_SELECTED, onOptionSelected);
		}
		
		override protected function detachView():void {
			view.removeEventListener(StartView.OPTION_SELECTED, onOptionSelected);
		}
		
		private function onStartViewUpdate(note:INotification):void {
			if (note.getBody() is StartView) {
				attachView(note.getBody());
			} else if (view && note.getBody() == null) {
				detachView();
				setViewComponent(null);
			}
		}
		
		private function onOptionSelected(event:Event):void {
			// send loading message
			sendNotification(Notification.MESSAGE, new AlertRequest(Config.LOADING_MESSAGE, true));
			// generate the requested game
			sendNotification(Notification.GENERATE_GAME, event.data);
		}
	}
}
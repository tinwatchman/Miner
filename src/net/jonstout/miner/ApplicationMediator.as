package net.jonstout.miner
{
	import net.jonstout.miner.data.Notification;
	import net.jonstout.miner.view.BaseMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.events.Event;
	
	public class ApplicationMediator extends BaseMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		public function ApplicationMediator(view:MinerApplication)
		{
			super(NAME, view);
			// notification interests
			addInterest(Notification.STARTUP_COMPLETE, onStartupComplete);
			addInterest(Notification.SHOW_GAME_VIEW, onShowGameView);
			addInterest(Notification.SHOW_START_VIEW, onShowStartView);
			// event listeners
			view.addEventListener(MinerApplication.NOTIFY_START_MEDIATOR, onNotifyStartMediator);
			view.addEventListener(MinerApplication.NOTIFY_GAME_MEDIATOR, onNotifyGameMediator);
		}
		
		protected function get view():MinerApplication {
			return this.viewComponent as MinerApplication;
		}
		
		private function onStartupComplete(note:INotification):void {
			view.showStartView();
		}
		
		private function onShowGameView(note:INotification):void {
			view.showGameView();
		}
		
		private function onShowStartView(note:INotification):void {
			view.showStartView();
		}
		
		private function onNotifyStartMediator(event:Event):void {
			sendNotification(Notification.START_VIEW_UPDATED, event.data);
		}
		
		private function onNotifyGameMediator(event:Event):void {
			sendNotification(Notification.GAME_VIEW_UPDATED, event.data);
		}		
	}
}
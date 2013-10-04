package net.jonstout.miner.view
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	/**
	 * Base boilerplate subclass of standard PureMVC Mediator with custom methods
	 * for this project.  
	 */
	public class BaseMediator extends Mediator
	{
		private var interestMap:Object;
		
		public function BaseMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
			interestMap = new Object();
		}
		
		protected function addInterest(name:String, handler:Function):void {
			interestMap[name] = handler;
		}
		
		override public function listNotificationInterests():Array {
			var list:Array = new Array();
			for (var key:String in interestMap) {
				list.push(key);
			}
			return list;
		}
		
		override public function handleNotification(notification:INotification):void {
			if (interestMap[notification.getName()] != null) {
				(interestMap[notification.getName()] as Function).apply(this, [notification]);
			}
		}
		
		protected function attachView(viewComponent:Object):void {
			setViewComponent(viewComponent);
		}
		
		protected function detachView():void {
			// override in subclasses
		}
	}
}
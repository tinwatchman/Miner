package net.jonstout.miner.view
{
	import feathers.core.PopUpManager;
	
	import net.jonstout.miner.data.AlertRequest;
	import net.jonstout.miner.data.NotificationName;
	import net.jonstout.miner.view.alerts.Alert;
	import net.jonstout.miner.view.alerts.Confirm;
	import net.jonstout.miner.view.alerts.Message;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;

	/**
	 * Mediator to handle and manage alert popups.
	 */
	public class AlertMediator extends BaseMediator
	{
		public static const NAME:String = "AlertMediator";
		
		private var request:AlertRequest;
		
		public function AlertMediator()
		{
			super(NAME, null);
			addInterest(NotificationName.MESSAGE, onMessage);
			addInterest(NotificationName.ALERT, onAlert);
			addInterest(NotificationName.CONFIRM, onConfirm);
			addInterest(NotificationName.HIDE_ALERT, onHide);
		}
		
		public function get message():Message {
			return getViewComponent() as Message;
		}
		
		public function get alert():Alert {
			return getViewComponent() as Alert;
		}
		
		public function get confirm():Confirm {
			return getViewComponent() as Confirm;
		}
		
		override public function onRegister():void {
			PopUpManager.overlayFactory = function():DisplayObject {
				var quad:Quad = new Quad(100, 100, 0x000000);
				quad.alpha = 0.5;
				return quad;
			};
		}
		
		// MESSAGE FUNCTIONALITY
		
		private function onMessage(note:INotification):void {
			request = note.getBody() as AlertRequest;
			if (request) {
				request.type = AlertRequest.MESSAGE;
				setViewComponent( new Message(request.text) );
				PopUpManager.addPopUp(message, true, true);
				message.validate();
			}
		}
		
		private function onHide(note:INotification):void {
			if (request != null && request.type == AlertRequest.MESSAGE) {
				PopUpManager.removePopUp(message, true);
				setViewComponent(null);
				request.ok();
				clearRequest();
			} else if (request != null && request.type == AlertRequest.ALERT) {
				closeAlert();
			} else if (request != null && request.type == AlertRequest.CONFIRM) {
				request.cancel();
				closeConfirm();
			}
		}
		
		// ALERT FUNCTIONALITY
		
		private function onAlert(note:INotification):void {
			request = note.getBody() as AlertRequest;
			if (request) {
				request.type = AlertRequest.ALERT;
				setViewComponent( new Alert(request.text, request.okText) );
				alert.addEventListener(Alert.OKAY, onCloseAlert);
				PopUpManager.addPopUp(alert, true, true);
			}
		}
		
		private function onCloseAlert(event:Event):void {
			closeAlert();
		}
		
		private function closeAlert():void {
			alert.removeEventListener(Alert.OKAY, onCloseAlert);
			PopUpManager.removePopUp(alert, true);
			setViewComponent(null);
			request.ok();
			clearRequest();
		}
		
		// CONFIRM FUNCTIONALITY
		
		private function onConfirm(note:INotification):void {
			request = note.getBody() as AlertRequest;
			if (request) {
				request.type = AlertRequest.CONFIRM;
				setViewComponent( new Confirm(request.text, request.okText, request.cancelText) );
				confirm.addEventListener(Confirm.OKAY, onConfirmed);
				confirm.addEventListener(Confirm.CANCEL, onConfirmCanceled);
				PopUpManager.addPopUp(confirm, true, true);
			}
		}
		
		private function onConfirmed(event:Event):void {
			request.ok();
			closeConfirm();
		}
		
		private function onConfirmCanceled(event:Event):void {
			request.cancel();
			closeConfirm();
		}
		
		private function closeConfirm():void {
			confirm.removeEventListener(Confirm.OKAY, onConfirmed);
			confirm.removeEventListener(Confirm.CANCEL, onConfirmCanceled);
			PopUpManager.removePopUp(confirm, true);
			clearRequest();
		}
		
		// OTHER
				
		private function clearRequest():void {
			if (request) {
				request.clear();
				request = null;
			}
		}
	}
}
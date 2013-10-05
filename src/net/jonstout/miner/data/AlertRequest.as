package net.jonstout.miner.data
{
	public class AlertRequest
	{
		private var _type:int=-1;
		private var _text:String;
		private var _isLoadingMessage:Boolean;
		private var _okText:String;
		private var _cancelText:String;
		private var _responder:Object;
		private var _okHandler:Function;
		private var _cancelHandler:Function;
		
		public static const MESSAGE:int = 0;
		public static const ALERT:int = 1;
		public static const CONFIRM:int = 2;
		
		public function AlertRequest(text:String, isLoadingMessage:Boolean=false)
		{
			_text = text;
			_isLoadingMessage = isLoadingMessage;
		}
		
		public function setButtons(okay:String = "OK", cancel:String=null):void {
			_okText = okay;
			_cancelText = cancel;
		}
		
		public function setResponder(responder:Object, okHandler:Function, cancelHandler:Function=null):void {
			_responder = responder;
			_okHandler = okHandler;
			_cancelHandler = cancelHandler;
		}
		
		public function clear():void {
			_type = -1;
			_text = null;
			_isLoadingMessage = false;
			_okText = null;
			_cancelText = null;
			_responder = null;
			_okHandler = null;
			_cancelHandler = null;
		}

		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get isLoadingMessage():Boolean
		{
			return _isLoadingMessage;
		}

		public function get okText():String
		{
			return _okText;
		}
		
		public function set okText(value:String):void
		{
			_okText = value;
		}

		public function get cancelText():String
		{
			return _cancelText;
		}
		
		public function ok():void {
			if (_responder && _okHandler != null) {
				_okHandler.apply(_responder, []);
			}
		}
		
		public function cancel():void {
			if (_responder && _cancelHandler != null) {
				_cancelHandler.apply(_responder, []);
			}
		}
	}
}
package net.jonstout.miner.data
{
	/**
	 * Static class containing configuration options. Available globally.
	 */
	public final class Config
	{
		// set to true to enable certain debugging functionality
		public static var TEST_MODE:Boolean = false;
		
		protected static var EASY_PROPERTIES:Object = { width:9, height:9, bombs:10 };
		protected static var MEDIUM_PROPERTIES:Object = { width:16, height:16, bombs:40 };
		protected static var HARD_PROPERTIES:Object = { width:16, height:30, bombs:99 };
		
		public static const GAME_TITLE:String = "SWEEPER OF MINING";
		protected static var GAME_SELECT:Array = [
				"be selecting misery level:",
				"be selecting difficult time:",
				"be selecting pressure rank:",
				"be selecting misery rank:",
				"be selecting trouble status:",
				"be selecting annoyance struggle:"
		];
		public static var GAME_DIFFICULTY_OPTIONS:Array = [
			{ label:"EAZY", value:EASY_PROPERTIES },
			{ label:"MEDIUM", value:MEDIUM_PROPERTIES },
			{ label:"HARD", value:HARD_PROPERTIES }
		];
		public static const LOADING_MESSAGE:String = "is setting up the bombs...";
		
		public static function getGameSelect():String {
			return GAME_SELECT[ getRandomInt(GAME_SELECT.length) ] as String;
		}
		
		protected static var BACK_BUTTON_LABELS:Array = [
			"esc",
			"del",
			"back",
			"flee",
			"before",
			"spine",
			"rear"
		];
		public static function getBackButtonLabel():String {
			return BACK_BUTTON_LABELS[ getRandomInt(BACK_BUTTON_LABELS.length) ] as String;
		}
		
		public static const GAME_RENDER_FRAME_DELAY:int = 5;
		public static const BOMB_CHARACTER:String = "@";
		public static const BOMBS_LEFT:String = "bombs larboard";
		public static const BOMBS_TOTAL:String = "bombs entire";
		
		protected static const LOSE_MESSAGES:Array = [
			"You find bomb. It does not love you.",
			"Bomb found you. Try again.",
			"You dead. You no get metal.",
			"Bomb has eaten you. Try again.",
			"Bomb is good. You are dead.",
			"You lose. Go collect legs."
		];
		public static function getLoseMessage():String {
			return LOSE_MESSAGES[ getRandomInt(LOSE_BUTTON_LABELS.length) ] as String;
		}
		
		protected static const LOSE_BUTTON_LABELS:Array = [
			"oh",
			"daaaaaamn",
			"i shovel",
			"i like it",
			"i no like"
		];
		public static function getLoseButtonLabel():String {
			return LOSE_BUTTON_LABELS[ getRandomInt(LOSE_BUTTON_LABELS.length) ] as String;
		}
		
		public static const QUIT_GAME_MESSAGE:String = "Are you sure you wish to be leaving mines? Game will be lose constant!";
		public static const QUIT_CONFIRM_LABEL:String = "Affirm";
		public static const QUIT_CANCEL_LABEL:String = "No";
		
		protected static const WIN_MESSAGES:Array = [
			"A winner is you",
			"Victory sugar",
			"Bombs are dead. You not dead.",
			"Enjoy life",
			"You not dead. Enjoy life.",
			"Inspector's mate",
			"Bombs are dead. You love bombs."
		];
		
		public static function getWinMessage():String {
			return WIN_MESSAGES[ getRandomInt(WIN_MESSAGES.length) ] as String;
		}
		
		public static const WIN_BUTTON_LABEL:String = "Yay.";
		
		protected static function getRandomInt(max:int=1):int {
			return Math.floor(Math.random()*max) as int;
		}
	}
}
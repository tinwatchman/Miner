package net.jonstout.miner.view.components
{
	import feathers.controls.Label;
	import feathers.core.FeathersControl;
	
	import net.jonstout.miner.data.Config;
	import net.jonstout.miner.model.TileState;
	
	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Color;
	
	public class Tile extends FeathersControl
	{
		public static const TILE_WIDTH:int = 50;
		public static const TILE_HEIGHT:int = 50;
		public static const BACKGROUND_COLOR:uint = Color.SILVER;
		public static const BORDER_THICKNESS:int = 1;
		public static const BORDER_COLOR:uint = Color.BLACK;
		public static const SELECTED_COLOR:uint = Color.BLUE;
		public static const REVEALED_COLOR:uint = Color.WHITE;
		public static const EXPLODED_COLOR:uint = Color.RED;
		public static const MARKED_COLOR:uint = Color.GREEN;
		
		private var _state:TileState;
		
		public var owner:GameContainer;
		
		private var label:Label;
		private var background:QuadBatch;
		private var _isSelected:Boolean;
		private var isExploded:Boolean;
		
		public function Tile(state:TileState)
		{
			super();
			_state = state;
			isEnabled = true;
			touchable = true;
			addEventListener(TouchEvent.TOUCH, onTouched);
		}
		
		public function get state():TileState
		{
			return _state;
		}
		
		public function get isSelected():Boolean
		{
			return _isSelected;
		}
		
		public function checkSelection(selection:Tile):void {
			if (_isSelected && selection != this) {
				_isSelected = false;
				invalidate();
			}
		}
		
		public function explode():void {
			isExploded = true;
		}
		
		public function gameOver():void {
			isEnabled = false;
			removeEventListener(TouchEvent.TOUCH, onTouched);
			_state.isRevealed = true;
			invalidate();
		}
		
		override public function dispose():void {
			super.dispose();
			removeEventListener(TouchEvent.TOUCH, onTouched);
			removeChild(label);
			label = null;
			removeChild(background);
			background = null;
			_state = null;
			owner = null;
		}
		
		override protected function initialize():void {
			setSizeInternal(TILE_WIDTH, TILE_HEIGHT, false);
			if (!background) {
				background = new QuadBatch();
				background.width = TILE_WIDTH;
				background.height = TILE_HEIGHT;
				addChild(background);
			}
			if (!label) {
				label = new Label();
				if (state.isBomb) {
					label.text = Config.BOMB_CHARACTER;
				} else {
					label.text = String(state.bombCount);
				}
				addChild(label);
				label.validate();
			}
		}
		
		override protected function draw():void {
			super.draw();
			if (label) {
				label.x = (TILE_WIDTH*0.5)-(label.width*0.5);
				label.y = (TILE_HEIGHT*0.5)-(label.height*0.5);
				//label.visible = _state.isRevealed;
			}
			if (background) {
				background.reset();
				var backColor:uint = BACKGROUND_COLOR;
				if (isExploded) {
					backColor = EXPLODED_COLOR;
				} else if (_state.isMarked) {
					backColor = MARKED_COLOR;
				} else if (_state.isRevealed) {
					backColor = REVEALED_COLOR;
				} else if (_isSelected) {
					backColor = SELECTED_COLOR;
				}
				background.addQuad(new Quad(TILE_WIDTH, TILE_HEIGHT, backColor));
				var temp:Quad = new Quad(TILE_WIDTH, BORDER_THICKNESS, BORDER_COLOR);
				background.addQuad(temp);
				temp.y = TILE_HEIGHT-BORDER_THICKNESS;
				background.addQuad(temp);
				temp = new Quad(BORDER_THICKNESS, TILE_HEIGHT, BORDER_COLOR);
				background.addQuad(temp);
				temp.x = TILE_WIDTH-BORDER_THICKNESS;
				background.addQuad(temp);
			}
		}
		
		private function onTouched(event:TouchEvent):void {
			if (isEnabled) {
				var touches:Vector.<Touch> = event.getTouches(this);
				var endTouch:Touch = findTouch(touches, TouchPhase.ENDED);
				if (touches.length == 0 && _isSelected) {
					_isSelected = false;
					invalidate();
				} else if (endTouch && !_isSelected) {
					_isSelected = true;
					owner.setSelection(this);
					invalidate();
				} else if (endTouch && _isSelected) {
					_state.isRevealed = true;
					owner.onTileReveal(this);
					removeEventListener(TouchEvent.TOUCH, onTouched);
					invalidate();
				}
			}
		}
		
		private function findTouch(touches:Vector.<Touch>, phase:String):Touch {
			var len:int = touches.length;
			for (var i:int=0; i<len; ++i) {
				if (touches[i].phase == phase) {
					return touches[i];
				}
			}
			return null;
		}
	}
}
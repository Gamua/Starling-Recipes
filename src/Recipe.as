// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package
{
    import starling.animation.Juggler;
    import starling.display.Sprite;
    import starling.utils.AssetManager;

    public class Recipe extends Sprite
    {
        private var _description:String;
        private var _juggler:Juggler;

        public function Recipe(description:String)
        {
            _description = description;
            _juggler = new Juggler();
        }

        public function advanceTime(passedTime:Number):void
        {
            _juggler.advanceTime(passedTime);
        }

        public function get description():String { return _description; }

        protected function get juggler():Juggler { return _juggler; }
        protected function get assets():AssetManager { return Root.assets; }
    }
}

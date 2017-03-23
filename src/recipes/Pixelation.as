// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package recipes
{
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.BitmapFont;
    import starling.text.TextField;

    public class Pixelation extends Recipe
    {
        private var _textField:TextField;

        private static const TEXT_A:String = "Click here for a cool trick!";
        private static const TEXT_B:String = "... and again to start over.";

        public function Pixelation()
        {
            super("The FragmentFilter class can be used for a simple transition effect.");
            setup();
        }

        private function setup():void
        {
            _textField = new TextField(300, 300, TEXT_A);
            _textField.format.setTo("bradybunch", BitmapFont.NATIVE_SIZE, 0xffffff);
            _textField.format.leading = -15;
            _textField.alignPivot();
            _textField.useHandCursor = true;
            _textField.addEventListener(TouchEvent.TOUCH, onTouch);
            addChild(_textField);
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(_textField, TouchPhase.ENDED);
            if (touch)
            {
                var filter:PixelationFilter = new PixelationFilter();
                _textField.filter = filter;
                _textField.touchable = false;

                juggler.tween(filter, 0.5, {
                    level: 6.5,
                    reverse: true,
                    repeatCount: 2,
                    onComplete: onTransitionComplete,
                    onRepeat: changeText
                });
            }
        }

        private function changeText():void
        {
            if (_textField.text == TEXT_A) _textField.text = TEXT_B;
            else                           _textField.text = TEXT_A;
        }

        private function onTransitionComplete():void
        {
            _textField.touchable = true;
            _textField.filter.dispose();
            _textField.filter = null;
        }
    }
}

import starling.filters.FragmentFilter;
import starling.textures.TextureSmoothing;

class PixelationFilter extends FragmentFilter
{
    public function PixelationFilter()
    {
        textureSmoothing = TextureSmoothing.NONE;
    }

    public function get level():int
    {
        return Math.log(1 / resolution) / Math.log(2);
    }

    public function set level(value:int):void
    {
        resolution = 1 / (Math.pow(2, value));
    }
}

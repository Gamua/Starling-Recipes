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
    import flash.ui.Keyboard;

    import starling.animation.Transitions;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    import starling.filters.GlowFilter;
    import starling.text.TextField;

    import utils.Helpers;

    public class Outlines extends Recipe
    {
        private var _glowFilter:GlowFilter;

        public function Outlines()
        {
            super("The GlowFilter can be used to create outlines.");
            setup();
            alignPivot();

            Helpers.addStageEventListener(this, KeyboardEvent.KEY_DOWN, onKeyDown);
        }

        private function onKeyDown(event:Event, keyCode:uint):void
        {
            juggler.removeTweens(_glowFilter);

            if      (keyCode == Keyboard.Q) _glowFilter.alpha += 5;
            else if (keyCode == Keyboard.A) _glowFilter.alpha -= 5;
            else if (keyCode == Keyboard.W) _glowFilter.blur += 0.1;
            else if (keyCode == Keyboard.S) _glowFilter.blur -= 0.1;
        }

        private function setup():void
        {
            _glowFilter = new GlowFilter(0x0, 50, 0.5, 1);

            var text:String = "This is a standard TrueType font with an outline.";
            var textField:TextField = new TextField(250, 200, text);
            textField.format.setTo("Ubuntu Medium", 32, 0xffffff);
            textField.filter = _glowFilter;
            addChild(textField);

            juggler.tween(textField.filter, 1, {
                blur: 1.0,
                transition: Transitions.EASE_IN,
                reverse: true,
                repeatCount: 0});
        }
    }
}

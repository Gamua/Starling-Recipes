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
    import starling.filters.FragmentFilter;
    import starling.text.BitmapFont;
    import starling.text.TextField;

    public class BlendMode_LAYER extends Recipe
    {
        public function BlendMode_LAYER()
        {
            super("Recreating BlendMode.LAYER with the FragmentFilter.");
            setup();
        }

        private function setup():void
        {
            var text:String = "Upper Line\nMiddle Line\nLower Line";
            text = "Nobody\ncalls me\nchicken!";

            var textFieldA:TextField = new TextField(300, 300, text);
            textFieldA.format.setTo("bradybunch", BitmapFont.NATIVE_SIZE, 0xffffff);
            textFieldA.format.leading = -50;
            textFieldA.alignPivot();
            textFieldA.y = -75;
            addChild(textFieldA);

            var textFieldB:TextField = new TextField(300, 300, text);
            textFieldB.format.copyFrom(textFieldA.format);
            textFieldB.alignPivot();
            textFieldB.y = -textFieldA.y;
            textFieldB.filter = new FragmentFilter();
            addChild(textFieldB);

            juggler.tween(textFieldA, 3, { alpha: 0, reverse: true, repeatCount: 0 });
            juggler.tween(textFieldB, 3, { alpha: 0, reverse: true, repeatCount: 0 });
        }
    }
}

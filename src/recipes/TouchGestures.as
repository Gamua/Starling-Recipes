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
    import starling.display.Image;

    import utils.TouchSheet;

    public class TouchGestures extends Recipe
    {
        public function TouchGestures()
        {
            super("Multitouch gestures can be detected via standard TouchEvents.");
            setup();
        }

        private function setup():void
        {
            var image:Image = new Image(assets.getTexture("touch-sheet"));
            var sheet:TouchSheet = new TouchSheet();

            image.alignPivot();
            sheet.addChild(image);
            addChild(sheet);
        }
    }
}

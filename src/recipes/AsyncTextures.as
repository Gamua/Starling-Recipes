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
    import flash.display.Bitmap;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import flash.system.ImageDecodingPolicy;
    import flash.system.LoaderContext;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.events.Event;
    import starling.textures.Texture;

    public class AsyncTextures extends Recipe
    {
        private var _progress:Image;
        private var _progressAnim:uint;

        public function AsyncTextures()
        {
            super("To minimize gameplay hiccups, textures can be loaded asynchronously.");

            addEventListener(Event.ADDED_TO_STAGE, setup);
            addEventListener(Event.REMOVED_FROM_STAGE, shutdown);
        }

        private function setup():void
        {
            _progress = new Image(assets.getTexture("progress-indicator"));
            _progress.alignPivot();
            addChild(_progress);

            _progressAnim = juggler.repeatCall(
                function():void { _progress.rotation += Math.PI / 6.0; }, 0.15);

            loadRandomBitmap();
            juggler.repeatCall(loadRandomBitmap, 1.0);
        }

        private function shutdown():void
        {
            var imagesToRemove:Array = [];

            for (var i:int=0; i<numChildren; ++i)
            {
                var image:Image = getChildAt(i) as Image;
                if (image) imagesToRemove.push(image);
            }

            for each (image in imagesToRemove)
                destroyImage(image);
        }

        private function addAnimatedImage(texture:Texture):void
        {
            if (_progress.alpha == 1.0)
            {
                juggler.tween(_progress, 1.0, {
                    alpha: 0,
                    onComplete: function():void
                        {
                            juggler.removeByID(_progressAnim);
                            _progressAnim = 0;
                            _progress.removeFromParent();
                        }
                });
            }

            if (stage == null) return;

            var image:Image = new Image(texture);
            image.alignPivot();
            image.rotation = Math.random() - 0.5;
            image.x = -stage.stageWidth / 2 - image.width / 2;
            image.y = (Math.random() - 0.5) * stage.stageHeight * 0.5;
            image.scale = 0.3 + Math.random() * 0.2;
            addChild(image);

            juggler.tween(image, 2 + Math.random() * 4, {
                x: stage.stageWidth / 2 + image.width / 2,
                y: image.y + Math.random() * 100 - 50,
                rotation: -image.rotation,
                onComplete: destroyImage,
                onCompleteArgs: [image]
            });
        }

        private static function destroyImage(image:Image):void
        {
            image.removeFromParent(true);
            image.texture.dispose();
        }

        private function loadRandomBitmap():void
        {
            var context:LoaderContext = new LoaderContext();
            context.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;

            var scale:Number = Starling.contentScaleFactor;
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
            loader.load(new URLRequest(getRandomImageUrl(scale)), context);

            function onComplete(event:Object):void
            {
                Texture.fromBitmap(event.target.content as Bitmap,
                    false, false, scale, "bgra",
                    false, addAnimatedImage);
            }
        }

//        private var _assets:AssetManager;
//
//        private function loadRandomBitmapAM():void
//        {
//            var scale:Number = Starling.contentScaleFactor;
//            var name:String = getTimer().toString();
//
//            if (_assets == null) _assets = new AssetManager(scale);
//
//            _assets.enqueueWithName(getRandomImageUrl(scale));
//            _assets.loadQueue(function(ratio:Number):void
//            {
//                if (ratio == 1.0)
//                {
//                    addAnimatedImage(_assets.getTexture(name));
//                }
//            });
//        }

        private function getRandomImageUrl(scale:Number):String
        {
            return "http://lorempixel.com/" + int(400 * scale) + "/" + int(400 * scale) + "/";
        }
    }
}

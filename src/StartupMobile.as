package
{
    import flash.desktop.NativeApplication;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.system.System;

    import starling.core.Starling;
    import starling.events.Event;
    import starling.utils.AssetManager;
    import starling.utils.StringUtil;
    import starling.utils.SystemUtil;

    import utils.ScreenSetup;

    [SWF(width="320", height="480", frameRate="60", backgroundColor="#ffffff")]
    public class StartupMobile extends Sprite
    {
        [Embed(source="../assets/fonts/Ubuntu-C.ttf", embedAsCFF="false", fontFamily="Ubuntu Condensed")]
        private static const UbuntuCondensed:Class;

        [Embed(source="../assets/fonts/Ubuntu-M.ttf", embedAsCFF="false", fontFamily="Ubuntu Medium")]
        private static const UbuntuMedium:Class;

        private var _starling:Starling;

        public function StartupMobile()
        {
            Starling.multitouchEnabled = true;

            var screen:ScreenSetup = new ScreenSetup(
                stage.fullScreenWidth, stage.fullScreenHeight, [1, 2, 3]);

            _starling = new Starling(Root, stage, screen.viewPort);
            _starling.stage.stageWidth = screen.stageWidth;
            _starling.stage.stageHeight = screen.stageHeight;
            _starling.skipUnchangedFrames = true;
            _starling.simulateMultitouch = true;
            _starling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
            {
                loadAssets(screen.assetScale, startGame);
            });
            _starling.start();

            // When the game becomes inactive, we pause Starling; otherwise, the enter frame event
            // would report a very long 'passedTime' when the app is reactivated.

            if (!SystemUtil.isDesktop)
            {
                NativeApplication.nativeApplication.addEventListener(
                    flash.events.Event.ACTIVATE, function (e:*):void { _starling.start(); });
                NativeApplication.nativeApplication.addEventListener(
                    flash.events.Event.DEACTIVATE, function (e:*):void { _starling.stop(true); });
            }
        }

        private function loadAssets(scale:int, onComplete:Function):void
        {
            // Our assets are loaded and managed by the 'AssetManager'. To use that class,
            // we first have to enqueue pointers to all assets we want it to load.

            var assets:AssetManager = new AssetManager(scale);
            var appDir:File = File.applicationDirectory;
            assets.enqueue(
                appDir.resolvePath(StringUtil.format("assets/fonts/{0}x", scale)),
                appDir.resolvePath(StringUtil.format("assets/textures/{0}x", scale))
            );

            // Now, while the AssetManager now contains pointers to all the assets, it actually
            // has not loaded them yet. This happens in the "loadQueue" method; and since this
            // will take a while, we'll update the progress bar accordingly.

            assets.loadQueue(function(ratio:Number):void
            {
                if (ratio == 1)
                {
                    // now would be a good time for a clean-up
                    System.pauseForGCIfCollectionImminent(0);
                    System.gc();

                    onComplete(assets);
                }
            });
        }

        private function startGame(assets:AssetManager):void
        {
            var container:Root = _starling.root as Root;
            container.start(assets);
        }
    }
}

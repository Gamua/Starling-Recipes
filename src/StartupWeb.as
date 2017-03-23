package
{
    import flash.display.Sprite;
    import flash.system.System;

    import starling.core.Starling;
    import starling.events.Event;
    import starling.utils.AssetManager;

    import utils.ScreenSetup;

    [SWF(width="320", height="480", frameRate="60", backgroundColor="#ffffff")]
    public class StartupWeb extends Sprite
    {
        [Embed(source="../assets/fonts/Ubuntu-C.ttf", embedAsCFF="false", fontFamily="Ubuntu Condensed")]
        private static const UbuntuCondensed:Class;

        [Embed(source="../assets/fonts/Ubuntu-M.ttf", embedAsCFF="false", fontFamily="Ubuntu Medium")]
        private static const UbuntuMedium:Class;

        private var _starling:Starling;

        public function StartupWeb()
        {
            Starling.multitouchEnabled = true;

            var screenWidth:int  = stage.stageWidth;
            var screenHeight:int = stage.stageHeight;
            var screen:ScreenSetup = new ScreenSetup(screenWidth, screenHeight, [1, 2, 3]);

            _starling = new Starling(Root, stage, screen.viewPort);
            _starling.stage.stageWidth = screen.stageWidth;
            _starling.stage.stageHeight = screen.stageHeight;
            _starling.skipUnchangedFrames = true;
            _starling.simulateMultitouch = true;
            _starling.addEventListener(Event.ROOT_CREATED, function():void
            {
                loadAssets(screen.assetScale, startGame);
            });
            _starling.start();
        }

        private function loadAssets(scale:int, onComplete:Function):void
        {
            var assets:AssetManager = new AssetManager(scale);
            assets.enqueue(EmbeddedAssets);
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

class EmbeddedAssets
{
    // Texture Atlas

    [Embed(source="../assets/textures/1x/atlas.xml", mimeType="application/octet-stream")]
    public static const atlas_xml:Class;

    [Embed(source="../assets/textures/1x/atlas.png")]
    public static const atlas:Class;

    // Bitmap Fonts

    [Embed(source="../assets/fonts/1x/bradybunch.fnt", mimeType="application/octet-stream")]
    public static const bradybunch_fnt:Class;

    [Embed(source = "../assets/fonts/1x/bradybunch.png")]
    public static const bradybunch:Class;
}
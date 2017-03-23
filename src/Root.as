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
    import flash.events.KeyboardEvent;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;

    import recipes.AntiAliasing;
    import recipes.AsyncTextures;
    import recipes.BlendMode_LAYER;
    import recipes.FlippableCards;
    import recipes.Outlines;
    import recipes.Pixelation;
    import recipes.TileMap;
    import recipes.TouchGestures;
    import recipes.WaterReflection;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;
    import starling.text.TextFieldAutoSize;
    import starling.utils.Align;
    import starling.utils.AssetManager;
    import starling.utils.SystemUtil;

    import utils.Helpers;

    public class Root extends Sprite
    {
        private static var sAssets:AssetManager;
        private static var sRecipes:Vector.<Class> = new <Class>[
            WaterReflection, TileMap, FlippableCards, Outlines, BlendMode_LAYER, Pixelation,
            AntiAliasing, TouchGestures
        ];

        private var _currentIndex:int;
        private var _currentRecipe:Recipe;
        private var _sceneContainer:Sprite;
        private var _description:TextField;
        private var _title:TextField;

        public function Root()
        {
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            Helpers.addStageEventListener(this, KeyboardEvent.KEY_UP, onKey);

            // async texture loading only works on mobile right now.
            if (!SystemUtil.isDesktop) sRecipes.push(AsyncTextures);
        }

        public function start(assets:AssetManager):void
        {
            sAssets = assets;
            setupGui();
            setupCurrentRecipe();
        }

        private function onKey(event:Event, keyCode:uint):void
        {
            if (keyCode == Keyboard.S)
                Starling.current.showStats = !Starling.current.showStats;
        }

        private function onEnterFrame(event:Event, passedTime:Number):void
        {
            if (_currentRecipe) _currentRecipe.advanceTime(passedTime);
        }

        private function setupCurrentRecipe():void
        {
            var recipeClass:Class = sRecipes[_currentIndex];
            var recipeClassName:String = recipeClass.toString();
            var title:String = recipeClassName.slice(recipeClassName.indexOf(" ") + 1, -1);

            _currentRecipe = new recipeClass() as Recipe;
            _sceneContainer.removeChildren(0, -1, true);
            _sceneContainer.addChild(_currentRecipe);

            _title.text = title.replace(/_/g, " ");
            _description.text = _currentRecipe.description;
            _description.alignPivot(Align.CENTER, Align.BOTTOM);
        }

        private function setupGui():void
        {
            var font:String = "Ubuntu Condensed";
            var width:Number = stage.stageWidth;
            var height:Number = stage.stageHeight;
            var margin:Number = 20;

            var background:Image = new Image(assets.getTexture("bg-pattern"));
            background.width = width;
            background.height = height;
            background.tileGrid = new Rectangle();
            addChild(background);

            _sceneContainer = new Sprite();
            _sceneContainer.x = int(width  / 2);
            _sceneContainer.y = int(height / 2);
            addChild(_sceneContainer);

            var buttonPrev:Button = new Button(assets.getTexture("left"));
            buttonPrev.x = margin;
            buttonPrev.y = height - buttonPrev.height - margin;
            addChild(buttonPrev);

            var buttonNext:Button = new Button(assets.getTexture("right"));
            buttonNext.x = width - buttonNext.width - margin;
            buttonNext.y = buttonPrev.y;
            addChild(buttonNext);

            var labelWidth:Number = buttonNext.x - buttonPrev.x - buttonPrev.width - 2 * margin;
            _description = new TextField(labelWidth, 100, "");
            _description.format.setTo(font, 14, 0x0, Align.CENTER, Align.BOTTOM);
            _description.autoSize = TextFieldAutoSize.VERTICAL;
            _description.x = width / 2;
            _description.y = height - margin;
            _description.touchable = false;
            addChild(_description);

            _title = new TextField(width - 2 * margin, 100, "");
            _title.format.setTo(font, 20, 0x0, Align.CENTER, Align.TOP);
            _title.autoSize = TextFieldAutoSize.VERTICAL;
            _title.x = _title.y = margin;
            _title.touchable = false;
            addChild(_title);

            buttonPrev.addEventListener(Event.TRIGGERED, moveToPreviousRecipe);
            buttonNext.addEventListener(Event.TRIGGERED, moveToNextRecipe);
        }

        private function moveToPreviousRecipe():void
        {
            if (_currentIndex == 0) _currentIndex = sRecipes.length - 1;
            else                    _currentIndex -= 1;

            setupCurrentRecipe();
        }

        private function moveToNextRecipe():void
        {
            if (_currentIndex == sRecipes.length - 1) _currentIndex = 0;
            else                                      _currentIndex += 1;

            setupCurrentRecipe();
        }

        public static function get assets():AssetManager { return sAssets; }
    }
}

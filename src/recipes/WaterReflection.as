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
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;

    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.filters.DisplacementMapFilter;
    import starling.textures.Texture;
    import starling.utils.MathUtil;

    public class WaterReflection extends Recipe
    {
        private var _displacementMap:Texture;

        public function WaterReflection()
        {
            super("Water reflection via displacement map.");

            setup();
            alignPivot();
        }

        private function setup():void
        {
            var topSprite:Sprite = createSprite();
            addChild(topSprite);

            var bottomSprite:Sprite = createSprite(0xddeeff);
            bottomSprite.scaleY = -1;
            bottomSprite.y = topSprite.height * 2;
            addChild(bottomSprite);

            _displacementMap = createMapTexture(bottomSprite.width, bottomSprite.height);

            var filter:DisplacementMapFilter = new DisplacementMapFilter(
                _displacementMap, BitmapDataChannel.RED, BitmapDataChannel.RED, 15, 15);
            filter.mapRepeat = true;
            filter.padding.setTo();
            juggler.tween(filter, 5, { mapY: _displacementMap.height, repeatCount: 0 });

            bottomSprite.filter = filter;
        }

        override public function dispose():void
        {
            if (_displacementMap) _displacementMap.dispose();
            super.dispose();
        }

        private function createSprite(tint:uint=0xffffff):Sprite
        {
            var sprite:Sprite = new Sprite();
            var sky:Image = new Image(assets.getTexture("dusk-sky"));
            sky.color = tint;
            sprite.addChild(sky);

            var bird:MovieClip = new MovieClip(assets.getTextures("bird-"));
            bird.alignPivot();
            bird.x = sky.width / 2;
            bird.y = sky.height / 2;
            sprite.addChild(bird);
            juggler.add(bird);

            return sprite;
        }

        private function createMapTexture(minWidth:Number, minHeight:Number):Texture
        {
            var width:Number  = MathUtil.getNextPowerOfTwo(minWidth);
            var height:Number = MathUtil.getNextPowerOfTwo(minHeight);
            var perlinData:BitmapData = new BitmapData(width, height, false);
            perlinData.perlinNoise(200, 12, 2, 0, true, true, 0, true);
            return Texture.fromBitmapData(perlinData, false, false, 1, "bgra", true);
        }
    }
}

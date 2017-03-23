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
    import starling.display.MeshBatch;
    import starling.events.Event;
    import starling.textures.Texture;

    public class TileMap extends Recipe
    {
        private const NUM_TILES_X:int = 50;
        private const NUM_TILES_Y:int = 50;

        private var _map:MeshBatch;

        public function TileMap()
        {
            super("These " + NUM_TILES_X * NUM_TILES_Y +
                  " tiles are rendered with the help of the MeshBatch class.");

            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        }

        private function onAddedToStage():void
        {
            _map = new MeshBatch();
            _map.x = stage.stageWidth / -2;
            _map.y = stage.stageHeight / -2;

            var textures:Vector.<Texture> = assets.getTextures("tile_");
            var tileTexture:Texture = textures[0];
            var tileWidth:int = tileTexture.width;
            var tileHeight:int = tileTexture.height;
            var numTiles:int = textures.length;
            var image:Image = new Image(tileTexture);

            for (var i:int=0; i<NUM_TILES_X; ++i)
            {
                for (var j:int=0; j<NUM_TILES_Y; ++j)
                {
                    image.texture = textures[int(Math.random() * numTiles)];
                    image.x = i * tileWidth;
                    image.y = j * tileHeight;
                    _map.addMesh(image);
                }
            }

            addChild(_map);

            juggler.tween(_map, 50, {
                x: -_map.width + stage.stageWidth,
                y: -_map.height + stage.stageHeight,
                repeatCount: 0,
                reverse: true
            });
        }
    }
}

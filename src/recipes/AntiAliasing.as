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
    import starling.display.Canvas;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.filters.FragmentFilter;
    import starling.geom.Polygon;

    public class AntiAliasing extends Recipe
    {
        private var _canvas:Canvas;
        private var _filter:FragmentFilter;

        public function AntiAliasing()
        {
            super("Click on the star to toggle selective anti-aliasing.");
            setup();
        }

        private function setup():void
        {
            var numEdges:int = 16;
            var innerRadius:int = 20;
            var outerRadius:int = 140;
            var polygon:Polygon = new Polygon();
            var angleDelta:Number = 2 * Math.PI / numEdges;
            var innerAngle:Number = 0.0;
            var outerAngle:Number = angleDelta / 2;
            var x:Number, y:Number;

            for (var i:int=0; i<numEdges; ++i)
            {
                x = Math.cos(innerAngle) * innerRadius;
                y = Math.sin(innerAngle) * innerRadius;

                polygon.addVertices(x, y);

                x = Math.cos(outerAngle) * outerRadius;
                y = Math.sin(outerAngle) * outerRadius;

                polygon.addVertices(x, y);

                innerAngle += angleDelta;
                outerAngle += angleDelta;
            }

            _canvas = new Canvas();
            _canvas.useHandCursor = true;
            _canvas.beginFill(0xff0000);
            _canvas.drawPolygon(polygon);
            _canvas.endFill();

            _filter = new FragmentFilter();
            _filter.antiAliasing = 2;

            addChild(_canvas);
            juggler.tween(_canvas, 10, { rotation: 2 * Math.PI, repeatCount: 0 });

            addEventListener(TouchEvent.TOUCH, onTouch);
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
            if (touch)
            {
                if (_canvas.filter) _canvas.filter = null;
                else _canvas.filter = _filter;
            }
        }
    }
}

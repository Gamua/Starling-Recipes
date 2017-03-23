package utils
{
    import flash.geom.Point;

    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.utils.Pool;

    public class TouchSheet extends Sprite
    {
        private var _poolPoints:Vector.<Point>;

        public function TouchSheet()
        {
            _poolPoints = new <Point>[];

            addEventListener(TouchEvent.TOUCH, onTouch);
            useHandCursor = true;
        }
        
        private function onTouch(event:TouchEvent):void
        {
            var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.MOVED);
            
            if (touches.length == 1)
            {
                // one finger touching -> move
                var delta:Point = touches[0].getMovement(parent, getPoint());
                x += delta.x;
                y += delta.y;
            }
            else if (touches.length == 2)
            {
                // two fingers touching -> rotate and scale
                var touchA:Touch = touches[0];
                var touchB:Touch = touches[1];
                
                var currentPosA:Point  = touchA.getLocation(parent, getPoint());
                var previousPosA:Point = touchA.getPreviousLocation(parent, getPoint());
                var currentPosB:Point  = touchB.getLocation(parent, getPoint());
                var previousPosB:Point = touchB.getPreviousLocation(parent, getPoint());
                
                var currentVector:Point  = getPoint(currentPosA.x - currentPosB.x,
                                                    currentPosA.y - currentPosB.y);
                var previousVector:Point = getPoint(previousPosA.x - previousPosB.x,
                                                    previousPosA.y - previousPosB.y);
                
                var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
                var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
                var angleDiff:Number = currentAngle - previousAngle;

                // update pivot point based on previous center
                var previousLocalA:Point  = touchA.getPreviousLocation(this, getPoint());
                var previousLocalB:Point  = touchB.getPreviousLocation(this, getPoint());
                pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
                pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;

                // update location based on the current center
                x = (currentPosA.x + currentPosB.x) * 0.5;
                y = (currentPosA.y + currentPosB.y) * 0.5;

                // rotate
                rotation += angleDiff;

                // scale
                var sizeDiff:Number = currentVector.length / previousVector.length;
                scaleX *= sizeDiff;
                scaleY *= sizeDiff;
            }

            putPointsBackToPool();
        }

        // streamlined pool handling

        private function getPoint(x:Number=0, y:Number=0):Point
        {
            var point:Point = Pool.getPoint(x, y);
            _poolPoints[_poolPoints.length] = point;
            return point;
        }

        private function putPointsBackToPool():void
        {
            for (var i:int=0; i<_poolPoints.length; ++i)
                Pool.putPoint(_poolPoints[i]);

            _poolPoints.length = 0;
        }
    }
}
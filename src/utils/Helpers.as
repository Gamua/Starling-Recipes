// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package utils
{
    import starling.display.DisplayObject;
    import starling.events.Event;

    public class Helpers
    {
        public static function addStageEventListener(
            target:DisplayObject, type:String, listener:Function):void
        {
            target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            target.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

            if (target.stage) onAddedToStage();

            function onAddedToStage():void
            {
                target.stage.addEventListener(type, listener);
            }

            function onRemovedFromStage():void
            {
                target.stage.removeEventListener(type, listener);
            }
        }
    }
}

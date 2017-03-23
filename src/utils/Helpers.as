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
            object:DisplayObject, type:String, listener:Function):void
        {
            object.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            object.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

            if (object.stage) onAddedToStage();

            function onAddedToStage():void
            {
                object.stage.addEventListener(type, listener);
            }

            function onRemovedFromStage():void
            {
                object.stage.removeEventListener(type, listener);
            }
        }
    }
}

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
    import flash.geom.Rectangle;

    import starling.animation.Transitions;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.textures.Texture;

    public class FlippableCards extends Recipe
    {
        private var _card:Card3D;

        public function FlippableCards()
        {
            super("Click on the card to flip it.");

            var front:DisplayObject = createContents("Front Side", 0xf2af0d);
            var back:DisplayObject  = createContents("Rear Side",  0xbbbbbb);

            _card = new Card3D(front, back);
            addChild(_card);

            addEventListener(TouchEvent.TOUCH, onTouch);
        }

        private function createContents(text:String, color:uint):DisplayObject
        {
            var sprite:Sprite = new Sprite();
            var texture:Texture = assets.getTexture("scale9");

            var image:Image = new Image(texture);
            image.scale9Grid = new Rectangle(25, 25, 50, 50);
            image.color = color;
            image.width = 250;
            image.height = 80;
            image.alignPivot();

            var textField:TextField = new TextField(250, 80, text);
            textField.format.setTo("Ubuntu Medium", 32);
            textField.alignPivot();

            sprite.addChild(image);
            sprite.addChild(textField);

            return sprite;
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
            if (touch)
            {
                var targetRotation:Number = _card.rotationY > Math.PI / 2.0 ? 0 : Math.PI;

                juggler.removeTweens(_card);
                juggler.tween(_card, 0.8, {
                    rotationY: targetRotation,
                    transition: Transitions.EASE_IN_OUT
                });
            }
        }
    }
}

import flash.display3D.Context3DTriangleFace;

import starling.display.DisplayObject;
import starling.display.Sprite3D;
import starling.rendering.Painter;

class Card3D extends Sprite3D
{
    private var _front:DisplayObject;
    private var _back:DisplayObject;

    public function Card3D(front:DisplayObject, back:DisplayObject)
    {
        _front = front;
        _front.alignPivot();

        _back = back;
        _back.alignPivot();
        _back.scaleX = -1;

        addChild(_front);
        addChild(_back);

        useHandCursor = true;
    }

    override public function render(painter:Painter):void
    {
        painter.pushState();
        painter.state.culling = Context3DTriangleFace.BACK;

        super.render(painter);

        painter.popState();
    }
}
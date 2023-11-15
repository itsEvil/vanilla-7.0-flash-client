package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.screens.charrects.CharacterRectList;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class CharacterList extends Sprite
   {
      
      public static const WIDTH:int = 760;
      
      public static const HEIGHT:int = 430;
       
      
      public var charRectList_:CharacterRectList;
      
      public function CharacterList(model:PlayerModel)
      {
         var shape:Shape = null;
         var g:Graphics = null;
         super();
         this.charRectList_ = new CharacterRectList();
         addChild(this.charRectList_);
         if(height > 400)
         {
            shape = new Shape();
            g = shape.graphics;
            g.beginFill(0);
            g.drawRect(0,0,WIDTH,HEIGHT);
            g.endFill();
            addChild(shape);
            mask = shape;
         }
      }
      
      public function setPos(pos:Number) : void
      {
         this.charRectList_.y = pos;
      }
   }
}

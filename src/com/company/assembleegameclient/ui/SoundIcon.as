package com.company.assembleegameclient.ui
{
   import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.Music;
import com.company.assembleegameclient.sound.SFX;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   
   public class SoundIcon extends Sprite
   {
       
      
      private var bitmap_:Bitmap;
      
      public function SoundIcon()
      {
         this.bitmap_ = new Bitmap();
         super();
         addChild(this.bitmap_);
         this.bitmap_.scaleX = 2;
         this.bitmap_.scaleY = 2;
         this.setBitmap();
         addEventListener(MouseEvent.CLICK,this.onIconClick);
         filters = [new GlowFilter(0,1,4,4,2,1)];
      }
      
      private function setBitmap() : void
      {
         this.bitmap_.bitmapData = Parameters.data_.playMusic || Parameters.data_.playSFX ? AssetLibrary.getImageFromSet("lofiInterfaceBig",3):AssetLibrary.getImageFromSet("lofiInterfaceBig",4);
      }
      
      private function onIconClick(event:MouseEvent) : void
      {
         var value:Boolean = !(Parameters.data_.playMusic || Parameters.data_.playSFX);
         Music.setPlayMusic(value);
         SFX.setPlaySFX(value);
         Parameters.data_.playPewPew = value;
         Parameters.save();
         this.setBitmap();
      }
   }
}

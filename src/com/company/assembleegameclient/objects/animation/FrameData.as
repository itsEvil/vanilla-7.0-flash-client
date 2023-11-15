package com.company.assembleegameclient.objects.animation
{
   import com.company.assembleegameclient.objects.TextureData;
   
   public class FrameData
   {
       
      
      public var time_:int;
      
      public var textureData_:TextureData;
      
      public function FrameData(xml:XML)
      {
         super();
         this.time_ = int(Number(xml.@time) * 1000);
         this.textureData_ = new TextureData(xml);
      }
   }
}

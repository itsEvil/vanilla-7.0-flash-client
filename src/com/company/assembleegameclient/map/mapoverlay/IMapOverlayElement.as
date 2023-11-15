package com.company.assembleegameclient.map.mapoverlay
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.objects.GameObject;
   
   public interface IMapOverlayElement
   {
       
      
      function draw(param1:Camera, param2:int) : Boolean;
      
      function dispose() : void;
      
      function getGameObject() : GameObject;
   }
}

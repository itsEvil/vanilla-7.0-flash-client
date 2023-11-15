package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.game.events.DeathEvent;
   import com.company.assembleegameclient.game.events.ReconnectEvent;
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.display.Sprite;
   import flash.events.Event;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class MapEditor extends Sprite
   {
       
      
      private var model:PlayerModel;
      
      private var editingScreen_:EditingScreen;
      
      private var gameSprite_:GameSprite;
      
      public function MapEditor()
      {
         super();
         this.editingScreen_ = new EditingScreen();
         this.editingScreen_.addEventListener(MapTestEvent.MAP_TEST,this.onMapTest);
         addChild(this.editingScreen_);
      }
      
      public function initialize(model:PlayerModel) : void
      {
         this.model = model;
      }
      
      private function onMapTest(event:MapTestEvent) : void
      {
         removeChild(this.editingScreen_);
         this.gameSprite_ = new GameSprite(Parameters.EDITOR_GAMEID,false,this.model.getSavedCharacters()[0].charId(),this.model,event.mapJSON_);
         this.gameSprite_.isEditor = true;
         this.gameSprite_.addEventListener(Event.COMPLETE,this.onMapTestDone);
         this.gameSprite_.addEventListener(ReconnectEvent.RECONNECT,this.onMapTestDone);
         this.gameSprite_.addEventListener(DeathEvent.DEATH,this.onMapTestDone);
         addChild(this.gameSprite_);
      }
      
      private function onMapTestDone(event:Event) : void
      {
         this.cleanupGameSprite();
         addChild(this.editingScreen_);
      }
      
      private function onClientUpdate(event:Event) : void
      {
         this.cleanupGameSprite();
         addChild(this.editingScreen_);
      }
      
      private function cleanupGameSprite() : void
      {
         this.gameSprite_.removeEventListener(Event.COMPLETE,this.onMapTestDone);
         this.gameSprite_.removeEventListener(ReconnectEvent.RECONNECT,this.onMapTestDone);
         this.gameSprite_.removeEventListener(DeathEvent.DEATH,this.onMapTestDone);
         removeChild(this.gameSprite_);
         this.gameSprite_ = null;
      }
   }
}

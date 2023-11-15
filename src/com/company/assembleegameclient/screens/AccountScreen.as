package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.ui.GuildText;
   import com.company.assembleegameclient.ui.RankText;
   import com.company.assembleegameclient.ui.tooltip.RankToolTip;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.account.core.view.AccountInfoView;
   import org.osflash.signals.Signal;
   
   public class AccountScreen extends Sprite
   {
       
      
      public var tooltip:Signal;
      
      private var rankLayer:Sprite;
      
      private var guildLayer:Sprite;
      
      private var accountInfoLayer:Sprite;
      
      private var guildName:String;
      
      private var guildRank:int;
      
      private var stars:int;
      
      private var rankText:RankText;
      
      private var guildText:GuildText;
      
      private var accountInfo:AccountInfoView;
      
      public function AccountScreen()
      {
         super();
         this.tooltip = new Signal();
         this.makeLayers();
      }
      
      private function makeLayers() : void
      {
         addChild(this.rankLayer = new Sprite());
         addChild(this.guildLayer = new Sprite());
         addChild(this.accountInfoLayer = new Sprite());
      }
      
      private function returnHeaderBackground() : DisplayObject
      {
         var headerBackground:Shape = new Shape();
         headerBackground.graphics.beginFill(0,0.5);
         headerBackground.graphics.drawRect(0,0,800,35);
         return headerBackground;
      }
      
      public function setGuild(guildName:String, guildRank:int) : void
      {
         this.guildName = guildName;
         this.guildRank = guildRank;
         this.makeGuildText();
      }
      
      private function makeGuildText() : void
      {
         this.guildText = new GuildText(this.guildName,this.guildRank);
         this.guildText.x = 92;
         this.guildText.y = 6;
         this.guildLayer.addChild(this.guildText);
      }
      
      public function setRank(stars:int) : void
      {
         this.stars = stars;
         this.makeRankText();
      }
      
      private function makeRankText() : void
      {
         this.rankText = new RankText(this.stars,true,false);
         this.rankText.x = 36;
         this.rankText.y = 4;
         this.rankText.mouseEnabled = true;
         this.rankText.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.rankText.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.rankLayer.addChild(this.rankText);
      }
      
      public function setAccountInfo(accountInfo:AccountInfoView) : void
      {
         var display:DisplayObject = null;
         this.accountInfo = accountInfo;
         display = accountInfo as DisplayObject;
         display.x = stage.stageWidth - 10;
         display.y = 2;
         this.accountInfoLayer.addChild(display);
      }
      
      protected function onMouseOver(event:MouseEvent) : void
      {
         this.tooltip.dispatch(new RankToolTip(this.stars));
      }
      
      protected function onRollOut(event:MouseEvent) : void
      {
         this.tooltip.dispatch(null);
      }
   }
}

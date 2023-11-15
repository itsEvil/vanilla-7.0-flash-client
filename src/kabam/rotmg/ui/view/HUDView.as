package kabam.rotmg.ui.view
{
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.TradePanel;
import com.company.assembleegameclient.ui.panels.InteractPanel;
import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;
import com.company.util.GraphicsUtil;
import com.company.util.SpriteUtil;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import kabam.rotmg.game.view.components.TabStripView;
import kabam.rotmg.messaging.impl.incoming.TradeAccepted;
import kabam.rotmg.messaging.impl.incoming.TradeChanged;
import kabam.rotmg.messaging.impl.incoming.TradeStart;
import kabam.rotmg.minimap.view.MiniMap;

public class HUDView extends Sprite
{


   private const BG_POSITION:Point = new Point(0,0);

   private const MAP_POSITION:Point = new Point(4,4);

   private const CHARACTER_DETAIL_PANEL_POSITION:Point = new Point(0,198);

   private const STAT_METERS_POSITION:Point = new Point(12,230);

   private const EQUIPMENT_INVENTORY_POSITION:Point = new Point(14,304);

   private const TAB_STRIP_POSITION:Point = new Point(7,346);

   private const INTERACT_PANEL_POSITION:Point = new Point(0,500);

   private var background:CharacterWindowBackground;

   private var miniMap:MiniMap;

   private var equippedGrid:EquippedGrid;

   private var tabStrip:TabStripView;

   private var statMeters:StatMetersView;

   private var characterDetails:CharacterDetailsView;

   public var interactPanel:InteractPanel;

   public var tradePanel:TradePanel;

   private var equippedGridBG:Sprite;

   public function HUDView()
   {
      super();
      this.createAssets();
      this.addAssets();
      this.positionAssets();
   }

   private function createAssets() : void
   {
      this.background = new CharacterWindowBackground();
      this.miniMap = new MiniMap(192,192);
      this.tabStrip = new TabStripView(186,153);
      this.characterDetails = new CharacterDetailsView();
      this.statMeters = new StatMetersView();
   }

   private function addAssets() : void
   {
      addChild(this.background);
      addChild(this.miniMap);
      addChild(this.tabStrip);
      addChild(this.characterDetails);
      addChild(this.statMeters);
   }

   private function positionAssets() : void
   {
      this.background.x = this.BG_POSITION.x;
      this.background.y = this.BG_POSITION.y;
      this.miniMap.x = this.MAP_POSITION.x;
      this.miniMap.y = this.MAP_POSITION.y;
      this.tabStrip.x = this.TAB_STRIP_POSITION.x;
      this.tabStrip.y = this.TAB_STRIP_POSITION.y;
      this.characterDetails.x = this.CHARACTER_DETAIL_PANEL_POSITION.x;
      this.characterDetails.y = this.CHARACTER_DETAIL_PANEL_POSITION.y;
      this.statMeters.x = this.STAT_METERS_POSITION.x;
      this.statMeters.y = this.STAT_METERS_POSITION.y;
   }

   public function setPlayerDependentAssets(gs:GameSprite) : void
   {
      var player:Player = gs.map.player_;
      this.equippedGridBG = new Sprite();
      this.equippedGridBG.x = this.EQUIPMENT_INVENTORY_POSITION.x - 3;
      this.equippedGridBG.y = this.EQUIPMENT_INVENTORY_POSITION.y - 3;
      var fill_:GraphicsSolidFill = new GraphicsSolidFill(6776679,1);
      var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[fill_,path_,GraphicsUtil.END_FILL];
      GraphicsUtil.drawCutEdgeRect(0,0,178,46,6,[1,1,1,1],path_);
      this.equippedGridBG.graphics.drawGraphicsData(graphicsData_);
      addChild(this.equippedGridBG);
      this.equippedGrid = new EquippedGrid(player,player.slotTypes_,player);
      this.equippedGrid.x = this.EQUIPMENT_INVENTORY_POSITION.x;
      this.equippedGrid.y = this.EQUIPMENT_INVENTORY_POSITION.y;
      addChild(this.equippedGrid);
      this.interactPanel = new InteractPanel(gs,player,200,100);
      this.interactPanel.x = this.INTERACT_PANEL_POSITION.x;
      this.interactPanel.y = this.INTERACT_PANEL_POSITION.y;
      addChild(this.interactPanel);
   }

   public function draw() : void
   {
      if(this.equippedGrid)
      {
         this.equippedGrid.draw();
      }
      if(this.interactPanel)
      {
         this.interactPanel.draw();
      }
   }

   public function startTrade(gs:GameSprite, tradeStart:TradeStart) : void
   {
      if(this.tradePanel != null)
      {
         return;
      }
      this.tradePanel = new TradePanel(gs,tradeStart);
      this.tradePanel.y = 200;
      this.tradePanel.addEventListener(Event.CANCEL,this.onTradeCancel);
      addChild(this.tradePanel);
      this.characterDetails.visible = false;
      this.statMeters.visible = false;
      this.tabStrip.visible = false;
      this.equippedGrid.visible = false;
      this.equippedGridBG.visible = false;
      this.interactPanel.visible = false;
   }

   public function tradeChanged(tradeChanged:TradeChanged) : void
   {
      if(this.tradePanel == null)
      {
         return;
      }
      this.tradePanel.setYourOffer(tradeChanged.offer_);
   }

   public function tradeAccepted(tradeAccepted:TradeAccepted) : void
   {
      if(this.tradePanel == null)
      {
         return;
      }
      this.tradePanel.youAccepted(tradeAccepted.myOffer_,tradeAccepted.yourOffer_);
   }

   private function onTradeCancel(event:Event) : void
   {
      this.removeTradePanel();
   }

   public function tradeDone() : void
   {
      this.removeTradePanel();
   }

   private function removeTradePanel() : void
   {
      if(this.tradePanel != null)
      {
         this.tradePanel.removeEventListener(Event.CANCEL,this.onTradeCancel);
         SpriteUtil.safeRemoveChild(this,this.tradePanel);
         this.tradePanel = null;
         this.characterDetails.visible = true;
         this.statMeters.visible = true;
         this.tabStrip.visible = true;
         this.equippedGrid.visible = true;
         this.equippedGridBG.visible = true;
         this.interactPanel.visible = true;
      }
   }
}
}

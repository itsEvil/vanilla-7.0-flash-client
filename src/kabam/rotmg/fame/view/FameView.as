package kabam.rotmg.fame.view
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.screens.ScoreTextLine;
   import com.company.assembleegameclient.screens.ScoringBox;
   import com.company.assembleegameclient.screens.TitleMenuOption;
   import com.company.assembleegameclient.sound.SoundEffectLibrary;
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.rotmg.graphics.FameIconBackgroundDesign;
   import com.company.rotmg.graphics.ScreenGraphic;
   import com.company.ui.SimpleText;
   import com.company.util.BitmapUtil;
   import com.gskinner.motion.GTween;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import kabam.rotmg.ui.view.components.ScreenBase;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class FameView extends Sprite
   {
      private static const CHARACTER_INFO:String = "${NAME}, Level ${LEVEL} ${TYPE}";
      private static const DEATH_INFO_LONG:String = "killed on ${DATE} by ${KILLER}";
      private static const DEATH_INFO_SHORT:String = "died ${DATE}";

      public var closed:Signal;
      private var infoContainer:DisplayObjectContainer;
      private var overlayContainer:Bitmap;
      private var title:SimpleText;
      private var date:SimpleText;
      private var scoringBox:ScoringBox;
      private var finalLine:ScoreTextLine;
      private var continueBtn:TitleMenuOption;
      private var isAnimation:Boolean;
      private var isFadeComplete:Boolean;
      private var isDataPopulated:Boolean;
      
      public function FameView()
      {
         super();
         addChild(new ScreenBase());
         addChild(this.infoContainer = new Sprite());
         addChild(this.overlayContainer = new Bitmap());
         this.continueBtn = new TitleMenuOption("continue",36,false);
         this.closed = new NativeMappedSignal(this.continueBtn,MouseEvent.CLICK);
      }
      
      public function setIsAnimation(isAnimation:Boolean) : void
      {
         this.isAnimation = isAnimation;
      }
      
      public function setBackground(background:BitmapData) : void
      {
         this.overlayContainer.bitmapData = background;
         var tween:GTween = new GTween(this.overlayContainer,2,{"alpha":0});
         tween.onComplete = this.onFadeComplete;
      }
      
      public function clearBackground() : void
      {
         this.overlayContainer.bitmapData = null;
      }
      
      private function onFadeComplete(tween:GTween) : void
      {
         removeChild(this.overlayContainer);
         this.isFadeComplete = true;
         if(this.isDataPopulated)
         {
            this.makeContinueButton();
         }
      }
      
      public function setCharacterInfo(name:String, level:int, type:int) : void
      {
         this.title = new SimpleText(38,13421772,false,0,0);
         this.title.setBold(true);
         this.title.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.title.text = CHARACTER_INFO.replace("${NAME}",name).replace("${LEVEL}",level).replace("${TYPE}",ObjectLibrary.typeToDisplayId_[type]);
         this.title.updateMetrics();
         this.title.x = stage.stageWidth / 2 - this.title.width / 2;
         this.title.y = 225;
         this.infoContainer.addChild(this.title);
      }
      
      public function setDeathInfo(dateStr:String, killer:String) : void
      {
         this.date = new SimpleText(24,13421772,false,0,0);
         this.date.setBold(true);
         this.date.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.date.text = (Boolean(killer)?DEATH_INFO_LONG:DEATH_INFO_SHORT).replace("${DATE}",dateStr).replace("${KILLER}",killer);
         this.date.updateMetrics();
         this.date.x = stage.stageWidth / 2 - this.date.width / 2;
         this.date.y = 272;
         this.infoContainer.addChild(this.date);
      }
      
      public function setIcon(icon:BitmapData) : void
      {
         var backgroundDesign:Sprite = null;
         var container:Sprite = new Sprite();
         backgroundDesign = new FameIconBackgroundDesign();
         backgroundDesign.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         container.addChild(backgroundDesign);
         var bitmap:Bitmap = new Bitmap(icon);
         bitmap.x = container.width / 2 - bitmap.width / 2;
         bitmap.y = container.height / 2 - bitmap.height / 2;
         container.addChild(bitmap);
         container.y = 20;
         container.x = stage.stageWidth / 2 - container.width / 2;
         this.infoContainer.addChild(container);
      }
      
      public function setScore(score:int, xml:XML) : void
      {
         this.scoringBox = new ScoringBox(new Rectangle(0,0,784,150),xml);
         this.scoringBox.x = 8;
         this.scoringBox.y = 316;
         addChild(this.scoringBox);
         this.infoContainer.addChild(this.scoringBox);
         var fameBD:BitmapData = FameUtil.getFameIcon();
         fameBD = BitmapUtil.cropToBitmapData(fameBD,6,6,fameBD.width - 12,fameBD.height - 12);
         this.finalLine = new ScoreTextLine(24,13421772,16762880,"Total Fame Earned",null,score,"","",new Bitmap(fameBD));
         this.finalLine.x = 10;
         this.finalLine.y = 470;
         this.infoContainer.addChild(this.finalLine);
         this.isDataPopulated = true;
         if(!this.isAnimation || this.isFadeComplete)
         {
            this.makeContinueButton();
         }
      }
      
      private function makeContinueButton() : void
      {
         this.infoContainer.addChild(new ScreenGraphic());
         this.continueBtn.x = stage.stageWidth / 2 - this.continueBtn.width / 2;
         this.continueBtn.y = 520;
         this.infoContainer.addChild(this.continueBtn);
         if(this.isAnimation)
         {
            this.scoringBox.animateScore();
         }
         else
         {
            this.scoringBox.showScore();
         }
      }
   }
}

package kabam.rotmg.tooltips.view
{
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class TooltipsMediator extends Mediator
   {
       
      
      [Inject]
      public var view:TooltipsView;
      
      [Inject]
      public var showTooltip:ShowTooltipSignal;
      
      [Inject]
      public var hideTooltips:HideTooltipsSignal;
      
      public function TooltipsMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.showTooltip.add(this.onShowTooltip);
         this.hideTooltips.add(this.onHideTooltips);
      }
      
      override public function destroy() : void
      {
         this.showTooltip.remove(this.onShowTooltip);
         this.hideTooltips.remove(this.onHideTooltips);
      }
      
      private function onShowTooltip(tooltip:ToolTip) : void
      {
         this.view.show(tooltip);
      }
      
      private function onHideTooltips() : void
      {
         this.view.hide();
      }
   }
}

package kabam.lib.resizing
{
   import kabam.lib.resizing.signals.Resize;
   import kabam.lib.resizing.view.Resizable;
   import kabam.lib.resizing.view.ResizableMediator;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
   
   public class ResizeConfig
   {
       
      
      [Inject]
      public var injector:Injector;
      
      [Inject]
      public var mediatorMap:IMediatorMap;
      
      public function ResizeConfig()
      {
         super();
      }
      
      [PostConstruct]
      public function setup() : void
      {
         this.injector.map(Resize).asSingleton();
         this.mediatorMap.map(Resizable).toMediator(ResizableMediator);
      }
   }
}

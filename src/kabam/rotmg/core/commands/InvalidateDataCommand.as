package kabam.rotmg.core.commands
{
   import kabam.rotmg.account.core.model.JSInitializedModel;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class InvalidateDataCommand
   {
       
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var jsInitialized:JSInitializedModel;
      
      public function InvalidateDataCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.model.isInvalidated = true;
         this.jsInitialized.isInitialized = false;
      }
   }
}

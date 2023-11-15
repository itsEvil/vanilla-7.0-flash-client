package kabam.rotmg.startup.control
{
   import kabam.lib.tasks.TaskMonitor;
   
   public class StartupCommand
   {
       
      
      [Inject]
      public var startup:StartupSequence;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      public function StartupCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.monitor.add(this.startup);
         this.startup.start();
      }
   }
}

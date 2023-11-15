package kabam.rotmg.account.web.commands
{
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;

import flash.display.Sprite;

import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.RegisterAccountTask;
   import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
   import kabam.rotmg.account.web.view.WebAccountDetailDialog;
import kabam.rotmg.core.model.ScreenModel;
import kabam.rotmg.core.signals.InvalidateDataSignal;
import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class WebRegisterAccountCommand
   {
       
      
      [Inject]
      public var task:RegisterAccountTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var taskError:TaskErrorSignal;
      
      [Inject]
      public var updateAccount:UpdateAccountInfoSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;

      [Inject]
      public var invalidate:InvalidateDataSignal;

      [Inject]
      public var setScreenWithValidData:SetScreenWithValidDataSignal;

      [Inject]
      public var screenModel:ScreenModel;
      
      public function WebRegisterAccountCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var branch:BranchingTask = new BranchingTask(this.task,this.makeSuccess(),this.makeFailure());
         this.monitor.add(branch);
         branch.start();
      }
      
      private function makeSuccess() : Task
      {
         var sequence:TaskSequence = new TaskSequence();
         sequence.add(new DispatchSignalTask(this.updateAccount));
         sequence.add(new DispatchSignalTask(this.openDialog,new WebAccountDetailDialog()));
         sequence.add(new DispatchSignalTask(this.invalidate));
         sequence.add(new DispatchSignalTask(this.setScreenWithValidData,this.getTargetScreen()));
         return sequence;
      }
      
      private function makeFailure() : DispatchSignalTask
      {
         return new DispatchSignalTask(this.taskError,this.task);
      }

      private function getTargetScreen() : Sprite
      {
         var type:Class = this.screenModel.currentType;
         if(type == null || type == GameSprite)
         {
            type = CharacterSelectionAndNewsScreen;
         }
         return new type();
      }
   }
}

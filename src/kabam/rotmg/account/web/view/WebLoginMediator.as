package kabam.rotmg.account.web.view
{
   import kabam.lib.tasks.Task;
   import kabam.rotmg.account.core.signals.LoginSignal;
   import kabam.rotmg.account.web.model.AccountData;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class WebLoginMediator extends Mediator
   {
       
      
      [Inject]
      public var view:WebLoginDialog;
      
      [Inject]
      public var login:LoginSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      [Inject]
      public var loginError:TaskErrorSignal;
      
      public function WebLoginMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.signIn.add(this.onSignIn);
         this.view.register.add(this.onRegister);
         this.view.cancel.add(this.onCancel);
         this.loginError.add(this.onLoginError);
      }
      
      override public function destroy() : void
      {
         this.view.signIn.remove(this.onSignIn);
         this.view.register.remove(this.onRegister);
         this.view.cancel.remove(this.onCancel);
         this.loginError.remove(this.onLoginError);
      }
      
      private function onSignIn(data:AccountData) : void
      {
         this.view.disable();
         this.login.dispatch(data);
      }
      
      private function onRegister() : void
      {
         this.openDialog.dispatch(new WebRegisterDialog());
      }
      
      private function onCancel() : void
      {
         this.closeDialog.dispatch();
      }
      
      private function onLoginError(task:Task) : void
      {
         this.view.setError(task.error);
         this.view.enable();
      }
   }
}

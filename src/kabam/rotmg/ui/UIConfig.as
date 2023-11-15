package kabam.rotmg.ui
{
   import com.company.assembleegameclient.mapeditor.MapEditor;
   import com.company.assembleegameclient.screens.AccountScreen;
   import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
   import com.company.assembleegameclient.screens.NewsLine;
   import com.company.assembleegameclient.screens.LoadingScreen;
   import com.company.assembleegameclient.screens.NewCharacterScreen;
   import com.company.assembleegameclient.screens.charrects.CharacterRectList;
   import com.company.assembleegameclient.screens.charrects.CurrentCharacterRect;
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
   import com.company.assembleegameclient.ui.panels.InteractPanel;
   import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
   import com.company.assembleegameclient.ui.panels.mediators.InteractPanelMediator;
   import com.company.assembleegameclient.ui.panels.mediators.ItemGridMediator;
   import kabam.rotmg.account.core.services.GetCharListTask;
   import kabam.rotmg.account.core.services.LoadAccountTask;
   import kabam.rotmg.account.core.view.AccountInfoMediator;
   import kabam.rotmg.account.core.view.AccountInfoView;
   import kabam.rotmg.account.core.view.RegisterPromptDialog;
   import kabam.rotmg.account.core.view.RegisterPromptDialogMediator;
import kabam.rotmg.game.model.PotionInventoryModel;
import kabam.rotmg.startup.control.StartupSequence;
   import kabam.rotmg.ui.commands.EnterGameCommand;
   import kabam.rotmg.ui.commands.HUDInitCommand;
   import kabam.rotmg.ui.commands.ShowLoadingUICommand;
   import kabam.rotmg.ui.commands.ShowTitleUICommand;
   import kabam.rotmg.ui.model.HUDModel;
   import kabam.rotmg.ui.signals.EnterGameSignal;
   import kabam.rotmg.ui.signals.HUDModelInitialized;
   import kabam.rotmg.ui.signals.HUDSetupStarted;
   import kabam.rotmg.ui.signals.NameChangedSignal;
   import kabam.rotmg.ui.signals.ShowLoadingUISignal;
   import kabam.rotmg.ui.signals.ShowTitleUISignal;
import kabam.rotmg.ui.signals.StatsTabHotKeyInputSignal;
import kabam.rotmg.ui.signals.UpdateBackpackTabSignal;
import kabam.rotmg.ui.signals.UpdateHUDSignal;
import kabam.rotmg.ui.signals.UpdatePotionInventorySignal;
import kabam.rotmg.ui.view.AccountScreenMediator;
   import kabam.rotmg.ui.view.CharacterDetailsMediator;
   import kabam.rotmg.ui.view.CharacterDetailsView;
   import kabam.rotmg.ui.view.CharacterRectListMediator;
   import kabam.rotmg.ui.view.CharacterSlotNeedGoldDialog;
   import kabam.rotmg.ui.view.CharacterSlotNeedGoldMediator;
   import kabam.rotmg.ui.view.CharacterSlotRegisterDialog;
   import kabam.rotmg.ui.view.CharacterSlotRegisterMediator;
   import kabam.rotmg.ui.view.ChooseNameRegisterDialog;
   import kabam.rotmg.ui.view.ChooseNameRegisterMediator;
   import kabam.rotmg.ui.view.CurrentCharacterMediator;
   import kabam.rotmg.ui.view.CurrentCharacterRectMediator;
   import kabam.rotmg.ui.view.ErrorDialogMediator;
import kabam.rotmg.ui.view.MessageCloseDialog;
import kabam.rotmg.ui.view.MessageCloseMediator;
import kabam.rotmg.ui.view.HUDMediator;
   import kabam.rotmg.ui.view.HUDView;
   import kabam.rotmg.ui.view.LoadingMediator;
   import kabam.rotmg.ui.view.MapEditorMediator;
   import kabam.rotmg.ui.view.NewCharacterMediator;
   import kabam.rotmg.ui.view.NewsLineMediator;
   import kabam.rotmg.ui.view.NotEnoughGoldDialog;
   import kabam.rotmg.ui.view.NotEnoughGoldMediator;
   import kabam.rotmg.ui.view.StatMetersMediator;
   import kabam.rotmg.ui.view.StatMetersView;
   import kabam.rotmg.ui.view.TitleMediator;
   import kabam.rotmg.ui.view.TitleView;
import kabam.rotmg.ui.view.components.PotionSlotMediator;
import kabam.rotmg.ui.view.components.PotionSlotView;

import org.swiftsuspenders.Injector;
   import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
   import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
   import robotlegs.bender.framework.api.IConfig;
   
   public class UIConfig implements IConfig
   {
       
      
      [Inject]
      public var injector:Injector;
      
      [Inject]
      public var mediatorMap:IMediatorMap;
      
      [Inject]
      public var commandMap:ISignalCommandMap;
      
      [Inject]
      public var startup:StartupSequence;
      
      public function UIConfig()
      {
         super();
      }
      
      public function configure() : void
      {
         this.injector.map(NameChangedSignal).asSingleton();
         this.injector.map(PotionInventoryModel).asSingleton();
         this.injector.map(UpdatePotionInventorySignal).asSingleton();
         this.injector.map(UpdateBackpackTabSignal).asSingleton();
         this.injector.map(StatsTabHotKeyInputSignal).asSingleton();
         this.commandMap.map(ShowLoadingUISignal).toCommand(ShowLoadingUICommand);
         this.commandMap.map(ShowTitleUISignal).toCommand(ShowTitleUICommand);
         this.commandMap.map(EnterGameSignal).toCommand(EnterGameCommand);
         this.mediatorMap.map(LoadingScreen).toMediator(LoadingMediator);
         this.mediatorMap.map(CharacterSelectionAndNewsScreen).toMediator(CurrentCharacterMediator);
         this.mediatorMap.map(AccountInfoView).toMediator(AccountInfoMediator);
         this.mediatorMap.map(AccountScreen).toMediator(AccountScreenMediator);
         this.mediatorMap.map(TitleView).toMediator(TitleMediator);
         this.mediatorMap.map(NewCharacterScreen).toMediator(NewCharacterMediator);
         this.mediatorMap.map(MapEditor).toMediator(MapEditorMediator);
         this.mediatorMap.map(CurrentCharacterRect).toMediator(CurrentCharacterRectMediator);
         this.mediatorMap.map(CharacterRectList).toMediator(CharacterRectListMediator);
         this.mediatorMap.map(ErrorDialog).toMediator(ErrorDialogMediator);
         this.mediatorMap.map(NewsLine).toMediator(NewsLineMediator);
         this.mediatorMap.map(NotEnoughGoldDialog).toMediator(NotEnoughGoldMediator);
         this.mediatorMap.map(MessageCloseDialog).toMediator(MessageCloseMediator);
         this.mediatorMap.map(InteractPanel).toMediator(InteractPanelMediator);
         this.mediatorMap.map(ItemGrid).toMediator(ItemGridMediator);
         this.mediatorMap.map(ChooseNameRegisterDialog).toMediator(ChooseNameRegisterMediator);
         this.mediatorMap.map(CharacterSlotRegisterDialog).toMediator(CharacterSlotRegisterMediator);
         this.mediatorMap.map(RegisterPromptDialog).toMediator(RegisterPromptDialogMediator);
         this.mediatorMap.map(CharacterSlotNeedGoldDialog).toMediator(CharacterSlotNeedGoldMediator);
         this.mediatorMap.map(PlayerGroupMenu).toMediator(PlayerGroupMenuMediator);
         this.mediatorMap.map(StatMetersView).toMediator(StatMetersMediator);
         this.mediatorMap.map(HUDView).toMediator(HUDMediator);
         this.mediatorMap.map(PotionSlotView).toMediator(PotionSlotMediator);
         this.setupCharacterWindow();
         this.startup.addSignal(ShowLoadingUISignal,-1);
         this.startup.addTask(LoadAccountTask);
         this.startup.addTask(GetCharListTask);
         this.startup.addSignal(ShowTitleUISignal,StartupSequence.LAST);
      }
      
      private function setupCharacterWindow() : void
      {
         this.injector.map(HUDModel).asSingleton();
         this.injector.map(UpdateHUDSignal).asSingleton();
         this.injector.map(HUDModelInitialized).asSingleton();
         this.commandMap.map(HUDSetupStarted).toCommand(HUDInitCommand);
         this.mediatorMap.map(CharacterDetailsView).toMediator(CharacterDetailsMediator);
      }
   }
}

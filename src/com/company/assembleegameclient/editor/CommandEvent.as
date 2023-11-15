package com.company.assembleegameclient.editor
{
   import flash.events.Event;
   
   public class CommandEvent extends Event
   {
      
      public static const UNDO_COMMAND_EVENT:String = "UNDO_COMMAND_EVENT";
      
      public static const REDO_COMMAND_EVENT:String = "REDO_COMMAND_EVENT";
      
      public static const CLEAR_COMMAND_EVENT:String = "CLEAR_COMMAND_EVENT";
      
      public static const LOAD_COMMAND_EVENT:String = "LOAD_COMMAND_EVENT";
      
      public static const SAVE_COMMAND_EVENT:String = "SAVE_COMMAND_EVENT";
      
      public static const TEST_COMMAND_EVENT:String = "TEST_COMMAND_EVENT";

      public static const BACK_COMMAND_EVENT:String = "BACK_COMMAND_EVENT";
       
      
      public function CommandEvent(type:String)
      {
         super(type);
      }
   }
}

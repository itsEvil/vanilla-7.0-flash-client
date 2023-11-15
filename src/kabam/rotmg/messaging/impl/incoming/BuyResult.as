package kabam.rotmg.messaging.impl.incoming
{
import flash.utils.Dictionary;
import flash.utils.IDataInput;
   
   public class BuyResult extends IncomingMessage
   {
      public static const SUCCESS_BRID:int = 0;

      public static const DIALOG_BRID:int = 1;

      private static const resultStrings:Object = {
         0:"Purchase successful",
         1:"Cannot purchase items as a guest",
         2:"Insufficient rank",
         3:"Insufficient funds",
         4:"Can't buy items on a test map",
         5:"Uninitialized",
         6:"Transaction failed",
         7:"Item is currently being purchased",
         8:"Admins can't buy player sold items"
      }
       
      
      public var result_:int;
      
      public var resultString_:String;
      
      public function BuyResult(id:uint, callback:Function)
      {
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         this.result_ = data.readByte();
         this.resultString_ = resultStrings[data.readByte()];
      }
      
      override public function toString() : String
      {
         return formatToString("BUYRESULT","result_","resultString_");
      }
   }
}

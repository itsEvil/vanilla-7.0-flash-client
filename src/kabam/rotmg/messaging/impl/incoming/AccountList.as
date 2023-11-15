package kabam.rotmg.messaging.impl.incoming
{
   import flash.utils.IDataInput;
   
   public class AccountList extends IncomingMessage
   {
       
      
      public var accountListId_:int;
      
      public var accountIds_:Vector.<int>;
      
      public function AccountList(id:uint, callback:Function)
      {
         this.accountIds_ = new Vector.<int>();
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         var i:int = 0;
         this.accountListId_ = data.readInt();
         this.accountIds_.length = 0;
         var num:int = data.readShort();
         for(i = 0; i < num; i++)
         {
            this.accountIds_.push(data.readInt());
         }
      }
      
      override public function toString() : String
      {
         return formatToString("ACCOUNTLIST","accountListId_","accountIds_");
      }
   }
}

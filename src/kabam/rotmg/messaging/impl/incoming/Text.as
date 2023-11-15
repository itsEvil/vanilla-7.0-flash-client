package kabam.rotmg.messaging.impl.incoming
{
import flash.utils.IDataInput;

public class Text extends IncomingMessage
{


   public var name_:String;

   public var objectId_:int;

   public var numStars_:int;

   public var bubbleTime_:uint;

   public var recipient_:String;

   public var text_:String;

   public var nameColor_:uint;

   public var chatColor_:uint;

   public var senderId_:int;

   public function Text(id:uint, callback:Function)
   {
      this.name_ = new String();
      this.text_ = new String();
      super(id,callback);
   }

   override public function parseFromInput(data:IDataInput) : void
   {
      this.name_ = data.readUTF();
      this.objectId_ = data.readInt();
      this.numStars_ = data.readInt();
      this.bubbleTime_ = data.readUnsignedByte();
      this.recipient_ = data.readUTF();
      this.text_ = data.readUTF();
      this.nameColor_ = data.readUnsignedInt();
      this.chatColor_ = data.readUnsignedInt();
      this.senderId_ = data.readInt();
   }

   override public function toString() : String
   {
      return formatToString("TEXT","name_","objectId_","numStars_","bubbleTime_","recipient_","text_","nameColor_","chatColor_","senderId_");
   }
}
}

package kabam.rotmg.messaging.impl
{
   public class OutstandingBuy
   {
       
      
      private var id_:String;
      
      public var price_:int;
      
      public var currency_:int;
      
      function OutstandingBuy(id:String, price:int, currency:int)
      {
         super();
         this.id_ = id;
         this.price_ = price;
         this.currency_ = currency;
      }
   }
}

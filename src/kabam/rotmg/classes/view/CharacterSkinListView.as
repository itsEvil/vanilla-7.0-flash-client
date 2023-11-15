package kabam.rotmg.classes.view
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import kabam.lib.ui.api.Size;
   import kabam.rotmg.util.components.VerticalScrollingList;
   
   public class CharacterSkinListView extends Sprite
   {
      public static const PADDING:int = 5;
      public static const WIDTH:int = 442;
      public static const HEIGHT:int = 400;
       
      
      private const list:VerticalScrollingList = makeList();
      private var items:Vector.<DisplayObject>;
      
      public function CharacterSkinListView()
      {
         super();
      }
      
      private function makeList() : VerticalScrollingList
      {
         var list:VerticalScrollingList = new VerticalScrollingList();
         list.setSize(new Size(WIDTH,HEIGHT));
         list.scrollStateChanged.add(this.onScrollStateChanged);
         list.setPadding(PADDING);
         addChild(list);
         return list;
      }
      
      public function setItems(items:Vector.<DisplayObject>) : void
      {
         this.items = items;
         this.list.setItems(items);
         this.onScrollStateChanged(this.list.isScrollbarVisible());
      }
      
      private function onScrollStateChanged(isVisible:Boolean) : void
      {
         var item:CharacterSkinListItem = null;
         var width:int = CharacterSkinListItem.WIDTH;
         if(!isVisible)
         {
            width = width + VerticalScrollingList.SCROLLBAR_GUTTER;
         }
         for each(item in this.items)
         {
            item.setWidth(width);
         }
      }
      
      public function getListHeight() : Number
      {
         return this.list.getListHeight();
      }
   }
}

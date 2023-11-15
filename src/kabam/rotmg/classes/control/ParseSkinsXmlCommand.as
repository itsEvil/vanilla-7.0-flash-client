package kabam.rotmg.classes.control
{
import kabam.rotmg.assets.EmbeddedData;
import kabam.rotmg.assets.model.CharacterTemplate;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   
   public class ParseSkinsXmlCommand
   {
       
      
      [Inject]
      public var data:XML;
      
      [Inject]
      public var model:ClassesModel;
      
      public function ParseSkinsXmlCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var node:XML = EmbeddedData.skinsXML;
         var list:XMLList = node.children();
         for each(node in list)
         {
            this.parseNode(node);
         }
      }
      
      private function parseNode(xml:XML) : void
      {
         var file:String = null;
         file = xml.AnimatedTexture.File;
         var index:int = xml.AnimatedTexture.Index;
         var skin:CharacterSkin = new CharacterSkin();
         skin.id = xml.@type;
         skin.name = xml.@id;
         skin.template = new CharacterTemplate(file,index);
         var character:CharacterClass = this.model.getCharacterClass(xml.PlayerClassType);
         character.skins.addSkin(skin);
      }
   }
}

package kabam.rotmg.stage3D.Object3D
{
   import flash.display3D.IndexBuffer3D;
   
   public class OBJGroup
   {
       
      
      public var name:String;
      
      public var materialName:String;
      
      public var indexBuffer:IndexBuffer3D;
      
      public var _faces:Vector.<Vector.<String>>;

      public var _indices:Vector.<uint>;
      
      public function OBJGroup(name:String = null, materialName:String = null)
      {
         super();
         this.name = name;
         this.materialName = materialName;
         this._faces = new Vector.<Vector.<String>>();
         this._indices = new Vector.<uint>();
      }
      
      public function dispose() : void
      {
         if(this.indexBuffer != null)
         {
            this.indexBuffer.dispose();
            this.indexBuffer = null;
         }
         this._faces.length = 0;
         this._indices.length = 0;
      }
   }
}

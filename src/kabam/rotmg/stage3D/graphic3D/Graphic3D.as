package kabam.rotmg.stage3D.graphic3D
{
   import flash.display.BitmapData;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsGradientFill;
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.VertexBuffer3D;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import kabam.rotmg.stage3D.GraphicsFillExtra;
   import kabam.rotmg.stage3D.proxies.Context3DProxy;
   import kabam.rotmg.stage3D.proxies.IndexBuffer3DProxy;
   import kabam.rotmg.stage3D.proxies.TextureProxy;
   import kabam.rotmg.stage3D.proxies.VertexBuffer3DProxy;
   
   public class Graphic3D
   {
      private static const gradientVertex:Vector.<Number> = Vector.<Number>(
              [-0.5, 0.5, 0, 0, 0, 0, 0.01, 0, 1, 0.5, 0.5, 0, 0, 0, 0, 0.3, 1, 1,
                 -0.5, -0.5, 0, 0, 0, 0, 0.1, 0, 0, 0.5, -0.5, 0, 0, 0, 0, 0.2, 1, 0]);
      private static const indices:Vector.<uint> = Vector.<uint>([0,1,2,2,1,3]);

      public var texture:TextureProxy;
      public var matrix3D:Matrix3D;
      public var context3D:Context3DProxy;
      
      [Inject]
      public var textureFactory:TextureFactory;
      
      [Inject]
      public var vertexBuffer:VertexBuffer3DProxy;
      
      [Inject]
      public var indexBuffer:IndexBuffer3DProxy;

      private var bitmapData:BitmapData;
      private var matrix2D:Matrix;
      private var shadowMatrix2D:Matrix;
      private var sinkLevel:Number = 0;
      private var offsetMatrix:Vector.<Number>;
      private var vertexBufferCustom:VertexBuffer3D;
      private var gradientVB:VertexBuffer3D;
      private var gradientIB:IndexBuffer3D;
      private var repeat:Boolean;

      private var sinkOffset:Vector.<Number>;
      private var ctMult:Vector.<Number>;
      private var ctOffset:Vector.<Number>;
      private var rawMatrix3D:Vector.<Number>;
      
      public function Graphic3D()
      {
         this.matrix3D = new Matrix3D();
         this.sinkOffset = new Vector.<Number>(4, true);
         this.ctMult = new Vector.<Number>(4, true);
         this.ctOffset = new Vector.<Number>(4, true);
         this.rawMatrix3D = new Vector.<Number>(16, true);
         super();
      }
      
      public function setGraphic(graphicsBitmapFill:GraphicsBitmapFill, context3D:Context3DProxy) : void
      {
         this.bitmapData = graphicsBitmapFill.bitmapData;
         this.repeat = graphicsBitmapFill.repeat;
         this.matrix2D = graphicsBitmapFill.matrix;
         this.texture = this.textureFactory.make(graphicsBitmapFill.bitmapData);
         this.offsetMatrix = GraphicsFillExtra.getOffsetUV(graphicsBitmapFill);
         this.vertexBufferCustom = GraphicsFillExtra.getVertexBuffer(graphicsBitmapFill);
         this.sinkLevel = GraphicsFillExtra.getSinkLevel(graphicsBitmapFill);
         if(this.sinkLevel != 0)
         {
            this.sinkOffset[1] = -this.sinkLevel;
            this.offsetMatrix = sinkOffset;
         }
         this.transform();
         var ct:ColorTransform = GraphicsFillExtra.getColorTransform(this.bitmapData);
         ctMult[0] = ct.redMultiplier;
         ctMult[1] = ct.greenMultiplier;
         ctMult[2] = ct.blueMultiplier;
         ctMult[3] = ct.alphaMultiplier;
         ctOffset[0] = ct.redOffset / 0xFF;
         ctOffset[1] = ct.greenOffset / 0xFF;
         ctOffset[2] = ct.blueOffset / 0xFF;
         ctOffset[3] = ct.alphaOffset / 0xFF;
         var c3d:Context3D = context3D.GetContext3D();
         c3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, ctMult);
         c3d.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, ctOffset);
      }
      
      public function setGradientFill(gradientFill:GraphicsGradientFill, context3D:Context3DProxy, width:Number, height:Number) : void
      {
         this.shadowMatrix2D = gradientFill.matrix;
         if(this.gradientVB == null || this.gradientIB == null)
         {
            this.gradientVB = context3D.GetContext3D().createVertexBuffer(4,9);
            this.gradientVB.uploadFromVector(gradientVertex,0,4);
            this.gradientIB = context3D.GetContext3D().createIndexBuffer(6);
            this.gradientIB.uploadFromVector(indices,0,6);
         }
         this.shadowTransform(width,height);
      }
      
      private function shadowTransform(width:Number, height:Number) : void
      {
         this.matrix3D.identity();
         var raw:Vector.<Number> = this.matrix3D.rawData;
         raw[4] = -this.shadowMatrix2D.c;
         raw[1] = -this.shadowMatrix2D.b;
         raw[0] = this.shadowMatrix2D.a * 4;
         raw[5] = this.shadowMatrix2D.d * 4;
         raw[12] = this.shadowMatrix2D.tx / width;
         raw[13] = -this.shadowMatrix2D.ty / height;
         this.matrix3D.rawData = raw;
      }
      
      private function transform() : void
      {
         this.matrix3D.identity();
         this.matrix3D.copyRawDataTo(rawMatrix3D);
         rawMatrix3D[4] = -this.matrix2D.c;
         rawMatrix3D[1] = -this.matrix2D.b;
         rawMatrix3D[0] = this.matrix2D.a;
         rawMatrix3D[5] = this.matrix2D.d;
         rawMatrix3D[12] = this.matrix2D.tx;
         rawMatrix3D[13] = -this.matrix2D.ty;
         this.matrix3D.copyRawDataFrom(rawMatrix3D) ;
         this.matrix3D.prependScale(Math.ceil(this.texture.getWidth()),Math.ceil(this.texture.getHeight()),1);
         this.matrix3D.prependTranslation(0.5,-0.5,0);
      }
      
      public function render(c3dProxy:Context3DProxy) : void
      {
         c3dProxy.setProgram(Program3DFactory.getInstance().getProgram(c3dProxy,this.repeat));
         c3dProxy.setTextureAt(0,this.texture);
         var c3d:Context3D = c3dProxy.GetContext3D();
         if(this.vertexBufferCustom != null)
         {
            c3d.setVertexBufferAt(0,this.vertexBufferCustom,0,Context3DVertexBufferFormat.FLOAT_3);
            c3d.setVertexBufferAt(1,this.vertexBufferCustom,3,Context3DVertexBufferFormat.FLOAT_2);
            c3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this.offsetMatrix);
            c3d.setVertexBufferAt(2,null,6,Context3DVertexBufferFormat.FLOAT_2);
            c3dProxy.drawTriangles(this.indexBuffer);
         }
         else
         {
            c3dProxy.setVertexBufferAt(0,this.vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
            c3dProxy.setVertexBufferAt(1,this.vertexBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
            c3d.setProgramConstantsFromVector(Context3DProgramType.VERTEX,4,this.offsetMatrix);
            c3d.setVertexBufferAt(2,null,6,Context3DVertexBufferFormat.FLOAT_2);
            c3dProxy.drawTriangles(this.indexBuffer);
         }
      }
      
      public function renderShadow(c3dProxy:Context3DProxy) : void
      {
         var c3d:Context3D = c3dProxy.GetContext3D();
         c3d.setVertexBufferAt(0,this.gradientVB,0,Context3DVertexBufferFormat.FLOAT_3);
         c3d.setVertexBufferAt(1,this.gradientVB,3,Context3DVertexBufferFormat.FLOAT_4);
         c3d.setVertexBufferAt(2,this.gradientVB,7,Context3DVertexBufferFormat.FLOAT_2);
         c3d.setTextureAt(0,null);
         c3d.drawTriangles(this.gradientIB);
      }
      
      public function getMatrix3D() : Matrix3D
      {
         return this.matrix3D;
      }
   }
}

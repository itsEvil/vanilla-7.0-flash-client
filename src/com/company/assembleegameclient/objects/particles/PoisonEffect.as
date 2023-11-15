package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.util.RandomUtil;
   
   public class PoisonEffect extends ParticleEffect
   {
       
      
      public var go_:GameObject;
      
      public var color_:int;
      
      public function PoisonEffect(go:GameObject, color:int)
      {
         super();
         this.go_ = go;
         this.color_ = color;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         if(this.go_.map_ == null)
         {
            return false;
         }
         x_ = this.go_.x_;
         y_ = this.go_.y_;
         var num:int = 10;
         for(var i:int = 0; i < num; i++)
         {
            map_.addObj(new SparkParticle(100,this.color_,400,0.75,RandomUtil.plusMinus(4),RandomUtil.plusMinus(4)),x_,y_);
         }
         return false;
      }
   }
}

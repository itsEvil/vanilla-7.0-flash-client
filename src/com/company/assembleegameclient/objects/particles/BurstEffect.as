package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.objects.GameObject;
   import flash.geom.Point;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
   
   public class BurstEffect extends ParticleEffect
   {
       
      
      public var center_:Point;
      
      public var edgePoint_:Point;
      
      public var color_:int;
      
      public function BurstEffect(go:GameObject, center:WorldPosData, edgePoint:WorldPosData, color:int)
      {
         super();
         this.center_ = new Point(center.x_,center.y_);
         this.edgePoint_ = new Point(edgePoint.x_,edgePoint.y_);
         this.color_ = color;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var angle:Number = NaN;
         var p:Point = null;
         var part:Particle = null;
         x_ = this.center_.x;
         y_ = this.center_.y;
         var radius:Number = Point.distance(this.center_,this.edgePoint_);
         var SIZE:int = 100;
         var NUMPOINTS:int = 24;
         for(var i:int = 0; i < NUMPOINTS; i++)
         {
            angle = i * 2 * Math.PI / NUMPOINTS;
            p = new Point(this.center_.x + radius * Math.cos(angle),this.center_.y + radius * Math.sin(angle));
            part = new SparkerParticle(SIZE,this.color_,100 + Math.random() * 200,this.center_,p);
            map_.addObj(part,x_,y_);
         }
         return false;
      }
   }
}

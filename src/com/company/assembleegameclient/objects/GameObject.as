package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.engine3d.Model3D;
   import com.company.assembleegameclient.engine3d.Object3D;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.map.Square;
   import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
   import com.company.assembleegameclient.objects.animation.Animations;
   import com.company.assembleegameclient.objects.animation.AnimationsData;
   import com.company.assembleegameclient.objects.particles.ExplosionEffect;
   import com.company.assembleegameclient.objects.particles.HitEffect;
   import com.company.assembleegameclient.objects.particles.ParticleEffect;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.sound.SoundEffectLibrary;
   import com.company.assembleegameclient.util.AnimatedChar;
   import com.company.assembleegameclient.util.BloodComposition;
   import com.company.assembleegameclient.util.ConditionEffect;
   import com.company.assembleegameclient.util.MaskedImage;
   import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import com.company.util.BitmapUtil;
   import com.company.util.CachingColorTransformer;
   import com.company.util.ConversionUtil;
   import com.company.util.GraphicsUtil;
   import com.company.util.MoreColorUtil;
   import com.company.util.PointUtil;
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsGradientFill;
   import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import kabam.rotmg.messaging.impl.data.WorldPosData;
import kabam.rotmg.stage3D.GraphicsFillExtra;
import kabam.rotmg.stage3D.Object3D.Object3DStage3D;

public class GameObject extends BasicObject
   {
      protected static const PAUSED_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);
      public static const ATTACK_PERIOD:int = 500;
      public static const DEFAULT_HP_BAR_Y_OFFSET:int = 5;
      public static const DEFAULT_HP_BAR_HEIGHT:int = 4;
      public static const DEFAULT_HP_BAR_WIDTH:int = 20;
      public static const HITBOX_RADIUS:Number = 0.5;

      public var props_:ObjectProperties;
      public var name_:String;
      public var facing_:Number = 0;
      public var flying_:Boolean = false;
      public var attackAngle_:Number = 0;
      public var attackStart_:int = 0;
      public var animatedChar_:AnimatedChar = null;
      public var texture_:BitmapData = null;
      public var mask_:BitmapData = null;
      public var randomTextureData_:Vector.<TextureData> = null;
      
      public var obj3D_:Object3D = null;
      public var object3d_:Object3DStage3D = null;
      public var effect_:ParticleEffect = null;
      public var animations_:Animations = null;
      protected var portrait_:BitmapData = null;
      protected var texturingCache_:Dictionary = null;
      public var maxHP_:int = 200;
      public var hp_:int = 200;
      public var size_:int = 100;
      public var level_:int = -1;
      public var defense_:int = 0;
      public var slotTypes_:Vector.<int> = null;
      public var equipment_:Vector.<int> = null;
      public var itemDatas_:Vector.<int> = null;
      public var condition_:uint = 0;
      protected var tex1Id_:int = 0;
      protected var tex2Id_:int = 0;
      public var isInteractive_:Boolean = false;
      public var objectType_:int;
      private var sizeMult_:Number = 1;
      public var sinkLevel_:int = 0;
      public var hallucinatingTexture_:BitmapData = null;
      public var flash_:FlashDescription = null;
      public var connectType_:int = -1;
      public var targetPosition_:Point;
      public var direction_:Point;
      public var nameText_:SimpleText = null;
      public var nameBitmapData_:BitmapData = null;
      private var nameFill_:GraphicsBitmapFill = null;
      private var namePath_:GraphicsPath = null;
      protected var bitmapFill_:GraphicsBitmapFill;
      protected var path_:GraphicsPath;
      protected var vS_:Vector.<Number>;
      protected var uvt_:Vector.<Number>;
      protected var fillMatrix_:Matrix;
      private var icons_:Vector.<BitmapData> = null;
      private var iconFills_:Vector.<GraphicsBitmapFill> = null;
      private var iconPaths_:Vector.<GraphicsPath> = null;
      protected var shadowGradientFill_:GraphicsGradientFill = null;
      protected var shadowPath_:GraphicsPath = null;

      private var hpbarBackFill_:GraphicsSolidFill = null;
      private var hpbarBackPath_:GraphicsPath = null;
      private var hpbarFill_:GraphicsSolidFill = null;
      private var hpbarPath_:GraphicsPath = null;
      
      public function GameObject(objectXML:XML)
      {
         var i:int = 0;
         this.props_ = ObjectLibrary.defaultProps_;
         this.targetPosition_ = new Point();
         this.direction_ = new Point();
         this.bitmapFill_ = new GraphicsBitmapFill(null,null,false,false);
         this.path_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,null);
         this.vS_ = new Vector.<Number>();
         this.uvt_ = new Vector.<Number>();
         this.fillMatrix_ = new Matrix();
         super();
         if(objectXML == null)
         {
            return;
         }
         this.objectType_ = int(objectXML.@type);
         this.props_ = ObjectLibrary.propsLibrary_[this.objectType_];
         hasShadow_ = this.props_.shadowSize_ > 0;
         var textureData:TextureData = ObjectLibrary.typeToTextureData_[this.objectType_];
         this.texture_ = textureData.texture_;
         this.mask_ = textureData.mask_;
         this.animatedChar_ = textureData.animatedChar_;
         this.randomTextureData_ = textureData.randomTextureData_;
         if(textureData.effectProps_ != null)
         {
            this.effect_ = ParticleEffect.fromProps(textureData.effectProps_,this);
         }
         if(this.texture_ != null)
         {
            this.sizeMult_ = this.texture_.height / 8;
         }
         if(objectXML.hasOwnProperty("Model"))
         {
            this.obj3D_ = Model3D.getObject3D(String(objectXML.Model));
            this.object3d_ = Model3D.getStage3dObject3D(String(objectXML.Model));
            if (this.texture_ != null) {
               this.object3d_.setBitMapData(this.texture_);
            }
         }
         var animationsData:AnimationsData = ObjectLibrary.typeToAnimationsData_[this.objectType_];
         if(animationsData != null)
         {
            this.animations_ = new Animations(animationsData);
         }
         z_ = this.props_.z_;
         this.flying_ = this.props_.flying_;
         if(objectXML.hasOwnProperty("MaxHitPoints"))
         {
            this.hp_ = this.maxHP_ = int(objectXML.MaxHitPoints);
         }
         if(objectXML.hasOwnProperty("Defense"))
         {
            this.defense_ = int(objectXML.Defense);
         }
         if(objectXML.hasOwnProperty("SlotTypes"))
         {
            this.slotTypes_ = ConversionUtil.toIntVector(objectXML.SlotTypes);
            this.equipment_ = new Vector.<int>(this.slotTypes_.length);
            this.itemDatas_ = new Vector.<int>(this.slotTypes_.length);
            for(i = 0; i < this.equipment_.length; i++)
            {
               this.equipment_[i] = -1;
               this.itemDatas_[i] = -1;
            }
         }
         if(objectXML.hasOwnProperty("Tex1"))
         {
            this.tex1Id_ = int(objectXML.Tex1);
         }
         if(objectXML.hasOwnProperty("Tex2"))
         {
            this.tex2Id_ = int(objectXML.Tex2);
         }
         this.props_.loadSounds();
      }
      
      public static function damageWithDefense(origDamage:int, targetDefense:int, armorPiercing:Boolean, targetCondition:int) : int
      {
         var def:int = targetDefense;
         if(armorPiercing || (targetCondition & ConditionEffect.ARMORBROKEN_BIT) != 0)
         {
            def = 0;
         }
         else if((targetCondition & ConditionEffect.ARMORED_BIT) != 0)
         {
            def = def * 2;
         }
         var min:int = origDamage * 3 / 20;
         var d:int = Math.max(min,origDamage - def);
         if((targetCondition & ConditionEffect.INVULNERABLE_BIT) != 0)
         {
            d = 0;
         }
         return d;
      }
      
      public function setObjectId(objectId:int) : void
      {
         var textureData:TextureData = null;
         objectId_ = objectId;
         if(this.randomTextureData_ != null)
         {
            textureData = this.randomTextureData_[objectId_ % this.randomTextureData_.length];
            this.texture_ = textureData.texture_;
            this.mask_ = textureData.mask_;
            this.animatedChar_ = textureData.animatedChar_;
            if (this.object3d_ != null) {
               this.object3d_.setBitMapData(this.texture_);
            }
         }
      }
      
      public function setAltTexture(altTextureId:int) : void
      {
         var altTextureData:TextureData = null;
         var textureData:TextureData = ObjectLibrary.typeToTextureData_[this.objectType_];
         if(altTextureId == 0)
         {
            altTextureData = textureData;
         }
         else
         {
            altTextureData = textureData.getAltTextureData(altTextureId);
            if(altTextureData == null)
            {
               return;
            }
         }
         this.texture_ = altTextureData.texture_;
         this.mask_ = altTextureData.mask_;
         this.animatedChar_ = altTextureData.animatedChar_;
         if(this.effect_ != null)
         {
            map_.removeObj(this.effect_.objectId_);
            this.effect_ = null;
         }
         if(altTextureData.effectProps_ != null)
         {
            this.effect_ = ParticleEffect.fromProps(altTextureData.effectProps_,this);
            if(map_ != null)
            {
               map_.addObj(this.effect_,x_,y_);
            }
         }
      }
      
      public function setTex1(tex1Id:int) : void
      {
         if(tex1Id == this.tex1Id_)
         {
            return;
         }
         this.tex1Id_ = tex1Id;
         this.texturingCache_ = new Dictionary();
         this.portrait_ = null;
      }
      
      public function setTex2(tex2Id:int) : void
      {
         if(tex2Id == this.tex2Id_)
         {
            return;
         }
         this.tex2Id_ = tex2Id;
         this.texturingCache_ = new Dictionary();
         this.portrait_ = null;
      }
      
      override public function dispose() : void
      {
         var obj:Object = null;
         var bitmapData:BitmapData = null;
         var dict:Dictionary = null;
         var obj2:Object = null;
         var bitmapData2:BitmapData = null;
         super.dispose();
         this.texture_ = null;
         if(this.portrait_ != null)
         {
            this.portrait_.dispose();
            this.portrait_ = null;
         }
         if(this.texturingCache_ != null)
         {
            for each(obj in this.texturingCache_)
            {
               bitmapData = obj as BitmapData;
               if(bitmapData != null)
               {
                  bitmapData.dispose();
               }
               else
               {
                  dict = obj as Dictionary;
                  for each(obj2 in dict)
                  {
                     bitmapData2 = obj2 as BitmapData;
                     if(bitmapData2 != null)
                     {
                        bitmapData2.dispose();
                     }
                  }
               }
            }
            this.texturingCache_ = null;
         }
         if(this.obj3D_ != null)
         {
            this.obj3D_.dispose();
            this.obj3D_ = null;
         }
         if (this.object3d_ != null) {
            this.object3d_.dispose();
            this.object3d_ = null;
         }
         this.slotTypes_ = null;
         this.equipment_ = null;
         this.itemDatas_ = null;
         this.nameText_ = null;
         if(this.nameBitmapData_ != null)
         {
            this.namePath_.data.length = 0;
            this.nameBitmapData_.dispose();
            this.nameBitmapData_ = null;
            this.nameFill_ = null;
            this.namePath_ = null;
         }
         this.bitmapFill_ = null;
         this.path_.commands = null;
         this.path_.data = null;
         this.vS_.length = 0;
         this.uvt_.length = 0;
         this.vS_ = null;
         this.uvt_ = null;
         this.fillMatrix_ = null;
         this.icons_ = null;
         this.iconFills_ = null;
         this.iconPaths_ = null;
         this.shadowGradientFill_ = null;
         if(this.shadowPath_ != null)
         {
            this.shadowPath_.data.length = 0;
            this.shadowPath_.commands = null;
            this.shadowPath_.data = null;
            this.shadowPath_ = null;
         }

         if (this.hpbarPath_ != null)
         {
            this.hpbarPath_.data.length = 0;
            this.hpbarBackPath_.data.length=  0;
            this.hpbarBackFill_ = null;
            this.hpbarBackPath_ = null;
            this.hpbarFill_ = null;
            this.hpbarPath_ = null;
         }
      }
      
      public function isQuiet() : Boolean
      {
         return (this.condition_ & ConditionEffect.QUIET_BIT) != 0;
      }
      
      public function isWeak() : Boolean
      {
         return (this.condition_ & ConditionEffect.WEAK_BIT) != 0;
      }
      
      public function isSlowed() : Boolean
      {
         return (this.condition_ & ConditionEffect.SLOWED_BIT) != 0;
      }
      
      public function isSick() : Boolean
      {
         return (this.condition_ & ConditionEffect.SICK_BIT) != 0;
      }
      
      public function isDazed() : Boolean
      {
         return (this.condition_ & ConditionEffect.DAZED_BIT) != 0;
      }
      
      public function isStunned() : Boolean
      {
         return (this.condition_ & ConditionEffect.STUNNED_BIT) != 0;
      }
      
      public function isBlind() : Boolean
      {
         return (this.condition_ & ConditionEffect.BLIND_BIT) != 0;
      }
      
      public function isDrunk() : Boolean
      {
         return (this.condition_ & ConditionEffect.DRUNK_BIT) != 0;
      }
      
      public function isConfused() : Boolean
      {
         return (this.condition_ & ConditionEffect.CONFUSED_BIT) != 0;
      }
      
      public function isStunImmune() : Boolean
      {
         return (this.condition_ & ConditionEffect.STUN_IMMUNE_BIT) != 0;
      }
      
      public function isInvisible() : Boolean
      {
         return (this.condition_ & ConditionEffect.INVISIBLE_BIT) != 0;
      }
      
      public function isParalyzed() : Boolean
      {
         return (this.condition_ & ConditionEffect.PARALYZED_BIT) != 0;
      }
      
      public function isSpeedy() : Boolean
      {
         return (this.condition_ & ConditionEffect.SPEEDY_BIT) != 0;
      }
      
      public function isHallucinating() : Boolean
      {
         return (this.condition_ & ConditionEffect.HALLUCINATING_BIT) != 0;
      }
      
      public function isHealing() : Boolean
      {
         return (this.condition_ & ConditionEffect.HEALING_BIT) != 0;
      }
      
      public function isDamaging() : Boolean
      {
         return (this.condition_ & ConditionEffect.DAMAGING_BIT) != 0;
      }
      
      public function isBerserk() : Boolean
      {
         return (this.condition_ & ConditionEffect.BERSERK_BIT) != 0;
      }
      
      public function isStasis() : Boolean
      {
         return (this.condition_ & ConditionEffect.STASIS_BIT) != 0;
      }
      
      public function isInvincible() : Boolean
      {
         return (this.condition_ & ConditionEffect.INVINCIBLE_BIT) != 0;
      }
      
      public function isInvulnerable() : Boolean
      {
         return (this.condition_ & ConditionEffect.INVULNERABLE_BIT) != 0;
      }
      
      public function isArmored() : Boolean
      {
         return (this.condition_ & ConditionEffect.ARMORED_BIT) != 0;
      }
      
      public function isArmorBroken() : Boolean
      {
         return (this.condition_ & ConditionEffect.ARMORBROKEN_BIT) != 0;
      }

      public function isTargetable() :Boolean
      {
         return !(isInvincible() || isStasis());
      }
      
      public function isSafe(size:int = 20) : Boolean
      {
         var go:GameObject = null;
         var dx:int = 0;
         var dy:int = 0;
         for each(go in map_.goDict_)
         {
            if(go is Character && go.props_.isEnemy_)
            {
               dx = x_ > go.x_?int(x_ - go.x_):int(go.x_ - x_);
               dy = y_ > go.y_?int(y_ - go.y_):int(go.y_ - y_);
               trace((go as Character).objectType_,dx,dy);
               if(dx < size && dy < size)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      public function getName() : String
      {
         return this.name_ == null || this.name_ == ""?ObjectLibrary.typeToDisplayId_[this.objectType_]:this.name_;
      }
      
      public function getColor() : uint
      {
         return BitmapUtil.mostCommonColor(this.texture_);
      }
      
      public function distTo(pos:WorldPosData) : Number
      {
         var dx:Number = pos.x_ - x_;
         var dy:Number = pos.y_ - y_;
         return Math.sqrt(dx * dx + dy * dy);
      }
      
      override public function addTo(map:Map, x:Number, y:Number) : Boolean
      {
         map_ = map;
         this.targetPosition_.x = x;
         this.targetPosition_.y = y;
         this.direction_.x = 0;
         this.direction_.y = 0;
         if(!this.moveTo(x,y))
         {
            map_ = null;
            return false;
         }
         if(this.effect_ != null)
         {
            map_.addObj(this.effect_,x,y);
         }
         return true;
      }
      
      override public function removeFromMap() : void
      {
         if(this.props_.static_ && square_ != null)
         {
            if(square_.obj_ == this)
            {
               square_.obj_ = null;
            }
            square_ = null;
         }
         if(this.effect_ != null)
         {
            map_.removeObj(this.effect_.objectId_);
         }
         super.removeFromMap();
         this.dispose();
      }
      
      public function moveTo(x:Number, y:Number) : Boolean
      {
         var square:Square = map_.getSquare(x,y);
         if(square == null)
         {
            return false;
         }
         x_ = x;
         y_ = y;
         if(this.props_.static_)
         {
            if(square_ != null)
            {
               square_.obj_ = null;
            }
            square.obj_ = this;
         }
         square_ = square;
         if(this.obj3D_ != null)
         {
            this.obj3D_.setPosition(x_,y_,0,this.props_.rotation_);
         }
         if (this.object3d_ != null)
         {
            this.object3d_.setPosition(x_, y_, 0, this.props_.rotation_);
         }
         return true;
      }
      
      override public function update(time:int, dt:int) : Boolean
      {
         var tickDT:int = 0;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var moving:Boolean = false;
         if(this.direction_.x != 0 || this.direction_.y != 0)
         {
            dx = (direction_.x * dt);
            dy = (direction_.y * dt);

            nx = x_ + dx;
            ny = y_ + dy;

            if ((direction_.x > 0 && nx > targetPosition_.x) ||
                (direction_.x < 0 && nx < targetPosition_.x))
            {
               nx = targetPosition_.x;
               direction_.x = 0;
            }

            if ((direction_.y > 0 && ny > targetPosition_.y) ||
                 (direction_.y < 0 && ny < targetPosition_.y))
            {
               ny = targetPosition_.y;
               direction_.y = 0;
            }

            this.moveTo(nx, ny);
            moving = true;
         }
         if(this.props_.whileMoving_ != null)
         {
            if(!moving)
            {
               z_ = this.props_.z_;
               this.flying_ = this.props_.flying_;
            }
            else
            {
               z_ = this.props_.whileMoving_.z_;
               this.flying_ = this.props_.whileMoving_.flying_;
            }
         }
         return true;
      }
      
      public function onGoto(x:Number, y:Number, time:int) : void
      {
         this.moveTo(x,y);
         this.targetPosition_.x = x;
         this.targetPosition_.y = y;
         this.direction_.x = 0;
         this.direction_.y = 0;
      }
      
      public function onTickPos(x:Number, y:Number) : void
      {
         if (targetPosition_.x == x && targetPosition_.y == y) {
            return;
         }

         this.targetPosition_.x = x;
         this.targetPosition_.y = y;
         this.direction_.x = (this.targetPosition_.x - this.x_) / 127; //magic :)
         this.direction_.y = (this.targetPosition_.y - this.y_) / 127;
      }
      
      public function damage(damageAmount:int, effects:Vector.<uint>, proj:Projectile) : void
      {
         var offsetTime:int = 0;
         var conditionEffect:uint = 0;
         var ce:ConditionEffect = null;
         var pierced:Boolean = false;
         if(effects != null)
         {
            offsetTime = 0;
            for each(conditionEffect in effects)
            {
               ce = null;
               switch(conditionEffect)
               {
                  case ConditionEffect.NOTHING:
                     break;
                  case ConditionEffect.QUIET:
                  case ConditionEffect.WEAK:
                  case ConditionEffect.SLOWED:
                  case ConditionEffect.SICK:
                  case ConditionEffect.DAZED:
                  case ConditionEffect.BLIND:
                  case ConditionEffect.HALLUCINATING:
                  case ConditionEffect.DRUNK:
                  case ConditionEffect.CONFUSED:
                  case ConditionEffect.STUN_IMMUNE:
                  case ConditionEffect.INVISIBLE:
                  case ConditionEffect.PARALYZED:
                  case ConditionEffect.SPEEDY:
                  case ConditionEffect.BLEEDING:
                  case ConditionEffect.STASIS:
                  case ConditionEffect.STASIS_IMMUNE:
                  case ConditionEffect.ARMORBROKEN:
                     ce = ConditionEffect.effects_[conditionEffect];
                     break;
                  case ConditionEffect.STUNNED:
                     if(this.isStunImmune())
                     {
                        map_.mapOverlay_.addStatusText(new CharacterStatusText(this,"Immune",16711680,3000));
                     }
                     else
                     {
                        ce = ConditionEffect.effects_[conditionEffect];
                     }
               }
               if(ce != null)
               {
                  //if((this.condition_ | ce.bit_) != this.condition_)
                  //{
                     //this.condition_ = this.condition_ | ce.bit_; //Applies the effect on the client-side
                     map_.mapOverlay_.addStatusText(new CharacterStatusText(this,ce.name_,16711680,3000,offsetTime));
                     offsetTime = offsetTime + 500;
                  //}
               }
            }
         }
         var colors:Vector.<uint> = BloodComposition.getBloodComposition(this.objectType_,this.texture_,this.props_.bloodProb_,this.props_.bloodColor_);
         if (Parameters.data_.particles && hp_ - damageAmount > 0) {
            if (proj != null) {
               map_.addObj(new HitEffect(colors, this.size_, 10, proj.angle_, proj.projProps_.speed_), x_, y_);
            } else {
               map_.addObj(new ExplosionEffect(colors, this.size_, 10), x_, y_);
            }
         }
         if(damageAmount > 0)
         {
            pierced = this.isArmorBroken() || proj != null && proj.projProps_.armorPiercing_;
            map_.mapOverlay_.addStatusText(new CharacterStatusText(this,"-" + damageAmount,pierced?9437439:16711680,1000));
         }
      }
      
      protected function generateNameText(name:String) : SimpleText
      {
         var nameText:SimpleText = new SimpleText(16,16777215,false,0,0);
         nameText.setBold(true);
         nameText.text = name;
         nameText.updateMetrics();
         return nameText;
      }
      
      protected function generateNameBitmapData(nameText:SimpleText) : BitmapData
      {
         var nameBitmapData:BitmapData = new BitmapData(nameText.width,64,true,0);
         nameBitmapData.draw(nameText,null);
         nameBitmapData.applyFilter(nameBitmapData,nameBitmapData.rect,PointUtil.ORIGIN,new GlowFilter(0,1,3,3,2,1));
         return nameBitmapData;
      }
      
      public function drawName(graphicsData:Vector.<IGraphicsData>, camera:Camera) : void
      {
         if(this.nameBitmapData_ == null)
         {
            this.nameText_ = this.generateNameText(this.name_);
            this.nameBitmapData_ = this.generateNameBitmapData(this.nameText_);
            this.nameFill_ = new GraphicsBitmapFill(null,new Matrix(),false,false);
            this.namePath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
         }
         var w:int = this.nameBitmapData_.width / 2 + 1;
         var h:int = 30;
         var nameVSs:Vector.<Number> = this.namePath_.data;
         nameVSs.length = 0;
         nameVSs.push(posS_[0] - w,posS_[1],posS_[0] + w,posS_[1],posS_[0] + w,posS_[1] + h,posS_[0] - w,posS_[1] + h);
         this.nameFill_.bitmapData = this.nameBitmapData_;
         var m:Matrix = this.nameFill_.matrix;
         m.identity();
         m.translate(nameVSs[0],nameVSs[1]);
         graphicsData.push(this.nameFill_);
         graphicsData.push(this.namePath_);
         graphicsData.push(GraphicsUtil.END_FILL);
      }
      
      protected function getHallucinatingTexture() : BitmapData
      {
         if(this.hallucinatingTexture_ == null)
         {
            this.hallucinatingTexture_ = AssetLibrary.getImageFromSet("lofiChar8x8",int(Math.random() * 239));
         }
         return this.hallucinatingTexture_;
      }
      
      protected function getTexture(camera:Camera, time:int) : BitmapData
      {
         var p:Number = NaN;
         var action:int = 0;
         var image:MaskedImage = null;
         var walkPer:int = 0;
         var animTexture:BitmapData = null;
         var w:int = 0;
         var newTexture:BitmapData = null;
         var texture:BitmapData = this.texture_;
         var size:int = this.size_;
         var mask:BitmapData = null;
         if(this.animatedChar_ != null)
         {
            p = 0;
            action = AnimatedChar.STAND;
            if(time < this.attackStart_ + ATTACK_PERIOD)
            {
               if(!this.props_.dontFaceAttacks_)
               {
                  this.facing_ = this.attackAngle_;
               }
               p = (time - this.attackStart_) % ATTACK_PERIOD / ATTACK_PERIOD;
               action = AnimatedChar.ATTACK;
            }
            else if(this.direction_.x != 0 || this.direction_.y != 0)
            {
               walkPer = 0.5 / (this.direction_.length * 4);
               walkPer = walkPer + (400 - walkPer % 400);
               if(this.direction_.x != 0 || this.direction_.y != 0)
               {
                  this.facing_ = Math.atan2(this.direction_.y,this.direction_.x);
                  action = AnimatedChar.WALK;
               }
               else
               {
                  action = AnimatedChar.STAND;
               }
               p = time % walkPer / walkPer;
            }
            image = this.animatedChar_.imageFromFacing(this.facing_,camera,action,p);
            texture = image.image_;
            mask = image.mask_;
         }
         else if(this.animations_ != null)
         {
            animTexture = this.animations_.getTexture(time);
            if(animTexture != null)
            {
               texture = animTexture;
            }
         }
         if(this.props_.drawOnGround_ || this.obj3D_ != null)
         {
            return texture;
         }
         if(camera.isHallucinating_)
         {
            w = texture == null?int(8):int(texture.width);
            texture = this.getHallucinatingTexture();
            mask = null;
            size = this.size_ * Math.min(1.5,w / texture.width);
         }
         if(this.isStasis())
         {
            texture = CachingColorTransformer.filterBitmapData(texture,PAUSED_FILTER);
         }
         if(this.tex1Id_ == 0 && this.tex2Id_ == 0)
         {
            texture = TextureRedrawer.redraw(texture,size,false,0);
         }
         else
         {
            newTexture = null;
            if(this.texturingCache_ == null)
            {
               this.texturingCache_ = new Dictionary();
            }
            else
            {
               newTexture = this.texturingCache_[texture];
            }
            if(newTexture == null)
            {
               newTexture = TextureRedrawer.resize(texture,mask,size,false,this.tex1Id_,this.tex2Id_);
               newTexture = GlowRedrawer.outlineGlow(newTexture,0);
               this.texturingCache_[texture] = newTexture;
            }
            texture = newTexture;
         }
         return texture;
      }
      
      public function useAltTexture(file:String, index:int) : void
      {
         this.texture_ = AssetLibrary.getImageFromSet(file,index);
         this.sizeMult_ = this.texture_.height / 8;
      }
      
      public function getPortrait() : BitmapData
      {
         var portraitTexture:BitmapData = null;
         var size:int = 0;
         if(this.portrait_ == null)
         {
            portraitTexture = this.props_.portrait_ != null?this.props_.portrait_.getTexture():this.texture_;
            size = 4 / portraitTexture.width * 100;
            this.portrait_ = TextureRedrawer.resize(portraitTexture,this.mask_,size,true,this.tex1Id_,this.tex2Id_);
            this.portrait_ = GlowRedrawer.outlineGlow(this.portrait_,0,0);
         }
         return this.portrait_;
      }
      
      public function setAttack(containerType:int, attackAngle:Number) : void
      {
         this.attackAngle_ = attackAngle;
         this.attackStart_ = getTimer();
      }

      protected function drawHpBar(graphicsData:Vector.<IGraphicsData>, yOffset:int = 6) : void
      {
         var fPerc:Number = NaN;
         var bw:Number = NaN;
         var isPlayer:Boolean = props_.isPlayer_;
         if(this.hpbarPath_ == null)
         {
            this.hpbarBackFill_ = new GraphicsSolidFill();
            this.hpbarBackPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
            this.hpbarFill_ = new GraphicsSolidFill();
            this.hpbarPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
            this.hpbarBackFill_.color = 5526612;
            this.hpbarFill_.color = 1113856;
         }

         var sw:int = size_ / 4;
         var w:int = isPlayer ? DEFAULT_HP_BAR_WIDTH : (sw < 25) ? 25 : sw;
         var h:int = isPlayer ? DEFAULT_HP_BAR_HEIGHT : 3;
         this.hpbarBackPath_.data.length = 0;
         this.hpbarBackPath_.data.push(posS_[0] - w,posS_[1] + yOffset,posS_[0] + w,posS_[1] + yOffset,posS_[0] + w,posS_[1] + yOffset + h,posS_[0] - w,posS_[1] + yOffset + h);

         graphicsData.push(this.hpbarBackFill_);
         graphicsData.push(this.hpbarBackPath_);
         graphicsData.push(GraphicsUtil.END_FILL);

         if(this.hp_ > 0)
         {
            fPerc = this.hp_ / this.maxHP_;
            bw = fPerc * 2 * w;
            this.hpbarPath_.data.length = 0;
            this.hpbarPath_.data.push(posS_[0] - w,posS_[1] + yOffset,posS_[0] - w + bw,posS_[1] + yOffset,posS_[0] - w + bw,posS_[1] + yOffset + h,posS_[0] - w,posS_[1] + yOffset + h);

            graphicsData.push(this.hpbarFill_);
            graphicsData.push(this.hpbarPath_);
            graphicsData.push(GraphicsUtil.END_FILL);
         }
         GraphicsFillExtra.setSoftwareDrawSolid(this.hpbarFill_,true);
         GraphicsFillExtra.setSoftwareDrawSolid(this.hpbarBackFill_,true);
      }

      override public function draw3d(graphicsData3d:Vector.<Object3DStage3D>) : void
      {
         if(this.object3d_ != null)
         {
            graphicsData3d.push(this.object3d_);
         }
      }

      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         var texture:BitmapData = this.getTexture(camera,time);
         if(this.props_.drawOnGround_)
         {
            if(square_.faces_.length == 0)
            {
               return;
            }
            this.path_.data = square_.faces_[0].face_.vout_;
            this.bitmapFill_.bitmapData = texture;
            square_.baseTexMatrix_.calculateTextureMatrix(this.path_.data);
            this.bitmapFill_.matrix = square_.baseTexMatrix_.tToS_;
            graphicsData.push(this.bitmapFill_);
            graphicsData.push(this.path_);
            graphicsData.push(GraphicsUtil.END_FILL);
            return;
         }
         if(this.obj3D_ != null)
         {
            if(!Parameters.GPURenderFrame)
            {
               this.obj3D_.draw(graphicsData,camera,this.props_.color_,texture);
               return;
            }
            else
            {
               graphicsData.push(null);
               return;
            }
         }
         var w:int = texture.width;
         var h:int = texture.height;
         var h2:int = square_.sink_ + this.sinkLevel_;
         if(h2 > 0 && (this.flying_ || square_.obj_ != null && square_.obj_.props_.protectFromSink_))
         {
            h2 = 0;
         }
         if(Parameters.GPURenderFrame)
         {
            if(h2 != 0)
            {
               GraphicsFillExtra.setSinkLevel(this.bitmapFill_,Math.max(((h2 / h) * 1.65) - 0.02,0));
               h2 = -h2 + 0.02;
            }
            else if(h2 == 0 && GraphicsFillExtra.getSinkLevel(this.bitmapFill_) != 0)
            {
               GraphicsFillExtra.clearSink(this.bitmapFill_);
            }
         }
         this.vS_.length = 0;
         this.vS_.push(posS_[3] - w / 2,posS_[4] - h + h2,posS_[3] + w / 2,posS_[4] - h + h2,posS_[3] + w / 2,posS_[4],posS_[3] - w / 2,posS_[4]);
         this.path_.data = this.vS_;

         if(this.flash_ != null)
         {
            if(!this.flash_.doneAt(time))
            {
               if(Parameters.GPURenderFrame)
               {
                  this.flash_.applyGPUTextureColorTransform(texture,time);
               }
               else
               {
                  texture = this.flash_.apply(texture,time);
               }
            }
            else
            {
               this.flash_ = null;
            }
         }

         this.bitmapFill_.bitmapData = texture;
         this.fillMatrix_.identity();
         this.fillMatrix_.translate(this.vS_[0],this.vS_[1]);
         this.bitmapFill_.matrix = this.fillMatrix_;
         graphicsData.push(this.bitmapFill_);
         graphicsData.push(this.path_);
         graphicsData.push(GraphicsUtil.END_FILL);
         if(this.condition_)
         {
            this.drawConditionIcons(graphicsData,camera,time);
         }
         if(this.props_.showName_ && this.name_ != null && this.name_.length != 0)
         {
            this.drawName(graphicsData,camera);
         }

         if(Parameters.data_.hpBars)
         {
            var bDrawHpBar:Boolean = this.props_ && (this.props_.isEnemy_ || this.props_.isPlayer_) && !this.isInvincible() && (this.props_.isPlayer_ || !this.isInvulnerable()) && !this.props_.noMiniMap_;

            if (bDrawHpBar)
            {
               this.drawHpBar(graphicsData,
           (this.props_.isPlayer_ && this != map_.player_ ? 16 : 0) + DEFAULT_HP_BAR_Y_OFFSET);
            }
         }
      }
      
      public function drawConditionIcons(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         var icon:BitmapData = null;
         var fill:GraphicsBitmapFill = null;
         var path:GraphicsPath = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var m:Matrix = null;
         if(this.icons_ == null)
         {
            this.icons_ = new Vector.<BitmapData>();
            this.iconFills_ = new Vector.<GraphicsBitmapFill>();
            this.iconPaths_ = new Vector.<GraphicsPath>();
         }
         this.icons_.length = 0;
         var index:int = time / 500;
         ConditionEffect.getConditionEffectIcons(this.condition_,this.icons_,index);
         var centerX:Number = posS_[3];
         var centerY:Number = this.vS_[1];
         var len:int = this.icons_.length;
         for(var i:int = 0; i < len; i++)
         {
            icon = this.icons_[i];
            if(i >= this.iconFills_.length)
            {
               this.iconFills_.push(new GraphicsBitmapFill(null,new Matrix(),false,false));
               this.iconPaths_.push(new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>()));
            }
            fill = this.iconFills_[i];
            path = this.iconPaths_[i];
            fill.bitmapData = icon;
            x = centerX - icon.width * len / 2 + i * icon.width;
            y = centerY - icon.height / 2;
            path.data.length = 0;
            path.data.push(x,y,x + icon.width,y,x + icon.width,y + icon.height,x,y + icon.height);
            m = fill.matrix;
            m.identity();
            m.translate(x,y);
            graphicsData.push(fill);
            graphicsData.push(path);
            graphicsData.push(GraphicsUtil.END_FILL);
         }
      }
      
      override public function drawShadow(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         if(this.shadowGradientFill_ == null)
         {
            this.shadowGradientFill_ = new GraphicsGradientFill(GradientType.RADIAL,[this.props_.shadowColor_,this.props_.shadowColor_],[0.5,0],null,new Matrix());
            this.shadowPath_ = new GraphicsPath(GraphicsUtil.QUAD_COMMANDS,new Vector.<Number>());
         }
         var s:Number = this.size_ / 100 * (this.props_.shadowSize_ / 100) * this.sizeMult_;
         var w:Number = 30 * s;
         var h:Number = 15 * s;
         this.shadowGradientFill_.matrix.createGradientBox(w * 2,h * 2,0,posS_[0] - w,posS_[1] - h);
         graphicsData.push(this.shadowGradientFill_);
         this.shadowPath_.data.length = 0;
         this.shadowPath_.data.push(posS_[0] - w,posS_[1] - h,posS_[0] + w,posS_[1] - h,posS_[0] + w,posS_[1] + h,posS_[0] - w,posS_[1] + h);
         graphicsData.push(this.shadowPath_);
         graphicsData.push(GraphicsUtil.END_FILL);
      }
      
      public function toString() : String
      {
         return "[" + getQualifiedClassName(this) + " id: " + objectId_ + " type: " + ObjectLibrary.typeToDisplayId_[this.objectType_] + " pos: " + x_ + ", " + y_ + "]";
      }
   }
}

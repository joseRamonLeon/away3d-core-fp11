package 
{
	import a3dparticle.animators.actions.acceleration.AccelerateGlobal;
	import a3dparticle.animators.actions.color.ChangeColorByLifeGlobal;
	import a3dparticle.animators.actions.position.OffestPositionLocal;
	import a3dparticle.animators.actions.velocity.VelocityLocal;
	import a3dparticle.generater.SingleGenerater;
	import a3dparticle.particle.ParticleColorMaterial;
	import a3dparticle.particle.ParticleParam;
	import a3dparticle.particle.ParticleSample;
	import a3dparticle.ParticlesContainer;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.primitives.SphereGeometry;
	import away3d.primitives.WireframeAxesGrid;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author liaocheng
	 */
	[SWF(width="1024", height="768", frameRate="60")]
	public class Main extends Sprite 
	{
		protected var _view:View3D;
		
		private var particle:ParticlesContainer;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			// entry point
			_view = new View3D();
			_view.width = 1024;
			_view.height = 768;
			_view.antiAlias = 4;
			addChild(_view);
			addEventListener(Event.ENTER_FRAME, onRender);
			addChild(new AwayStats(_view));
			new HoverDragController(_view.camera, stage);
			_view.scene.addChild(new WireframeAxesGrid(4,1000));
			initScene();
		}
		
		
		private function initScene():void
		{
			var material:ParticleColorMaterial = new ParticleColorMaterial();
			var sphere:SphereGeometry = new SphereGeometry( 5, 6, 6);
			var sample:ParticleSample = new ParticleSample(sphere.subGeometries[0], material);
			
			var generater:SingleGenerater = new SingleGenerater(sample, 800);
			
			particle = new ParticlesContainer();
			particle.loop = true;
			
			
			var action:VelocityLocal = new VelocityLocal();
			particle.addAction(action);
			
			var action2:AccelerateGlobal = new AccelerateGlobal(new Vector3D(0, -500, 0));
			particle.addAction(action2);
			
			var action3:OffestPositionLocal = new OffestPositionLocal();
			particle.addAction(action3);
			
			var action4:ChangeColorByLifeGlobal = new ChangeColorByLifeGlobal(new ColorTransform(0.7,0.9,1,0.5),new ColorTransform(0.9,1,1,0.3) );
			particle.addAction(action4);
			
			particle.initParticleFun = initParticleParam;
			particle.generate(generater);
			particle.start();
			_view.scene.addChild(particle);
			
			var clone:ParticlesContainer;
			for (var i:int = 0; i < 5; i++)
			{
				clone = particle.clone() as ParticlesContainer;
				clone.time = i * 0.1;
				clone.start();
				_view.scene.addChild(clone);
			}
		}
		
		private function initParticleParam(param:ParticleParam):void
		{
			param.startTime = Math.random() * 3;
			param.duringTime = 2.7;
			var degree:Number = Math.random() * 360;
			var cos:Number = Math.cos(degree);
			var sin:Number = Math.sin(degree);
			var r:Number = 700;
			var r2:Number = Math.random() * 10;
			var degree1:Number = Math.random() * Math.PI * 2;
			var degree2:Number = Math.PI *80/ 180 + Math.random() * Math.PI* 5/ 180;
			
			param["VelocityLocal"] = new Vector3D(r * Math.sin(degree1) * Math.cos(degree2), r * Math.sin(degree2), r * Math.cos(degree1) * Math.cos(degree2));
			param["OffestPositionLocal"] = new Vector3D(r2 * cos, 0, r2 * sin);
		}

		
		private function onRender(e:Event):void
		{
			_view.render();
		}
		private function onStageResize(e:Event):void
		{
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
		
	}
	
}
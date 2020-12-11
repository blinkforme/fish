package manager
{
    import laya.display.Sprite;
    import laya.net.Loader;
    import laya.particle.Particle2D;
    import laya.particle.ParticleSetting;
    import laya.utils.Handler;

    public class GameParticle extends Sprite
    {
        private var _particle:Particle2D = null;
        private var _setting:ParticleSetting = null;

        public function GameParticle(name:String)
        {
            Laya.loader.load(name, Handler.create(this, onAssetsLoaded), null, Loader.JSON);
        }

        private function onAssetsLoaded(settings:ParticleSetting):void
        {
            _setting = settings;
            replay();

        }

        public function replay():void
        {
            if (_setting && !_particle)
            {
                _particle = new Particle2D(_setting);
                _particle.emitter.start();
                _particle.play();
                this.addChild(_particle);
            }
        }

        public function stop():void
        {
            if (_particle)
            {
                _particle.removeSelf();
//                _particle.destroy(true);
                _particle = null;
            }
        }

    }
}

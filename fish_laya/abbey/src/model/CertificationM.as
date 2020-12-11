package model
{
    import struct.*;

    import conf.cfg_commodity;

    import emurs.ShowType;

    import manager.GameConst;
    import manager.UiManager;
    import manager.WebSocketManager;

    import model.LoginInfoM;
    import model.LoginM;
    import model.RoleInfoM;

    public class CertificationM
    {
        private static var _instance:CertificationM;

        private var _info:CertificationInfo;

        public static function get instance():CertificationM
        {
            return _instance || (_instance = new CertificationM());
        }

        public function CertificationM()
        {

        }

        public function isOpenCertification():Boolean
        {
            if (ENV.isNeedCertification())
            {
                if (!RoleInfoM.instance.is_bind_tel || !LoginM.instance.isCompleteCertification)
                {
                    return true
                }
            }
            return false;
        }

        public function OpenCertification():void
        {
            if (ENV.branchSwitch("certification"))
            {
//                if (!RoleInfoM.instance.is_bind_tel || _info.openFrom == GameConst.from_bank)
//                {
//                    WebSocketManager.instance.send(33012, {is_show_tip:1});
//                } else
//                {
                    UiManager.instance.loadView("Certification", null, ShowType.SMALL_TO_BIG);
//                }
            }
        }

        public function get info():CertificationInfo
        {
            return _info;
        }

        public function set info(value:CertificationInfo):void
        {
            _info = value;
        }
    }
}

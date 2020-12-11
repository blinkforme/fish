package struct
{
    import conf.cfg_commodity;

    import model.LoginInfoM;
    import model.LoginM;
    import model.RoleInfoM;

    public class CertificationInfo
    {
        public var quitInfo:QuitTipInfo;

        public var buyInfo:cfg_commodity;

        //login  shop  main  month  Gift
        public var openFrom:String;

        public var realForciblySwithState:Number = LoginInfoM.instance.openCertification;

        public var realState:Number = LoginM.instance.isCompleteCertification;

        public var bindState:Number = RoleInfoM.instance.is_bind_tel;

        public var ageState:Number = LoginInfoM.instance.ageType;
    }
}

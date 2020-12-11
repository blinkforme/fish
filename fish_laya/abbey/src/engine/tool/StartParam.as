package engine.tool
{
    import control.WxC;

    public class StartParam
    {

        private static var _instance:StartParam;


        public var config = {};

        /**
         * 初始化启动参数
         * require:   true:不可被默认值代替   false:可被默认值代替
         * default:   设置默认值，未携带参数则用默认值代替
         * name:   参数名称
         *
         * 举例:  player: {"require": false, "default": "xiaoliang1", "name": "player"}
         */

        public function StartParam()
        {

        }


        public var params = {}

        public function paramIsValid(param, config):Boolean
        {
            if (config["require"])
            {
                if (!param)
                {
                    console.log(config["name"] + " is required")
                    return false
                }
            }
            return true
        }

        public function setConfig(res:Object):void
        {
            config = res;
        }

        public function isEmpty(obj:*):Boolean
        {

            if (typeof obj == "Boolean")
            {
                return false;
            }

            if (obj != null && obj != "undefined")
            {
                return false
            }

            return true;
        }


        public function getParam(name:String):*
        {
            if (!isEmpty(params[name]))
            {
                return params[name]
            }else
            {
                return null;
            }
        }


        public function parseParam(kv:Object, isFirst:Boolean = false):void
        {
            if (isFirst)
            {
                for (var param_key in config)
                {
                    var conf = config[param_key]
                    var value = kv[param_key]
                    var isValid:Boolean = paramIsValid(value, conf)

                    if (isValid)
                    {
                        if (value == "" || value == null || value == "undefined")
                        {
                            kv[param_key] = conf["default"]
                        }
                    } else
                    {
                        console.log("param error")
                    }
                }
            }

            for (var i in kv)
            {
                params[i] = kv[i]
            }
        }


        //解析HTML参数
        public function parseHtmlParamString():void
        {
            var kv = {};
            if (!WxC.isInMiniGame())
            {
                var url = __JS__("window.document.location.href.toString()")
                var u = url.split("?");
                if (u[1])
                {
                    u = u[1].split("&");

                    for (var i in u)
                    {
                        var j = u[i].split("=");
                        kv[j[0]] = j[1];
                    }
                }
            }
            parseParam(kv, true)
        }

        public function getQueryString(name):any
        {
            var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
            var r = Laya.Browser.window.location.search.substr(1).match(reg);
            if(r!=null)
                return r[2];     //注意这里不能用js里面的unescape方法
            return null;
        }


        public static function get instance():StartParam
        {
            return _instance || (_instance = new StartParam());
        }
    }
}
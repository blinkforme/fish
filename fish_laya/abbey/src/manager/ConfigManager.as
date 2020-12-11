package manager
{
    import control.WxC;

    import conf.manifest;

    import engine.tool.StartParam;

    public class ConfigManager
    {
        public function ConfigManager()
        {

        }

        public static var allConfigPath:String = "res/config/config.json";
        public static var secondConfigPath:String = "res/config/second_config.json";
        public static var allConfigPathMini:String = "res/config/config.json";


        public static var sheet_cache:Object = {};

        public static function getConfigPath():String
        {
            if (WxC.isInMiniGame())
            {
                return StartParam.instance.getParam("config_version");
            }
            return allConfigPath;
        }

        public static function getSecondConfigPath():String
        {
            if (WxC.isInMiniGame())
            {
                return StartParam.instance.getParam("second_config_version");
            }
            return secondConfigPath;
        }

        public static function getClazzBySheetName(sheetName:String):Object
        {
            return manifest.cfg_names[sheetName]
        }

        public static function getConfBySheet(sheetName:String):Object
        {
//            console.log("getConfBySheet 获取配表 =======>>> ",  sheetName)
            return sheet_cache[sheetName];
        }

        public static function init():void
        {
            var dicRes:Object;
            if (WxC.isInMiniGame())
            {
                dicRes = Laya.loader.getRes(StartParam.instance.getParam("config_version"));
            }
            else
            {
                dicRes = Laya.loader.getRes(allConfigPath);
            }
            _initByRes(dicRes);
        }

        public static function initSecond():void
        {
            if (sheet_cache.length >= manifest.cfg_names.length) return;
            var dicRes:Object;
            if (WxC.isInMiniGame())
            {
                dicRes = Laya.loader.getRes(StartParam.instance.getParam("config_version"));
            }
            else
            {
                dicRes = Laya.loader.getRes(secondConfigPath);
            }
            _initByRes(dicRes);
        }


        private static function _initByRes(dicRes:Object) {
            for (var sheetName:String in manifest.cfg_names)
            {
                var a:Object = {};
                var sheetDicRes:Object = dicRes[sheetName];

                if (sheetDicRes){
                    var cfg:Object = getClazzBySheetName(sheetName);
                    for (var key:String in sheetDicRes)
                    {

                        a[key] = cfg.init(sheetDicRes[key])
                    }
                    sheet_cache[sheetName] = a
                }
            }
        }


        public static function getConfObject(sheetName:String, id:*):Object
        {
//            console.log("getConfObject 获取配表 =======>>> ",  sheetName)
            return sheet_cache[sheetName][id];
        }

        public static function getConfValue(sheetName:String, id:*, name:String):Object
        {
//            console.log("getConfValue 获取配表=======>>> ", sheetName, id, name);
            return sheet_cache[sheetName][id][name];
        }

        public static function items(cfg_name:String):Array
        {
//            console.log("items 获取配表=======>>> ",  cfg_name)
            var cfgs:Object = sheet_cache[cfg_name]
            var arr:Array = []
            for (var i in cfgs)
            {
                arr.push(cfgs[i])
            }
            return arr
        }

        public static function filter(cfg_name:String, func:Function, func_sort:Function = null):Array
        {
            var items:Array = ConfigManager.items(cfg_name);

            if (!func)
            {
                return items;
            }
            var arr:Array = [];
            for (var i in items)
            {
                if (func(items[i]))
                {
                    arr.push(items[i])
                }
            }
            if (func_sort)
            {
                arr.sort(func_sort)
            }
            return arr
        }

        public static function groupby(cfg_name:String, field:Object):Object
        {
            var items:Array = ConfigManager.items(cfg_name);
            var d:Object = {};

            for (var i in items)
            {
                var item = items[i];

                var value = item[field];
                if (d[value] === undefined)
                {
                    d[value] = [];
                }
                d[value].push(item)
            }
            return d;
        }

    }

}

package manager
{

    import control.WxC;

    import engine.tool.StartParam;

    import model.LoginInfoM;

    import laya.events.Event;
    import laya.net.HttpRequest;
    import laya.utils.Handler;

    /**
     * ...
     * @author peter
     */
    public class ApiManager
    {
        public var API_URL:String;
        public var API_PORT:String
        private var _handler:Handler;
        private var _handlerTwo:Handler;


        private static var _instance:ApiManager;

        public function ApiManager()
        {

        }

        public static function get instance():ApiManager
        {
            return _instance || (_instance = new ApiManager());
        }

        private function base_request(url, params, method, cb):Object
        {

            var request:HttpRequest = new HttpRequest();
            var FULL_URL:String = "";
            var preStr:String = "";
            if (API_URL.substr(0, 6) != "https:")
            {
                preStr = "https://";
            }
            if (API_PORT && API_PORT.length > 0)
            {
                FULL_URL = preStr + API_URL + ":" + API_PORT + url;
            } else
            {
                FULL_URL = preStr + API_URL + url;
            }

            request.send(FULL_URL, params, method, 'json')

            request.once(Event.COMPLETE, this, function (data)
            {
                cb(request.data)

            });
            return null;
        }

        public function basehttp(url:String, params:String, method:String, handler:Handler, handlerTwo:Handler):void
        {
            _handler = handler;
            _handlerTwo = handlerTwo;
            var request:HttpRequest = new HttpRequest();
            var FULL_URL:String = "";
            var preStr:String = "";
            if (API_URL.substr(0, 6) != "https:")
            {
                preStr = "https://";
            }
            if (API_PORT && API_PORT.length > 0)
            {
                FULL_URL = preStr + API_URL + ":" + API_PORT + url;
            } else
            {
                FULL_URL = preStr + API_URL + url;
            }
            request.send(FULL_URL, params, method, 'json');
            request.once(Event.COMPLETE, this, complete, [handler]);
            request.once(Event.ERROR, this, error);
        }

        public function basehttpts(url:String, params:String, method:String, handler:Handler, handlerTwo:Handler):void
        {
            _handler = handler;
            _handlerTwo = handlerTwo;
            var request:HttpRequest = new HttpRequest();
            var FULL_URL:String = "";
            var preStr:String = "";
            if (ENV.MINI_API_URL.substr(0, 6) != "https:")
            {
                preStr = "https://";
            }
            if (API_PORT && API_PORT.length > 0)
            {
                FULL_URL = preStr + ENV.MINI_API_URL + ":" + API_PORT + url;
            } else
            {
                FULL_URL = preStr + ENV.MINI_API_URL + url;
            }
            request.send(FULL_URL, params, method, 'json');
            request.once(Event.COMPLETE, this, complete, [handler]);
            request.once(Event.ERROR, this, error);
        }

        public function baseBreachHttps(url:String, params:String, method:String, handler:Handler, handlerTwo:Handler):void
        {
            _handler = handler;
            _handlerTwo = handlerTwo;
            var request:HttpRequest = new HttpRequest();

            request.send(url, params, method, 'json');
            request.once(Event.COMPLETE, this, complete, [handler]);
            request.once(Event.ERROR, this, error);
        }

        private function error(msg:Object):void
        {
            if (_handlerTwo != null)
            {
                _handlerTwo.runWith(msg);
            }

        }

        private function complete(handler:Handler, msg:Object):void
        {
            handler.runWith(msg);
        }

        //---渠道方接口
        public function exitGame(access_token, h1:Handler, h2:Handler = null):Object
        {
            var access_token = access_token
            var r_url:String = "/foreign/pf_close_window?key="+StartParam.instance.getParam("key")+"&access_token="+access_token;
            var method:String = "get";
            var params:String = "";
            basehttp(r_url, params, method, h1, h2)
            return null;
        }

        public function buyCommodity(sonBoxId:Number,h1:Handler, h2:Handler = null):Object
        {
            var pn = StartParam.instance.getParam("pn")
            var vno = StartParam.instance.getParam("vno")
            var params = "sonBoxId=" + sonBoxId + "&pn=" + pn + "&vno=" + vno;
            var r_url:String = "/foreign/pf_shop_list?" + params;
            var method:String = "get";
            basehttp(r_url, "", method, h1, h2)
            return null;
        }

        public function get_rank_list(token, cb):Object
        {
            var r_url:String = "/collect/top";
            var method:String = "post";
            var params:String = "access_token=" + token
            base_request(r_url, params, method, cb)
            return null;
        }

        public function get_announce(type:String, cb:Handler, cc:Handler = null, server_name = 0):Object
        {
            var r_url:String = "/collect/announce";
            var method:String = "post";
            var params:String = "game_key=2d65b80bdb3f91cf30715258017d8343&type=" + type + "&server_name=" + server_name + "&provider_id=" + StartParam.instance.getParam("provider_id");

            basehttp(r_url, params, method, cb, cc)
            return null;
        }

        public function readPrivacyAgreement(access_token:String, cb:Handler, cc:Handler = null):Object
        {
            var r_url:String = "/foreign/read_privacy_agreement";
            var method:String = "post";
            var params:String = "access_token=" + access_token

            basehttp(r_url, params, method, cb, cc)
            return null;
        }

        public function getPrivacyAgreement(h1:Handler, h2:Handler = null):Object
        {
            var r_url:String = "/foreign/privacy_agreement";
            var method:String = "get";
            var params:String = ""

            basehttpts(r_url, params, method, h1, h2)
            return null;
        }


        public function login(params, cb)
        {
            var r_url:String = "/collect/user/third_login";
            var method:String = "post";
            base_request(r_url, params, method, cb)
        }

        public function wxminiLogin(params, cb:Handler, errorCb:Handler):void
        {
            var r_url:String = "/wxmini_login_v2";//?" + params;
            var method:String = "post";
            basehttp(r_url, params, method, cb, errorCb)
        }

        public function exchangeList(access_token:String, coin_type, cb):void
        {
            var r_url:String = "/collect/exchange_item?access_token=" + access_token + "&coin_type=" + coin_type;
            var method:String = "get";
            base_request(r_url, {}, method, cb)
        }

        public function exchange(access_token:String, item_id:Number, phone:String, h1:Handler, h2:Handler):void
        {
            var r_url:String = "/collect/exchange";
            var method:String = "post";
            var params:String = "access_token=" + access_token + "&item_id=" + item_id + "&phone=" + phone

            basehttp(r_url, params, method, h1, h2)
        }


        public function shareInfo(access_token:String, h1:Handler, h2:Handler):void
        {
            var params:String = "access_token=" + access_token
            var r_url:String = "/collect/wxmini/shared_info?" + params;
            var method:String = "get";
            basehttp(r_url, "", method, h1, h2)
        }


        public function getShareInfo(access_token:String, inviteId:Number, h1:Handler, h2:Handler):void
        {
            var r_url:String = "/collect/wxmini/share_invite";
            var method:String = "post";
            var params:String = "access_token=" + access_token + "&invite_user_uid=" + inviteId;
            basehttp(r_url, params, method, h1, h2)
        }


        public function exchangeRecords(access_token:String, coin_type:String, h1:Handler, h2:Handler):void
        {
            var r_url:String = "/collect/exchange_record";
            var method:String = "post";
            var params:String = "access_token=" + access_token + "&coin_type=" + coin_type

            basehttp(r_url, params, method, h1, h2)
        }

        public function queryUserName(access_token:String, uid:Number, h1:Handler, h2:Handler):void
        {
            var r_url:String = "/collect/find_user";
            var method:String = "post";
            var params:String = "access_token=" + access_token + "&uid=" + uid

            basehttp(r_url, params, method, h1, h2)
        }

        public function userSubscribe(access_token:String, tpls:String, h1:Handler, h2:Handler):void
        {
            var r_url:String = "/foreign/subscribe/user";
            var method:String = "post";
            var params:String = "access_token=" + access_token + "&tpls=" + tpls;

            basehttp(r_url, params, method, h1, h2)
        }

        public function giftList(access_token:String, page:Number, h1:Handler, h2:Handler):void
        {
            var params:String = "access_token=" + access_token + "&page=" + page;
            var r_url:String = "/collect/send_list?" + params;
            var method:String = "get";
            basehttp(r_url, "", method, h1, h2)
        }

        public function get_user_sub(access_token:String, h1:Handler, h2:Handler):void
        {
            var params:String = "access_token=" + access_token;
            var r_url:String = "/foreign/subscribe/user_tpl?" + params;
            var method:String = "get";
            basehttp(r_url, "", method, h1, h2)
        }


        public function get_boom_top(access_token:String, activity_id:Number, h1:Handler, h2:Handler):void
        {
            var params:String = "activity_id=" + activity_id + "&access_token=" + access_token

            var r_url:String = "/collect/activity/bomb_top?" + params;
            var method:String = "get";
            basehttp(r_url, "", method, h1, h2)
        }


        public function paymentOrder(access_token:String, amount:Number, res_code:String, res_msg:String, h1:Handler, h2:Handler):void
        {
            var r_url:String = "/collect/wxmini/payment_order"
            var method:String = "post";
            var params:String = "access_token=" + access_token + "&amount=" + amount + "&res_code=" + res_code + "&res_msg=" + res_msg
            basehttp(r_url, params, method, h1, h2)

        }

        public function getPaymentIslimit(access_token:String, h1:Handler, h2:Handler):void
        {
            var r_url:String = "/collect/wxmini/payment_limit"
            var method:String = "POST";
            var params:String = "access_token=" + access_token
            basehttp(r_url, params, method, h1, h2)
        }

        public function getGoldExchangeLimit(access_token:String, h1:Handler, h2:Handler):void
        {
            var r_url:String = "/collect/exchange_limit";
            var method:String = "POST";
            var params:String = "access_token=" + access_token
            basehttp(r_url, params, method, h1, h2)

        }


        public function get_match_list(access_token:String, h1:Handler, h2:Handler):void
        {
            var params:String = "access_token=" + access_token
            var r_url:String = "/contest/get_contest_user?access_token=" + access_token
            var method:String = "get";
            basehttp(r_url, params, method, h1, h2)

        }

        public function getFeedBack(access_token:String, content:String, h1:Handler, h2:Handler):void
        {
            var r_url:String = "/feedback";
            var method:String = "POST";
            var params:String = "access_token=" + access_token + "&content=" + content;
            basehttp(r_url, params, method, h1, h2);
        }


        public function get_contest_daily_rank_list(access_token:String, contest_id:Number, h1:Handler, h2:Handler):void
        {
            var params:String = "access_token=" + access_token + "&contest_id=" + contest_id
            var r_url:String = "/contest/daily_top?" + params
            var method:String = "get";
            basehttp(r_url, params, method, h1, h2)
        }


        public function get_not_receive_reward(access_token:String, h1:Handler, h2:Handler):void
        {
            var params:String = "access_token=" + access_token
            var r_url:String = "/contest/get_not_receive_reward?" + params
            var method:String = "get";
            basehttp(r_url, params, method, h1, h2)
        }

        public function yylyLogin(params, cb:Handler, errorCb:Handler):void
        {
            var r_url:String = "/yyly_login";//?" + params;
            var method:String = "post";
            basehttp(r_url, params, method, cb, errorCb)
        }

        public function cocosLogin(params, cb:Handler, errorCb:Handler):void
        {
            var r_url:String = "/foreign/cocos_login";
            var method:String = "post";
            basehttp(r_url, params, method, cb, errorCb)
        }

        public function get_game_jump_list(h1:Handler, h2:Handler):void
        {
            var r_url:String = "/foreign/game_jump_list";
            var method:String = "get";
            basehttp(r_url, "", method, h1, h2)
        }

        public function getRedPack(access_token:String, h1:Handler, h2:Handler):void
        {
            var params:String = "&access_token=" + access_token
            var r_url:String = "/foreign/public_no/red_pack?" + params;
            var method:String = "get";
            basehttp(r_url, "", method, h1, h2)
        }

        public function saveUserInfo(access_token:String, nickname:String, avatar:String, h1:Handler, h2:Handler):void
        {
            var params:String = "access_token=" + access_token + "&nickname=" + nickname + "&avatar=" + avatar;
            var r_url:String = "/foreign/save_user_info?" + params;
            var method:String = "post";
            basehttp(r_url, params, method, h1, h2);
        }

        public function getSearchFriend(access_token:String, to_user_id:String, h1:Handler, h2:Handler):void
        {
            var params:String = "access_token=" + access_token + "&to_user_id=" + to_user_id;
            var r_url:String = "/foreign/friend/search_friend?" + params;
            var method:String = "get";
            basehttp(r_url, params, method, h1, h2);
        }

        public function getAddFriend(access_token:String, to_user_id:String, to_msg:String, h1:Handler, h2:Handler):void
        {
            var params:String = "access_token=" + access_token + "&to_user_id=" + to_user_id + "&to_msg=" + to_msg;
            var r_url:String = "/foreign/friend/add_friend?" + params;
            var method:String = "post";
            basehttp(r_url, params, method, h1, h2);
        }

        public function deleteFriend(access_token:String, to_user_id:String, h1:Handler, h2:Handler):void
        {
            var params:String = "access_token=" + access_token + "&to_user_id=" + to_user_id
            var r_url:String = "/foreign/friend/delete_friend?" + params;
            var method:String = "post";
            basehttp(r_url, params, method, h1, h2);
        }

        public function updateRemark(access_token:String, remark:String, h1:Handler, h2:Handler):void
        {
            var params:String
            if (remark)
            {
                params = "access_token=" + access_token + "&remark=" + remark
            } else
            {
                params = "access_token=" + access_token
            }
            var r_url:String = "/foreign/friend/update_remark?" + params;
            var method:String = "post";
            basehttp(r_url, params, method, h1, h2);
        }

        public function updateFriendRelation(access_token:String, status:Number, is_all:Number, update_user_id:Number, h1:Handler, h2:Handler):void
        {
            if (update_user_id)
            {
                var params:String = "access_token=" + access_token + "&status=" + status + "&is_all=" + is_all + "&update_user_id=" + update_user_id;
            } else
            {
                var params:String = "access_token=" + access_token + "&status=" + status + "&is_all=" + is_all
            }
            var r_url:String = "/foreign/friend/update_friend_relation?" + params;
            var method:String = "post";
            basehttp(r_url, params, method, h1, h2);
        }
    }

}

package manager
{
    public interface ResVo
    {

        function StartGames(parm:Object = null):void;

        //注册消息发送事件
        function register():void;

        //取消注册的消息发送事件
        function unRegister():void;
    }
}

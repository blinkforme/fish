package engine.struct.list
{
    public class DNode
    {
        private var _data:*;
        private var _prev:DNode;
        private var _next:DNode;

        public function DNode(data:*, prev:DNode, next:DNode)
        {
            this.data = data
            this.prev = prev
            this.next = next
        }



        public function get data():*
        {
            return _data;
        }

        public function set data(value:*):void
        {
            _data = value;
        }

        public function get prev():DNode
        {
            return _prev;
        }

        public function set prev(value:DNode):void
        {
            _prev = value;
        }

        public function get next():DNode
        {
            return _next;
        }

        public function set next(value:DNode):void
        {
            _next = value;
        }
    }
}

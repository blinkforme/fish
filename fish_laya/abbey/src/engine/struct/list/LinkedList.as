package engine.struct.list
{
    import engine.tool.GameConsole;

    //双向链表
    public class LinkedList
    {

        private var _head:DNode;

        public function LinkedList()
        {
            _head = new DNode(null, null, null)
            _head.prev = _head
            _head.next = _head
        }

        public function name():void
        {

        }


        //是否是头指针
        public function isHeadNode(node:DNode):Boolean
        {
            return node === _head
        }

        //是否是第一个数据节点
        public function isFirstNode(node:DNode):Boolean
        {
            return node.prev === _head
        }

        //是否是最后一个数据节点
        public function isLastNode(node:DNode):Boolean
        {
            return node.next === _head
        }

        public function remove(node:DNode):void
        {
            node.next.prev = node.prev
            node.prev.next = node.next
        }


        public function removeAll():void
        {
            head.prev = head
            head.next = head
        }

        public function isEmpty():Boolean
        {
            return head.prev === head
        }

        public function append(data:*):DNode
        {
            var node:DNode = new DNode(data, _head.prev, _head)
            _head.prev.next = node
            _head.prev = node
            return node
        }

        public function front(data:*, node:DNode):DNode
        {
            var newNode:DNode = new DNode(data, node.prev, node)
            node.prev.next = newNode
            node.prev = newNode
            return newNode
        }

        public function after(data:*, node:DNode):DNode
        {
            var newNode:DNode = new DNode(data, node, node.next)
            node.next.prev = newNode
            node.next = newNode
            return newNode
        }


        public function get head():DNode
        {
            return _head;
        }

        public function set head(value:DNode):void
        {
            _head = value;
        }

        public function print():void
        {
            var tempNode:DNode = head
            while (!isLastNode(tempNode.next))
            {
                tempNode = tempNode.next
            }
        }

    }
}

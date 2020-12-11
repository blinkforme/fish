package engine.struct.fsm
{
    public class FSM
    {

        private var _owner:Object;
        private var _currentState:State
        private var _prevState:State
        private var _globalState:State


        public function FSM(owner:Object, currentState:State, prevState:State, globalState:State)
        {
            this._owner = owner
            this._currentState = currentState
            this._prevState = prevState
            this._globalState = globalState
        }

        public function update():void
        {
            if (_globalState)
            {
                _globalState.execute(_owner)
            }
            if (_currentState)
            {
                _currentState.execute(_owner)
            }
        }

        public function changeState(newState:State):void
        {
            if (newState)
            {
                _prevState = _currentState
                _currentState.exit(_owner)
                _currentState = newState
                _currentState.enter(_owner)
            }
        }

        public function revertToPrevState():void
        {
            changeState(_prevState)
        }


        public function get owner():Object
        {
            return _owner;
        }

        public function set owner(value:Object):void
        {
            _owner = value;
        }

        public function get currentState():State
        {
            return _currentState;
        }

        public function set currentState(value:State):void
        {
            _currentState = value;
        }

        public function get prevState():State
        {
            return _prevState;
        }

        public function set prevState(value:State):void
        {
            _prevState = value;
        }

        public function get globalState():State
        {
            return _globalState;
        }

        public function set globalState(value:State):void
        {
            _globalState = value;
        }


        public function isInState(stateClazz:Class):Boolean
        {
            return currentState instanceof stateClazz
        }
    }
}

package org.interactive
{

    public interface InteractiveBase
    {

        function destructor() : void;

        function startListen(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void;

        function stopListen(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void;

    }
}

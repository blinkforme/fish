﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class libx_SceneAssetAsyncRequestWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(libx.SceneAssetAsyncRequest), typeof(libx.SceneAssetRequest));
		L.RegFunction("New", _Createlibx_SceneAssetAsyncRequest);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("progress", get_progress, null);
		L.RegVar("isDone", get_isDone, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _Createlibx_SceneAssetAsyncRequest(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				string arg0 = ToLua.CheckString(L, 1);
				bool arg1 = LuaDLL.luaL_checkboolean(L, 2);
				libx.SceneAssetAsyncRequest obj = new libx.SceneAssetAsyncRequest(arg0, arg1);
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: libx.SceneAssetAsyncRequest.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_progress(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			libx.SceneAssetAsyncRequest obj = (libx.SceneAssetAsyncRequest)o;
			float ret = obj.progress;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index progress on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isDone(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			libx.SceneAssetAsyncRequest obj = (libx.SceneAssetAsyncRequest)o;
			bool ret = obj.isDone;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isDone on a nil value");
		}
	}
}


﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class FairyGUI_StageWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(FairyGUI.Stage), typeof(FairyGUI.Container));
		L.RegFunction("Instantiate", Instantiate);
		L.RegFunction("Dispose", Dispose);
		L.RegFunction("SetFous", SetFous);
		L.RegFunction("DoKeyNavigate", DoKeyNavigate);
		L.RegFunction("GetTouchPosition", GetTouchPosition);
		L.RegFunction("GetAllTouch", GetAllTouch);
		L.RegFunction("ResetInputState", ResetInputState);
		L.RegFunction("CancelClick", CancelClick);
		L.RegFunction("EnableSound", EnableSound);
		L.RegFunction("DisableSound", DisableSound);
		L.RegFunction("PlayOneShotSound", PlayOneShotSound);
		L.RegFunction("OpenKeyboard", OpenKeyboard);
		L.RegFunction("CloseKeyboard", CloseKeyboard);
		L.RegFunction("InputString", InputString);
		L.RegFunction("SetCustomInput", SetCustomInput);
		L.RegFunction("ForceUpdate", ForceUpdate);
		L.RegFunction("ApplyPanelOrder", ApplyPanelOrder);
		L.RegFunction("SortWorldSpacePanelsByZOrder", SortWorldSpacePanelsByZOrder);
		L.RegFunction("MonitorTexture", MonitorTexture);
		L.RegFunction("AddTouchMonitor", AddTouchMonitor);
		L.RegFunction("RemoveTouchMonitor", RemoveTouchMonitor);
		L.RegFunction("IsTouchMonitoring", IsTouchMonitoring);
		L.RegFunction("RegisterCursor", RegisterCursor);
		L.RegFunction("New", _CreateFairyGUI_Stage);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("soundVolume", get_soundVolume, set_soundVolume);
		L.RegVar("inst", get_inst, null);
		L.RegVar("touchScreen", get_touchScreen, set_touchScreen);
		L.RegVar("keyboardInput", get_keyboardInput, set_keyboardInput);
		L.RegVar("isTouchOnUI", get_isTouchOnUI, null);
		L.RegVar("devicePixelRatio", get_devicePixelRatio, set_devicePixelRatio);
		L.RegVar("onStageResized", get_onStageResized, null);
		L.RegVar("touchTarget", get_touchTarget, null);
		L.RegVar("focus", get_focus, set_focus);
		L.RegVar("touchPosition", get_touchPosition, null);
		L.RegVar("touchCount", get_touchCount, null);
		L.RegVar("keyboard", get_keyboard, set_keyboard);
		L.RegVar("activeCursor", get_activeCursor, null);
		L.RegVar("beforeUpdate", get_beforeUpdate, set_beforeUpdate);
		L.RegVar("afterUpdate", get_afterUpdate, set_afterUpdate);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateFairyGUI_Stage(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				FairyGUI.Stage obj = new FairyGUI.Stage();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: FairyGUI.Stage.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Instantiate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			FairyGUI.Stage.Instantiate();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Dispose(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			obj.Dispose();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetFous(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
				FairyGUI.DisplayObject arg0 = (FairyGUI.DisplayObject)ToLua.CheckObject<FairyGUI.DisplayObject>(L, 2);
				obj.SetFous(arg0);
				return 0;
			}
			else if (count == 3)
			{
				FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
				FairyGUI.DisplayObject arg0 = (FairyGUI.DisplayObject)ToLua.CheckObject<FairyGUI.DisplayObject>(L, 2);
				bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
				obj.SetFous(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: FairyGUI.Stage.SetFous");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DoKeyNavigate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.DoKeyNavigate(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTouchPosition(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			UnityEngine.Vector2 o = obj.GetTouchPosition(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAllTouch(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			int[] arg0 = ToLua.CheckNumberArray<int>(L, 2);
			int[] o = obj.GetAllTouch(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ResetInputState(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			obj.ResetInputState();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CancelClick(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.CancelClick(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int EnableSound(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			obj.EnableSound();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DisableSound(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			obj.DisableSound();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayOneShotSound(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 2)
			{
				FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
				UnityEngine.AudioClip arg0 = (UnityEngine.AudioClip)ToLua.CheckObject(L, 2, typeof(UnityEngine.AudioClip));
				obj.PlayOneShotSound(arg0);
				return 0;
			}
			else if (count == 3)
			{
				FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
				UnityEngine.AudioClip arg0 = (UnityEngine.AudioClip)ToLua.CheckObject(L, 2, typeof(UnityEngine.AudioClip));
				float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
				obj.PlayOneShotSound(arg0, arg1);
				return 0;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: FairyGUI.Stage.PlayOneShotSound");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OpenKeyboard(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 9);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			bool arg1 = LuaDLL.luaL_checkboolean(L, 3);
			bool arg2 = LuaDLL.luaL_checkboolean(L, 4);
			bool arg3 = LuaDLL.luaL_checkboolean(L, 5);
			bool arg4 = LuaDLL.luaL_checkboolean(L, 6);
			string arg5 = ToLua.CheckString(L, 7);
			int arg6 = (int)LuaDLL.luaL_checknumber(L, 8);
			bool arg7 = LuaDLL.luaL_checkboolean(L, 9);
			obj.OpenKeyboard(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CloseKeyboard(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			obj.CloseKeyboard();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InputString(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.InputString(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetCustomInput(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 3 && TypeChecker.CheckTypes<UnityEngine.Vector2, bool>(L, 2))
			{
				FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
				UnityEngine.Vector2 arg0 = ToLua.ToVector2(L, 2);
				bool arg1 = LuaDLL.lua_toboolean(L, 3);
				obj.SetCustomInput(arg0, arg1);
				return 0;
			}
			else if (count == 3 && TypeChecker.CheckTypes<UnityEngine.RaycastHit, bool>(L, 2))
			{
				FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
				UnityEngine.RaycastHit arg0 = StackTraits<UnityEngine.RaycastHit>.To(L, 2);
				bool arg1 = LuaDLL.lua_toboolean(L, 3);
				obj.SetCustomInput(ref arg0, arg1);
				ToLua.Push(L, arg0);
				return 1;
			}
			else if (count == 4 && TypeChecker.CheckTypes<UnityEngine.Vector2, bool, bool>(L, 2))
			{
				FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
				UnityEngine.Vector2 arg0 = ToLua.ToVector2(L, 2);
				bool arg1 = LuaDLL.lua_toboolean(L, 3);
				bool arg2 = LuaDLL.lua_toboolean(L, 4);
				obj.SetCustomInput(arg0, arg1, arg2);
				return 0;
			}
			else if (count == 4 && TypeChecker.CheckTypes<UnityEngine.RaycastHit, bool, bool>(L, 2))
			{
				FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
				UnityEngine.RaycastHit arg0 = StackTraits<UnityEngine.RaycastHit>.To(L, 2);
				bool arg1 = LuaDLL.lua_toboolean(L, 3);
				bool arg2 = LuaDLL.lua_toboolean(L, 4);
				obj.SetCustomInput(ref arg0, arg1, arg2);
				ToLua.Push(L, arg0);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to method: FairyGUI.Stage.SetCustomInput");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ForceUpdate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			obj.ForceUpdate();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ApplyPanelOrder(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			FairyGUI.Container arg0 = (FairyGUI.Container)ToLua.CheckObject<FairyGUI.Container>(L, 2);
			obj.ApplyPanelOrder(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SortWorldSpacePanelsByZOrder(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.SortWorldSpacePanelsByZOrder(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int MonitorTexture(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			FairyGUI.NTexture arg0 = (FairyGUI.NTexture)ToLua.CheckObject<FairyGUI.NTexture>(L, 2);
			obj.MonitorTexture(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AddTouchMonitor(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			FairyGUI.EventDispatcher arg1 = (FairyGUI.EventDispatcher)ToLua.CheckObject<FairyGUI.EventDispatcher>(L, 3);
			obj.AddTouchMonitor(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RemoveTouchMonitor(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			FairyGUI.EventDispatcher arg0 = (FairyGUI.EventDispatcher)ToLua.CheckObject<FairyGUI.EventDispatcher>(L, 2);
			obj.RemoveTouchMonitor(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsTouchMonitoring(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			FairyGUI.EventDispatcher arg0 = (FairyGUI.EventDispatcher)ToLua.CheckObject<FairyGUI.EventDispatcher>(L, 2);
			bool o = obj.IsTouchMonitoring(arg0);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RegisterCursor(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 4);
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject<FairyGUI.Stage>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			UnityEngine.Texture2D arg1 = (UnityEngine.Texture2D)ToLua.CheckObject(L, 3, typeof(UnityEngine.Texture2D));
			UnityEngine.Vector2 arg2 = ToLua.ToVector2(L, 4);
			obj.RegisterCursor(arg0, arg1, arg2);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_soundVolume(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			float ret = obj.soundVolume;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index soundVolume on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_inst(IntPtr L)
	{
		try
		{
			ToLua.PushObject(L, FairyGUI.Stage.inst);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_touchScreen(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, FairyGUI.Stage.touchScreen);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_keyboardInput(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, FairyGUI.Stage.keyboardInput);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isTouchOnUI(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushboolean(L, FairyGUI.Stage.isTouchOnUI);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_devicePixelRatio(IntPtr L)
	{
		try
		{
			LuaDLL.lua_pushnumber(L, FairyGUI.Stage.devicePixelRatio);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onStageResized(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			FairyGUI.EventListener ret = obj.onStageResized;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onStageResized on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_touchTarget(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			FairyGUI.DisplayObject ret = obj.touchTarget;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index touchTarget on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_focus(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			FairyGUI.DisplayObject ret = obj.focus;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index focus on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_touchPosition(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			UnityEngine.Vector2 ret = obj.touchPosition;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index touchPosition on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_touchCount(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			int ret = obj.touchCount;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index touchCount on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_keyboard(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			FairyGUI.IKeyboard ret = obj.keyboard;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index keyboard on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_activeCursor(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			string ret = obj.activeCursor;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index activeCursor on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_beforeUpdate(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(System.Action)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_afterUpdate(IntPtr L)
	{
		ToLua.Push(L, new EventObject(typeof(System.Action)));
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_soundVolume(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.soundVolume = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index soundVolume on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_touchScreen(IntPtr L)
	{
		try
		{
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			FairyGUI.Stage.touchScreen = arg0;
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_keyboardInput(IntPtr L)
	{
		try
		{
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			FairyGUI.Stage.keyboardInput = arg0;
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_devicePixelRatio(IntPtr L)
	{
		try
		{
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			FairyGUI.Stage.devicePixelRatio = arg0;
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_focus(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			FairyGUI.DisplayObject arg0 = (FairyGUI.DisplayObject)ToLua.CheckObject<FairyGUI.DisplayObject>(L, 2);
			obj.focus = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index focus on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_keyboard(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.Stage obj = (FairyGUI.Stage)o;
			FairyGUI.IKeyboard arg0 = (FairyGUI.IKeyboard)ToLua.CheckObject<FairyGUI.IKeyboard>(L, 2);
			obj.keyboard = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index keyboard on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_beforeUpdate(IntPtr L)
	{
		try
		{
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject(L, 1, typeof(FairyGUI.Stage));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'FairyGUI.Stage.beforeUpdate' can only appear on the left hand side of += or -= when used outside of the type 'FairyGUI.Stage'");
			}

			if (arg0.op == EventOp.Add)
			{
				System.Action ev = (System.Action)arg0.func;
				obj.beforeUpdate += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				System.Action ev = (System.Action)arg0.func;
				obj.beforeUpdate -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_afterUpdate(IntPtr L)
	{
		try
		{
			FairyGUI.Stage obj = (FairyGUI.Stage)ToLua.CheckObject(L, 1, typeof(FairyGUI.Stage));
			EventObject arg0 = null;

			if (LuaDLL.lua_isuserdata(L, 2) != 0)
			{
				arg0 = (EventObject)ToLua.ToObject(L, 2);
			}
			else
			{
				return LuaDLL.luaL_throw(L, "The event 'FairyGUI.Stage.afterUpdate' can only appear on the left hand side of += or -= when used outside of the type 'FairyGUI.Stage'");
			}

			if (arg0.op == EventOp.Add)
			{
				System.Action ev = (System.Action)arg0.func;
				obj.afterUpdate += ev;
			}
			else if (arg0.op == EventOp.Sub)
			{
				System.Action ev = (System.Action)arg0.func;
				obj.afterUpdate -= ev;
			}

			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}
}


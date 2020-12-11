﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class FairyGUI_BaseFontWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(FairyGUI.BaseFont), typeof(System.Object));
		L.RegFunction("UpdateGraphics", UpdateGraphics);
		L.RegFunction("SetFormat", SetFormat);
		L.RegFunction("PrepareCharacters", PrepareCharacters);
		L.RegFunction("GetGlyph", GetGlyph);
		L.RegFunction("DrawGlyph", DrawGlyph);
		L.RegFunction("DrawLine", DrawLine);
		L.RegFunction("HasCharacter", HasCharacter);
		L.RegFunction("GetLineHeight", GetLineHeight);
		L.RegFunction("Dispose", Dispose);
		L.RegFunction("New", _CreateFairyGUI_BaseFont);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("name", get_name, set_name);
		L.RegVar("mainTexture", get_mainTexture, set_mainTexture);
		L.RegVar("canTint", get_canTint, set_canTint);
		L.RegVar("customBold", get_customBold, set_customBold);
		L.RegVar("customBoldAndItalic", get_customBoldAndItalic, set_customBoldAndItalic);
		L.RegVar("customOutline", get_customOutline, set_customOutline);
		L.RegVar("shader", get_shader, set_shader);
		L.RegVar("keepCrisp", get_keepCrisp, set_keepCrisp);
		L.RegVar("version", get_version, set_version);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateFairyGUI_BaseFont(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				FairyGUI.BaseFont obj = new FairyGUI.BaseFont();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: FairyGUI.BaseFont.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UpdateGraphics(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)ToLua.CheckObject<FairyGUI.BaseFont>(L, 1);
			FairyGUI.NGraphics arg0 = (FairyGUI.NGraphics)ToLua.CheckObject<FairyGUI.NGraphics>(L, 2);
			obj.UpdateGraphics(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetFormat(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)ToLua.CheckObject<FairyGUI.BaseFont>(L, 1);
			FairyGUI.TextFormat arg0 = (FairyGUI.TextFormat)ToLua.CheckObject<FairyGUI.TextFormat>(L, 2);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
			obj.SetFormat(arg0, arg1);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PrepareCharacters(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)ToLua.CheckObject<FairyGUI.BaseFont>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.PrepareCharacters(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetGlyph(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)ToLua.CheckObject<FairyGUI.BaseFont>(L, 1);
			char arg0 = (char)LuaDLL.luaL_checknumber(L, 2);
			float arg1;
			float arg2;
			float arg3;
			bool o = obj.GetGlyph(arg0, out arg1, out arg2, out arg3);
			LuaDLL.lua_pushboolean(L, o);
			LuaDLL.lua_pushnumber(L, arg1);
			LuaDLL.lua_pushnumber(L, arg2);
			LuaDLL.lua_pushnumber(L, arg3);
			return 4;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DrawGlyph(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 7);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)ToLua.CheckObject<FairyGUI.BaseFont>(L, 1);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
			System.Collections.Generic.List<UnityEngine.Vector3> arg2 = (System.Collections.Generic.List<UnityEngine.Vector3>)ToLua.CheckObject(L, 4, typeof(System.Collections.Generic.List<UnityEngine.Vector3>));
			System.Collections.Generic.List<UnityEngine.Vector2> arg3 = (System.Collections.Generic.List<UnityEngine.Vector2>)ToLua.CheckObject(L, 5, typeof(System.Collections.Generic.List<UnityEngine.Vector2>));
			System.Collections.Generic.List<UnityEngine.Vector2> arg4 = (System.Collections.Generic.List<UnityEngine.Vector2>)ToLua.CheckObject(L, 6, typeof(System.Collections.Generic.List<UnityEngine.Vector2>));
			System.Collections.Generic.List<UnityEngine.Color32> arg5 = (System.Collections.Generic.List<UnityEngine.Color32>)ToLua.CheckObject(L, 7, typeof(System.Collections.Generic.List<UnityEngine.Color32>));
			int o = obj.DrawGlyph(arg0, arg1, arg2, arg3, arg4, arg5);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DrawLine(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 10);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)ToLua.CheckObject<FairyGUI.BaseFont>(L, 1);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			float arg1 = (float)LuaDLL.luaL_checknumber(L, 3);
			float arg2 = (float)LuaDLL.luaL_checknumber(L, 4);
			int arg3 = (int)LuaDLL.luaL_checknumber(L, 5);
			int arg4 = (int)LuaDLL.luaL_checknumber(L, 6);
			System.Collections.Generic.List<UnityEngine.Vector3> arg5 = (System.Collections.Generic.List<UnityEngine.Vector3>)ToLua.CheckObject(L, 7, typeof(System.Collections.Generic.List<UnityEngine.Vector3>));
			System.Collections.Generic.List<UnityEngine.Vector2> arg6 = (System.Collections.Generic.List<UnityEngine.Vector2>)ToLua.CheckObject(L, 8, typeof(System.Collections.Generic.List<UnityEngine.Vector2>));
			System.Collections.Generic.List<UnityEngine.Vector2> arg7 = (System.Collections.Generic.List<UnityEngine.Vector2>)ToLua.CheckObject(L, 9, typeof(System.Collections.Generic.List<UnityEngine.Vector2>));
			System.Collections.Generic.List<UnityEngine.Color32> arg8 = (System.Collections.Generic.List<UnityEngine.Color32>)ToLua.CheckObject(L, 10, typeof(System.Collections.Generic.List<UnityEngine.Color32>));
			int o = obj.DrawLine(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int HasCharacter(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)ToLua.CheckObject<FairyGUI.BaseFont>(L, 1);
			char arg0 = (char)LuaDLL.luaL_checknumber(L, 2);
			bool o = obj.HasCharacter(arg0);
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLineHeight(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)ToLua.CheckObject<FairyGUI.BaseFont>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			int o = obj.GetLineHeight(arg0);
			LuaDLL.lua_pushinteger(L, o);
			return 1;
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
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)ToLua.CheckObject<FairyGUI.BaseFont>(L, 1);
			obj.Dispose();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_name(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			string ret = obj.name;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index name on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_mainTexture(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			FairyGUI.NTexture ret = obj.mainTexture;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index mainTexture on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_canTint(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			bool ret = obj.canTint;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index canTint on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_customBold(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			bool ret = obj.customBold;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index customBold on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_customBoldAndItalic(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			bool ret = obj.customBoldAndItalic;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index customBoldAndItalic on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_customOutline(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			bool ret = obj.customOutline;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index customOutline on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_shader(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			string ret = obj.shader;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index shader on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_keepCrisp(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			bool ret = obj.keepCrisp;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index keepCrisp on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_version(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			int ret = obj.version;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index version on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_name(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.name = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index name on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_mainTexture(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			FairyGUI.NTexture arg0 = (FairyGUI.NTexture)ToLua.CheckObject<FairyGUI.NTexture>(L, 2);
			obj.mainTexture = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index mainTexture on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_canTint(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.canTint = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index canTint on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_customBold(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.customBold = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index customBold on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_customBoldAndItalic(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.customBoldAndItalic = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index customBoldAndItalic on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_customOutline(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.customOutline = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index customOutline on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_shader(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.shader = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index shader on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_keepCrisp(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.keepCrisp = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index keepCrisp on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_version(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			FairyGUI.BaseFont obj = (FairyGUI.BaseFont)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.version = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index version on a nil value");
		}
	}
}

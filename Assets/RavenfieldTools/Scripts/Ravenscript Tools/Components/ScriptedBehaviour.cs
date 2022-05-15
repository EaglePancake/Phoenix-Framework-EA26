using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Lua
{

	/// <summary>A component that executes _Ravenscript_ at runtime.</summary>
	/// <remarks>
	/// This file is included in the *Ravenfield Tools Pack*.
	///
	/// Ravenscript is a script language built on _Lua_. It allowes you to control many different
	/// aspects of the game using code.
	///
	/// Ravenscript source code is stored in *.txt files (a Unity limitation.) Each source file may
	/// contain one or more _behaviours_. A behaviour is a Lua class with a specific task.
	///
	/// All Lua classes are created with the `class()` helper function:
	///
	/// `MyBehaviour = class()`
	///
	/// Common Unity callbacks such as _Update_ and _Start_ are supported:
	///
	/// `function MyBehaviour:Update() .. end`
	///
	/// To enable hot-reloading you should instead use the `behaviour()` function:
	///
	/// `behaviour("MyBehaviour") -- a local class named MyBehaviour is created`
	///
	/// See the Ravenfield documentation for more details.
	/// </remarks>
	public partial class ScriptedBehaviour : MonoBehaviour
	{
		/// <summary>Ravenscript source file.</summary>
		public TextAsset source;

		/// <summary>Name of the Ravenscript class to instantiate.</summary>
		public string behaviour;

		/// <summary>References to transforms in assets or other objects.</summary>
		/// <remarks>Accessable by name from Lua.</remarks>
		public NamedTarget[] targets;
	}

	/// <summary>A named reference to a Unity Object.</summary>
	[System.Serializable]
	public class NamedTarget
	{
		public string name;
		public Object value;
	}

}

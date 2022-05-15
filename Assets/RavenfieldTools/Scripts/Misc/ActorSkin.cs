using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class ActorSkin {

    public string name = "New Skin";
    public MeshSkin characterSkin;
    public MeshSkin armSkin;
    public MeshSkin kickLegSkin;

	public RigSettings rigSettings = new RigSettings() { version = RigSettings.RigVersion.Unity_2020 };

	[System.Serializable]
    public class MeshSkin {
        public Mesh mesh;
        public Material[] materials;
        public int teamMaterial = -1;
    }

	[System.Serializable]
	public class RigSettings
	{
		public enum RigVersion
		{
			Unity_5, // Used for legacy mods imported with Unity 5 + Blender 2.7
			Unity_2020, // Used for mods imported with Unity 2020 + Blender 2.93 or similar
		}

		public const RigVersion RECOMMENDED_VERSION = RigVersion.Unity_2020;

		public RigVersion version = RECOMMENDED_VERSION;

		public RigSettings() {
			version = RECOMMENDED_VERSION;
		}
	}
}

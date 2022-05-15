#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;
using System.Collections;

[CustomEditor(typeof(TankTurret), true)] [CanEditMultipleObjects]
public class TankTurretEditor : Editor {

	public override void OnInspectorGUI() {
		GUI.color = Color.red;
		GUILayout.Box("WARNING! The TankTurret component is outdated.\nYou probably want to replace it with MountedStabilizedTurret.");
		GUI.color = Color.white;
		base.OnInspectorGUI();
	}
}
#endif

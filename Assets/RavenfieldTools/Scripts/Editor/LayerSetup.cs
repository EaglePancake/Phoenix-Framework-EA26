using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class LayerSetup
{
	const int N_LAYERS = 32;
	static readonly Dictionary<int, string> LAYERS = new Dictionary<int, string>() {
		{ 8, "Hitbox" },
		{ 9, "Player" },
		{ 10, "Ragdoll" },
		{ 11, "Seat" },
		{ 12, "Vehicle" },
		{ 13, "Throwable" },
		{ 14, "Actor" },
		{ 15, "NoActorCollision" },
		{ 16, "SeatedHitbox" },
		{ 17, "ActorCollision" },
		{ 18, "FirstPerson" },
		{ 19, "Background" },
		{ 20, "CapturePoint" },
		{ 21, "ProjectilePenetrate" },
		{ 22, "AirAvoidance" },
		{ 23, "AiVisionOccluder" },
		{ 24, "KickActivated" },
		{ 28, "PostProcessing" },
		{ 29, "Reserved 1" },
		{ 30, "Reserved 2" },
		{ 31, "Reserved 3" },
	};

	[MenuItem("Ravenfield Tools/Setup Layer Names")]
	public static void SetupNames() {
		Setup();
	}

    public static void Setup() {
		try {
			var tagAsset = new SerializedObject(AssetDatabase.LoadAssetAtPath("ProjectSettings/TagManager.asset", typeof(Object)));
			var lProps = tagAsset.FindProperty("layers");
			lProps.arraySize = N_LAYERS;

			foreach(var i in LAYERS.Keys) {
				var p = lProps.GetArrayElementAtIndex(i);
				p.stringValue = LAYERS[i];
			}

			tagAsset.ApplyModifiedProperties();
		}
		catch(System.Exception e) {
			Debug.LogError("Could not write layer names, exception follows.");
			Debug.LogException(e);
		}
	}
}

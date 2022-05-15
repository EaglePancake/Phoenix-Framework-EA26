using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class CopyHeirarcyData : MonoBehaviour
{

	public Transform destination;

#if UNITY_EDITOR
	delegate void TraverseCallback(Transform t);
	delegate void CopyCallback(Transform origin, Transform destination);

	int Copy(CopyCallback copyCallback) {

		var originTransforms = new Dictionary<string, Transform>();
		var transformMap = new Dictionary<Transform, Transform>();

		ForEachChild(this.transform, t => {
			try {
				if (t == this.transform) return;

				string transformName = FormatGOName(t.gameObject.name);
				originTransforms.Add(transformName, t);
			} catch { }
		});

		ForEachChild(this.destination, t => {
			try {

				if (t == this.destination) return;

				string transformName = FormatGOName(t.gameObject.name);
				if(originTransforms.ContainsKey(transformName)) {
					transformMap.Add(originTransforms[transformName], t);
				}
			} catch { }
		});

		List<Object> undoObjects = new List<Object>();
		foreach(var destination in transformMap.Values) {
			undoObjects.Add(destination.gameObject);
			undoObjects.AddRange(destination.GetComponents<Component>());
		}

		Undo.RecordObjects(undoObjects.ToArray(), "Copy heirarchy data");

		foreach(var origin in transformMap.Keys) {
			copyCallback.Invoke(origin, transformMap[origin]);
		}

		return transformMap.Keys.Count;
	}

	void ForEachChild(Transform t, TraverseCallback callback) {
		callback.Invoke(t);

		for (int i = 0; i < t.childCount; i++) {
			ForEachChild(t.GetChild(i), callback);
		}
	}

	string FormatGOName(string name) {
		var result = name.Replace('_', ' ');
		result = result.Replace('.', ' ');

		return result;
	}

	public void CopyLocalTransforms() {
		int count = Copy((origin, destination) => {
			destination.localPosition = origin.localPosition;
			destination.localRotation = origin.localRotation;
			destination.localScale = origin.localScale;

			var oSkinnedMeshRenderer = origin.GetComponent<SkinnedMeshRenderer>();
			var dSkinnedMeshRenderer = destination.GetComponent<SkinnedMeshRenderer>();

			// Also copy skinned mesh renderer local bounds as these depend on heirarchy transforms.
			if (oSkinnedMeshRenderer != null && dSkinnedMeshRenderer != null) {
				dSkinnedMeshRenderer.localBounds = oSkinnedMeshRenderer.localBounds;
			}
		});

		Debug.LogFormat("Updated {0} transforms", count);
	}

	public void CopyMesh() {
		int count = Copy((origin, destination) => {
			var oMeshFilter = origin.GetComponent<MeshFilter>();
			var dMeshFilter = destination.GetComponent<MeshFilter>();
			var oSkinnedMeshRenderer = origin.GetComponent<SkinnedMeshRenderer>();
			var dSkinnedMeshRenderer = destination.GetComponent<SkinnedMeshRenderer>();

			if (oMeshFilter != null && dMeshFilter != null) {
				dMeshFilter.sharedMesh = oMeshFilter.sharedMesh;
			}

			if (oSkinnedMeshRenderer != null && dSkinnedMeshRenderer != null) {
				dSkinnedMeshRenderer.localBounds = oSkinnedMeshRenderer.localBounds;
				dSkinnedMeshRenderer.sharedMesh = oSkinnedMeshRenderer.sharedMesh;
			}
		});

		Debug.LogFormat("Updated {0} meshes", count);
	}

	public void CopyNames() {
		int count = Copy((origin, destination) => {
			destination.gameObject.name = origin.gameObject.name;
		});

		Debug.LogFormat("Updated {0} names", count);
	}

#endif
}

#if UNITY_EDITOR
[CustomEditor(typeof(CopyHeirarcyData))]
public class CopyHeirarcyDataEditor : Editor
{
	public override void OnInspectorGUI() {
		base.OnInspectorGUI();
		if(GUILayout.Button("Copy Transforms")) {
			((this.target) as CopyHeirarcyData).CopyLocalTransforms();
		}
		if (GUILayout.Button("Copy Meshes")) {
			((this.target) as CopyHeirarcyData).CopyMesh();
		}
		if (GUILayout.Button("Copy Names")) {
			((this.target) as CopyHeirarcyData).CopyNames();
		}
	}
}
#endif

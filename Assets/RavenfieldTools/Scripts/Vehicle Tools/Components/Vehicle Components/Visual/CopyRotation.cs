using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CopyRotation : MonoBehaviour {

	public Transform target;

	void LateUpdate () {
		this.transform.rotation = this.target.rotation;
	}
}

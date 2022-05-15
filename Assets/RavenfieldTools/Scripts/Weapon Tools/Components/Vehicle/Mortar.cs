using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mortar : MountedWeapon {

	[Header("Mortar Settings")]
	public float maxRange = 300f;
	public float minRange = 10f;
	public float defaultRange = 100f;
	public float rangeChangeSpeed = 1f;
	public float trajectoryHeight = 200f;
	public float targetSpreadRange = 0f;

	public GameObject aimIndicator;

}

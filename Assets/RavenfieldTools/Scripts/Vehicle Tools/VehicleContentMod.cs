using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VehicleContentMod : MonoBehaviour {

	new public string name = "My Cool Vehicle Mod";

	public Variant[] variants = new Variant[] { new Variant() { name = "Default" } };

	public IEnumerable<GameObject> AllEntries() {
		if (variants == null) yield break;

		foreach(var variant in variants) {
			yield return variant.jeep;
			yield return variant.jeepMachineGun;
			yield return variant.quad;
			yield return variant.tank;
			yield return variant.apc;
			yield return variant.attackBoat;
			yield return variant.rhib;
			yield return variant.attackHelicopter;
			yield return variant.transportHelicopter;
			yield return variant.attackPlane;
			yield return variant.bombPlane;
			yield return variant.turretMachineGun;
			yield return variant.turretAntiTank;
			yield return variant.turretAntiAir;
		}
	}

	[System.Serializable]
	public struct Variant
	{
		public string name;

		public GameObject jeep;
		public GameObject jeepMachineGun;
		public GameObject quad;
		public GameObject tank;
		public GameObject apc;
		public GameObject attackBoat;
		public GameObject rhib;
		public GameObject attackHelicopter;
		public GameObject transportHelicopter;
		public GameObject attackPlane;
		public GameObject bombPlane;

		public GameObject turretMachineGun;
		public GameObject turretAntiTank;
		public GameObject turretAntiAir;
	}
}

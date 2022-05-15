using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Light))]
public class Rocket : ExplodingProjectile {
	protected override void Hit (Vector3 point, Vector3 normal)
	{
		base.Hit (point, normal);

		GetComponent<Light>().enabled = false;
	}
}

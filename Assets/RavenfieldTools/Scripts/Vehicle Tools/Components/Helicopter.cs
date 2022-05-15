using UnityEngine;
using System.Collections;

public class Helicopter : Vehicle {

	[Header("Helicopter Flight Model")]
	public float rotorForce = 5f;
	public float manouverability = 1f;
	public float extraForceWhenStopping = 0.3f;
	public float controlWhenBurning = 0.1f;
	public float groundEffectAcceleration = 2f;
	public float aerodynamicLift = 0.03f;

	[Header("Helicopter AI Properties")]
	public float flightAltitudeMultiplier = 1f;
}

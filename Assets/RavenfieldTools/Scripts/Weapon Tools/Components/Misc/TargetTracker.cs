using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetTracker : MonoBehaviour {

	public enum LockType
	{
		Vehicle,
		Point,
		VehicleOrPoint,
	}

	public float fieldOfView = 20f;
	public float scanFrequency = 5f;
	public float lockTime = 2f;
	public bool requireAim = false;
	public bool requireLockToFire = false;
	public bool onlyLockWhenWeaponIsEquipped = true;
	public bool useMountedWeaponUserLook = false;
	public bool lockOntoEmptyVehicles = false;
	public float maxPointTargetAngle = 20f;
	public Transform trackingPositionIndicator;
	public Transform pointTargetPositionIndicator;
	public GameObject activateWhenLocking;
	public GameObject activateWhenLocked;
	public GameObject activateWhenPointTargetInRange;
	public GameObject activateWhenPointTargetOutOfRange;

	public bool updatePositionIndicatorEveryFrame = true;
	public LockType lockType = LockType.Vehicle;

	void Awake() {
		try {
			this.activateWhenLocked?.SetActive(false);
			this.activateWhenLocking?.SetActive(false);
			this.activateWhenPointTargetInRange.SetActive(false);
			this.activateWhenPointTargetOutOfRange.SetActive(false);
		} catch { }
	}
}

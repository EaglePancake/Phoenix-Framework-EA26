using UnityEngine;
using System.Collections;

public class MountedStabilizedTurret : MountedWeapon {

	const float MAX_TURN_DELTA = 10f;

	[Header("Mounted Turret")]
	public Transform bearingTransform, pitchTransform;

	[Space]
	public float sensitivityX = 1f;
    public float sensitivityY = 1f;

	[Space]
	public Clamp clampX;
	public Clamp clampY;

	public ClampYNotch[] clampNotch = new ClampYNotch[0];

	[Space]
	public bool useMaxTurnSpeed = false;
    public float maxTurnSpeed = 100f;

	[Space]
	public bool useSpring = false;
    public float springAmount = 0.002f;
    public float springForce = 30f;
    public float springDrag = 5f;
    public Vector2 springMaxOffset = new Vector2(0.1f, 0.1f);

    [System.Serializable]
	public class Clamp {
		public bool enabled;
		public float min, max;

		public float ClampAngle(float a) {
			return Mathf.Clamp(Mathf.DeltaAngle(0f, a), this.min, this.max);
		}
	}

	[System.Serializable]
	public struct ClampYNotch
	{
		public enum Type
		{
			AffectMin,
			AffectMax,
		}

		public Type type;
		public float bearingAngle;
		public float notchWidth;
		public float notchSlopeWidth;
		public float notchHeight;
	}
}

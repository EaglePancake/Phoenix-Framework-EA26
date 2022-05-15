using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelColorGrading : MonoBehaviour {

	public enum Preset
	{
		Custom = -1,
		Default = 0,
		Bright = 1,
		Muted = 2,
		Dark = 3,
		HotSand = 4,
		ScorchingFire = 5,
		CoolIce = 6,
		FrozenSolid = 7,
		Moody = 8,
		Trippy = 9,
	}

	public Preset preset = Preset.Default;

	public GradingData day, night;

	[System.Serializable]
	public class GradingData
	{
		[Range(-100, 100)] public float temperature, tint, hueShift, saturation, brightness, contrast;
		public float bloomIntensity = 1f;
		public float bloomThreshold = 0.9f;
	}
}

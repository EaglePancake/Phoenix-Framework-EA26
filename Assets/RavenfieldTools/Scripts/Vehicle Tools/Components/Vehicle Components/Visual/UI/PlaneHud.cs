using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlaneHud : MonoBehaviour {

	public Airplane plane;

	public delegate bool DelGetIndicatorValue();

	public Indicator gearIndicator;
	public Indicator airbrakeIndicator;
	public Indicator countermeasureIndicator;

	public Text speedLabel;
	public Text altitudeLabel;

	[System.Serializable]
	public struct Indicator
	{
		public GameObject ready, waiting;
	}
}

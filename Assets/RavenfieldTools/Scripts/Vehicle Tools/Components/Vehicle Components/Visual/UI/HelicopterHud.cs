using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HelicopterHud : MonoBehaviour {

	public Helicopter helicopter;

	public PlaneHud.Indicator autoHover;
	public PlaneHud.Indicator countermeasureIndicator;

	public Text horizontalSpeedText;
	public Text verticalSpeedText;
	public Text altitudeText;
}

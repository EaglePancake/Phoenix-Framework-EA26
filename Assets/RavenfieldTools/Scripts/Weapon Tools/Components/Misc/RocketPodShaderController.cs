using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RocketPodShaderController : MonoBehaviour {

	int PROPERTY_ID;

	int lastAmmo = int.MinValue;
	public Weapon weapon;
	Material material;

	void Awake () {
		PROPERTY_ID = Shader.PropertyToID("_CutoffUV");
		this.material = GetComponent<Renderer>().material;
	}

	void Update() {
		if(weapon.ammo != this.lastAmmo) {
			this.lastAmmo = weapon.ammo;
			UpdateMaterial();
		}
	}
	
	void UpdateMaterial() {
		float uvOffset = ((float)this.weapon.ammo) / this.weapon.configuration.ammo;
		this.material.SetFloat(PROPERTY_ID, uvOffset);
	}
}

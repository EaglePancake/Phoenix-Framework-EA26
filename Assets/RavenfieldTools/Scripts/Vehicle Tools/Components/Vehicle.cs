using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Vehicle : MonoBehaviour {

	public enum AiType {Capture, Roam, Transport};
	public enum ArmorRating {SmallArms, HeavyArms, AntiTank};
	public enum AiUseStrategy {Default, OnlyFromFrontlineSpawn, FromAnySpawn};

	new public string name = "VEHICLE";

	public List<Seat> seats = new List<Seat>();
	public Animator animator;

	[Header("Damage Sources")]
	public Actor.TargetType targetType = Actor.TargetType.Unarmored;
	public ArmorRating armorDamagedBy = ArmorRating.HeavyArms;
	public float smallArmsMultiplier = 0.05f;
	public float heavyArmsMultiplier = 1f;
	public bool canFireAtOwnVehicle = false;

	[Header("Health Stats")]
	public float maxHealth = 1000f;
	public float crashDamageSpeedThrehshold = 2f;
	public float crashDamageMultiplier = 1f;
	public float spotChanceMultiplier = 3f;
	public float burnTime = 0f;
	public bool crashSkipsBurn = false;
	public bool canBeRepairedAfterDeath = false;

	[Header("Target Tracking")]
	public bool directJavelinPath = false;
	public Transform targetLockPoint;

	[Header("AI Behaviour")]
	public AiType aiType;
	public AiUseStrategy aiUseStrategy = AiUseStrategy.Default;
	public bool aiUseToDefendPoint = true;
	public int minCrewCount = 0;
	public float roamCompleteDistance = 0f;
	public Vector2 avoidanceSize = Vector2.one;
	public float pathingRadius = 0f;
	public Transform blockSensor;

	[Header("Particle Effects")]
	public ParticleSystem smokeParticles;
	public ParticleSystem fireParticles;
	public ParticleSystem deathParticles;

	[Header("Sound Effects")]
	public AudioSource interiorAudioSource;
	public AudioSource fireAlarmSound;
	public AudioSource deathSound;

	public AudioSource impactAudio;
	public AudioSource heavyDamageAudio;

	public Engine engine;

	[Header("Minimap")]
	public Texture blip;
	public float blipScale = 1f;

	[Header("Infantry Ramming")]
	public Vector3 ramSize = Vector3.one;
	public Vector3 ramOffset = Vector3.zero;

	[Header("Appearance")]
	public GameObject[] disableOnDeath;
	public GameObject[] activateOnDeath;
	public MaterialTarget[] teamColorMaterials;

	[Header("Countermeasures")]
	public bool hasCountermeasures = false;
	public float countermeasuresActiveTime = 3f;
	public float countermeasuresCooldown = 20f;
	public ParticleSystem countermeasureParticles;
    public GameObject countermeasureSpawnPrefab;
    public AudioSource countermeasureAudio;

	[Header("Misc")]
	public bool canCapturePoints = true;

	[System.Serializable]
	public class Engine {
		public bool controlAudio = true;
		public float powerGainSpeed = 1f;
		public float pitchGainSpeed = 1f;
        public float throttleGainSpeed = 2f;
        public AudioSource throttleAudioSource;
        public AudioSource extraAudioSource;
        public AudioClip shiftForwardClip;
        public AudioClip shiftReverseClip;
        public AudioClip ignitionClip;
    }
}

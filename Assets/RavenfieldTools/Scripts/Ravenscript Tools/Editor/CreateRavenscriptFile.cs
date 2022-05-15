using UnityEngine;
using UnityEditor;

public static class CreateRavenscriptFile {

	public const string DEFAULT_BEHAVIOUR_NAME = "MyBehaviour";
	const string NEWLINE = "\n";
	const string INDENT = "\t";
	const string CONTENT_FORMAT =
		"-- Register the behaviour" + NEWLINE +
		"behaviour(\"{0}\")" + NEWLINE +
		NEWLINE +
		"function {0}:Start()" + NEWLINE +
		INDENT + "-- Run when behaviour is created" + NEWLINE +
		INDENT + "print(\"Hello World\")" + NEWLINE +
		"end" + NEWLINE +
		NEWLINE +
		"function {0}:Update()" + NEWLINE +
		INDENT + "-- Run every frame" + NEWLINE +
		INDENT + NEWLINE +
		"end" +
		NEWLINE;

	public static readonly string DEFAULT_CONTENT = GenerateContent(DEFAULT_BEHAVIOUR_NAME);
	static bool justCreatedFile = false;

	[MenuItem("Assets/Create/Ravenscript", priority = 30)]
	public static void Test() {
		justCreatedFile = true;
		ProjectWindowUtil.CreateAssetWithContent(DEFAULT_BEHAVIOUR_NAME+".lua", DEFAULT_CONTENT);
	}

	public static bool TryConsumeJustCreatedFile() {
		if(justCreatedFile) {
			justCreatedFile = false;
			return true;
		}
		return false;
	}

	public static string GenerateContent(string behaviourName) {
		return string.Format(CONTENT_FORMAT, behaviourName);
	}
}

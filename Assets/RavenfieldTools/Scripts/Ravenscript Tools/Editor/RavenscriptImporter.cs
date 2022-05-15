using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEditor.AssetImporters;
using UnityEngine;
using System.IO;

[ScriptedImporter(1, "lua")]
public class RavenscriptImporter : ScriptedImporter
{
	public override void OnImportAsset(AssetImportContext ctx) {
		if(CreateRavenscriptFile.TryConsumeJustCreatedFile()) {
			TryReplaceDefaultContent(ctx.assetPath);
		}

		var textAsset = new TextAsset(File.ReadAllText(ctx.assetPath));
		ctx.AddObjectToAsset("Text", textAsset);
		ctx.SetMainObject(textAsset);
	}

	static void TryReplaceDefaultContent(string path) {
		try {
			FileInfo file = new FileInfo(path);
			string fileName = file.Name.Substring(0, file.Name.Length - 4);
			if (fileName == CreateRavenscriptFile.DEFAULT_BEHAVIOUR_NAME) {
				return;
			}

			var content = File.ReadAllText(path);
			if (content == CreateRavenscriptFile.DEFAULT_CONTENT) {
				File.WriteAllText(path, CreateRavenscriptFile.GenerateContent(fileName));
			}
		} catch { }
	}
}

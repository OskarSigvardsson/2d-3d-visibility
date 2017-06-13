using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GK {
	[RequireComponent(typeof(Camera))]
	[ExecuteInEditMode]
	public class OcclusionCamera : MonoBehaviour {

		public Shader OcclusionShader;

		public Material VisibilityMapMaterial;
		public Material VisibilityVolumeMaterial;
		public Material CumulativeVisibilityVolumeMaterial;

		public RenderTexture OcclusionTexture;
		public RenderTexture VisibilityMapTexture;
		public RenderTexture VisibilityVolumeTexture;
		public RenderTexture CumulativeVisibilityVolumeTexture;

		public Transform Player;

		Camera cam;

		void Start() {
			CumulativeVisibilityVolumeTexture = new RenderTexture(
					2048, 
					2048, 
					0,
					RenderTextureFormat.RHalf);

			CumulativeVisibilityVolumeTexture.Create();
		}

		void Update() {
			if (cam == null) cam = GetComponent<Camera>();

			cam.SetReplacementShader(OcclusionShader, "");
		}

		void OnPostRender() {
			var mat = 
				Matrix4x4.TRS(0.5f * Vector3.one, Quaternion.identity, 0.5f * Vector3.one)
				* cam.projectionMatrix 
				* cam.worldToCameraMatrix;

			
			Debug.Log(mat.MultiplyPoint(Player.position));
			VisibilityMapMaterial.SetVector("player_position", mat.MultiplyPoint(Player.position));
			VisibilityVolumeMaterial.SetVector("player_position", mat.MultiplyPoint(Player.position));

			Graphics.Blit(OcclusionTexture, VisibilityMapTexture, VisibilityMapMaterial);
			Graphics.Blit(VisibilityMapTexture, VisibilityVolumeTexture, VisibilityVolumeMaterial);
			Graphics.Blit(VisibilityVolumeTexture, CumulativeVisibilityVolumeTexture, CumulativeVisibilityVolumeMaterial);

			Shader.SetGlobalTexture("cumulativeVisibilityTexture", CumulativeVisibilityVolumeTexture);
			Shader.SetGlobalTexture("visibilityTexture", VisibilityVolumeTexture);
			Shader.SetGlobalMatrix("visibilityTransform", mat);
		}
	}
}

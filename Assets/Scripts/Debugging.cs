using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GK {
	public class Debugging : MonoBehaviour {

		void OnPostRender() {
			Debug.Log("OnPostRender for gameObject " + gameObject.name + " in frame " + Time.frameCount);
		}
	}
}

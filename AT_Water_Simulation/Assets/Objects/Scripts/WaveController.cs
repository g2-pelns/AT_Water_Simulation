using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WaveController : MonoBehaviour {

    public float height;
    public float waves;
    public float wSpeed;
    public float time;
    public bool on;

	// Use this for initialization
	void Start () {
        on = true;
        //iTween.MoveBy(this.gameObject, iTween.Hash("y", height, "time", time, "looptype", "pingpong", "easetype", iTween.EaseType.easeInOutSine));
        //iTween.MoveBy(this.gameObject, iTween.Hash("x", waves, "time", wSpeed, "looptype", "pingpong", "easetype", iTween.EaseType.easeInOutSine));
    }
	
	// Update is called once per frame
	void Update () {

        if(on == true)
        {
            iTween.MoveBy(this.gameObject, iTween.Hash("y", height, "time", time, "looptype", "pingpong", "easetype", iTween.EaseType.easeInOutSine));
        }
        else if (on == false)
        {
            iTween.MoveBy(this.gameObject, iTween.Hash("x", waves, "time", wSpeed, "looptype", "pingpong", "easetype", iTween.EaseType.easeInOutSine));
        }
		
	}
}

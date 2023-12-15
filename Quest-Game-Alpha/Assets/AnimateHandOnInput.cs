using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// To read and use Input
using UnityEngine.InputSystem;

public class AnimateHandOnInput : MonoBehaviour
{
    // Gain the Reference from XRI in Unity, both the left and right hand
    public InputActionProperty pinchAnimationAction;
    public InputActionProperty gripAnimationAction;

    public Animator handAnimator;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        // how much the button is pressed. A value axis, the input of the trigger button
        float triggerValue = pinchAnimationAction.action.ReadValue<float>();
        Debug.Log(triggerValue);
        handAnimator.SetFloat("Trigger", triggerValue);
        
        float gripValue = gripAnimationAction.action.ReadValue<float>();
        handAnimator.SetFloat("Grip", gripValue);
    }
}

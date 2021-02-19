using UnityEngine;
using System.Collections;

public class FlyCamera : MonoBehaviour
{
    [SerializeField]float mainSpeed = 5.0f; //regular speed
    float quick = 3f;
    float slow = 0.3f;
    [SerializeField]float rotateSens = 0.1f; //How sensitive it with mouse
    public bool localSpace = false;
    public bool canTurn = true;
    private Vector3 lastMouse = new Vector3(255, 255, 255); //kind of in the middle of the screen, rather than at the top (play)

    void Update()
    {
        //Keyboard commands
        float f = 0.0f;
        Vector3 p = GetBaseInput();
        float camRot = rotateSens;
        if (Input.GetKey(KeyCode.LeftAlt))
        {
            p *= slow;
            camRot *= slow;
        }
        else if (Input.GetKey(KeyCode.LeftShift))
        {
            p *= quick;
        }
        if (Input.GetMouseButtonDown(1))
        {
            localSpace = !localSpace;
        }
        if (Input.GetMouseButton(0))
        {
            canTurn = true;
        }
        else
        {
            canTurn = false;
        }

        
            lastMouse = Input.mousePosition - lastMouse;
            lastMouse = new Vector3(-lastMouse.y * camRot, lastMouse.x * camRot, 0);
            lastMouse = new Vector3(transform.eulerAngles.x + lastMouse.x, transform.eulerAngles.y + lastMouse.y, 0);
        if (canTurn)
        {
            transform.eulerAngles = lastMouse;
        }
            lastMouse = Input.mousePosition;
        
        p = p * mainSpeed;

        p = p * Time.deltaTime;
        Vector3 newPosition = transform.position;

        //turning
        if (localSpace)
        {
            transform.Translate(p);
        }
        else
        {
            Vector3 temp = transform.forward;
            transform.forward = new Vector3(temp.x, 0, temp.z);
            transform.Translate(p);
            transform.forward = temp;
        }

    }

    private Vector3 GetBaseInput()
    { //returns the basic values, if it's 0 than it's not active.
        Vector3 p_Velocity = new Vector3();
        if (Input.GetKey(KeyCode.W))
        {
            p_Velocity += new Vector3(0, 0, 1);
        }
        if (Input.GetKey(KeyCode.S))
        {
            p_Velocity += new Vector3(0, 0, -1);
        }
        if (Input.GetKey(KeyCode.A))
        {
            p_Velocity += new Vector3(-1, 0, 0);
        }
        if (Input.GetKey(KeyCode.D))
        {
            p_Velocity += new Vector3(1, 0, 0);
        }
        if (Input.GetKey(KeyCode.Q))
        {
            p_Velocity += new Vector3(0, 1, 0);
        }
        if (Input.GetKey(KeyCode.E))
        {
            p_Velocity += new Vector3(0, -1, 0);
        }
        return p_Velocity;
    }
}
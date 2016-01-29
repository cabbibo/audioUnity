
using UnityEngine;
using System.Collections;


public class PostRenderEvents : MonoBehaviour 
{
  public delegate void CameraPostRender();
  public static event CameraPostRender PostRender;

  void OnPostRender(){
    if( PostRender != null)
      PostRender();
  };


}
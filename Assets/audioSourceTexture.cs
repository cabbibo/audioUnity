using UnityEngine;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
public class audioSourceTexture : MonoBehaviour
{


private int width; // texture width 
private int height; // texture height 
public Color backgroundColor = Color.black; 
public Color waveformColor = Color.green; 
public int size = 16; // size of sound segment displayed in texture

private Color[] blank; // blank image array 
public Texture2D AudioTexture; 
private float[] samples; // audio samples array

void Start ()
{ 
    width = size;
    height = 1;

    // create the samples array 
    samples = new float[size * 4]; 

    // create the AudioTexture and assign to the guiAudioTexture: 
    AudioTexture = new Texture2D(width, height);


    // create a 'blank screen' image 
    blank = new Color[width * height]; 

    for (int i = 0; i < blank.Length; i++) { 
         blank [i] = backgroundColor; 
    } 

 // refresh the display each 100mS 

}

void Update(){
GetCurWave();
}

    void GetCurWave (){ 
        // clear the AudioTexture 
        AudioTexture.SetPixels (blank, 0); 

        // get samples from channel 0 (left) 
        //GetComponent<AudioSource>().GetOutputData (samples, 0); 

        GetComponent<AudioSource>().GetSpectrumData(samples, 0, FFTWindow.Triangle);
        Color c;
        float r , g, b, a;
        // draw the waveform 
        for (int i = 0; i < size; i++) { 

          Color cOG = AudioTexture.GetPixel((int)(width * (i * 2) / size), (int)(1 * (samples[i])) - 1 );


          r = cOG.r * .9f +  samples[ (int)(i * 4 )  + 0 ] * 128 * .2f;
          g = cOG.g * .9f +  samples[ (int)(i * 4 )  + 1 ] * 128 * .2f;
          b = cOG.b * .9f +  samples[ (int)(i * 4 )  + 2 ] * 128 * .2f;
          a = cOG.a * .9f +  samples[ (int)(i * 4 )  + 3 ] * 128 * .2f;

//
          c = new Color( r , g, b, a);

          AudioTexture.SetPixel((int)(width * i / size), (int)(1 * (samples [i])) - 1, c );
        } // upload to the graphics card 

        for (int i = 0; i < size; i++) { 
        //       AudioTexture.SetPixel ((int)(width * i / size), (int)(height * (samples [i] + 1f) / 2f), waveformColor);
       }

        AudioTexture.Apply (); 
    } 
}
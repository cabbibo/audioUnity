Shader "Custom/AudioRaytrace" {
  Properties {
  

    _NumberSteps( "Number Steps", Int ) = 20
    _MaxTraceDistance( "Max Trace Distance" , Float ) = 10.0
    _IntersectionPrecision( "Intersection Precision" , Float ) = 0.0001



  }
  
  SubShader {
    //Tags { "RenderType"="Transparent" "Queue" = "Transparent" }

    Tags { "RenderType"="Opaque" "Queue" = "Geometry" }
    LOD 200

    Pass {
      //Blend SrcAlpha OneMinusSrcAlpha // Alpha blending


      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      // Use shader model 3.0 target, to get nicer looking lighting
      #pragma target 3.0

      #include "UnityCG.cginc"


      uniform int _NumberSteps;
      uniform float  _IntersectionPrecision;
      uniform float _MaxTraceDistance;

      uniform float3 _Hand1;
      uniform float3 _Hand2;

      uniform sampler2D _Audio;
      


      struct VertexIn
      {
         float4 position  : POSITION; 
         float3 normal    : NORMAL; 
         float4 texcoord  : TEXCOORD0; 
         float4 tangent   : TANGENT;
      };
      

      struct VertexOut {
          float4 pos    : POSITION; 
          float3 normal : NORMAL; 
          float4 uv     : TEXCOORD0; 
          float3 ro     : TEXCOORD2;

          //float3 rd     : TEXCOORD3;
          float3 camPos : TEXCOORD4;
      };
        
      #include "Assets/Resources/Shaders/Chunks/signedDistanceBox.cginc"
      #include "Assets/Resources/Shaders/Chunks/signedDistanceSphere.cginc"
      #include "Assets/Resources/Shaders/Chunks/smoothUnion.cginc"

      
      float3 modit(float3 x, float3 m) {
			    float3 r = x%m;
			    return r<0 ? r+m : r;
			}

      float2 map( in float3 pos ){
        
        float2 res;
        float2 lineF;
        float2 sphere;

			  res = float2( signedDistanceBox( pos , float3( .5 , .5 , .5 ) ) , 0.6 );

        float3 modVal = float3( .4 , .4 , .4 );

        float3 n = normalize( pos );

        float4 a = tex2D( _Audio , float2( abs(dot( n , float3( 1. , 0., 0.))), 0.) );
        



        //float2 res2 = float2( signedDistanceSphere( modit(pos , modVal) - modVal / 2. , .1 ) , 0.6 );
       	//res = smoothUnion( res , res2 , 0.1 );

				res.x  += length( a ) * .2;
  	    return res; 

  	  }

      #include "Assets/Resources/Shaders/Chunks/calculateFieldNormalAtPosition.cginc"
      #include "Assets/Resources/Shaders/Chunks/sphereTraceField.cginc"

      VertexOut vert(VertexIn v) {
        
        VertexOut o;

        o.normal = v.normal;
        
        o.uv = v.texcoord;
  
        // Getting the position for actual position
        o.pos = mul( UNITY_MATRIX_MVP , v.position );
     
        float3 mPos = mul( _Object2World , v.position );

        o.ro = v.position;
        o.camPos = mul( _World2Object , float4( _WorldSpaceCameraPos  , 1. )); 

        return o;

      }


     // Fragment Shader
      fixed4 frag(VertexOut i) : COLOR {

        float3 ro = i.ro;
        float3 rd = normalize(ro - i.camPos);

        float3 col = float3( 0.0 , 0.0 , 0.0 );
    		float2 res = sphereTraceField( ro , rd );
    		
    		col= float3( 0. , 0. , 0. );

    		if( res.y > -0.5 ){

    			float3 pos = ro + rd * res.x;
    			float3 norm = calculateFieldNormalAtPosition( pos );
    			col = norm * .5 + .5;

          float fr = max(0.,dot( -rd , norm ));
         // col *= 1. - fr;

          col += tex2D( _Audio , float2( (1. - fr) * .5, 0.) );

    			
    		}
     
    		//col = float3( 1. , 1. , 1. );

        fixed4 color;
        color = fixed4( col  , 1. );
        return color;
      }

      ENDCG
    }
  }
  FallBack "Diffuse"
}

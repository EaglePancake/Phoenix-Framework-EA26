Shader "Custom/RocketPods" {
     Properties {
         _Color ("Color", Color) = (1,1,1,1)
         _MainTex ("Albedo (RGB)", 2D) = "white" {}
         _FalloffTex("Falloff Tex", 2D) = "white" {}
         _Glossiness ("Smoothness", Range(0,1)) = 0.5
         _Metallic ("Metallic", Range(0,1)) = 0.0
         _CutoffUV("Cutoff UV", Range(0,1)) = 0.5
     }
     SubShader {
         Tags { "RenderType" = "Opaque" }
         LOD 200
         
         CGPROGRAM
         #pragma surface surf Standard vertex:vert addshadow
         #pragma target 3.0
         struct Input {
             float2 uv_MainTex;
             float4 vertexColor; // Vertex color stored here by vert() method
         };
 
         sampler2D _FalloffTex;
         half _CutoffUV;

         void vert (inout appdata_full v, out Input o)
         {
             half4 falloffUV = v.texcoord;
             falloffUV.y = falloffUV.y + _CutoffUV - 0.5;
             half multiplier = tex2Dlod(_FalloffTex, falloffUV).r;

             v.vertex = v.vertex * multiplier;
             UNITY_INITIALIZE_OUTPUT(Input,o);
             o.vertexColor = v.color; // Save the Vertex Color in the Input for the surf() method
         }
 
         sampler2D _MainTex;
 
         half _Glossiness;
         half _Metallic;
         fixed4 _Color;
 
         void surf (Input IN, inout SurfaceOutputStandard o) 
         {
             // Albedo comes from a texture tinted by color
             fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
             o.Albedo = c.rgb * IN.vertexColor; // Combine normal color with the vertex color
             // Metallic and smoothness come from slider variables
             o.Metallic = _Metallic;
             o.Smoothness = _Glossiness;
             o.Alpha = c.a;
         }
         ENDCG
     } 
     FallBack "Diffuse"
 }
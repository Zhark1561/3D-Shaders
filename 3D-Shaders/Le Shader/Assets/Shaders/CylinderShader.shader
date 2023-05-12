Shader "Unlit/CylinderShader"
{
    Properties
    {
        ColorA("Color A", Color) = (1, 1, 1, 1)
        ColorB("Color B", Color) = (0, 0, 0, 1)
        WaveAmp("Wave Amp", Range(0, 0.2)) = 0.1
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent" 
            "Queue" = "Transparent"
        }

        Pass
        {
            Cull Off
            ZWrite Off
            Blend One One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            float4 ColorA;
            float4 ColorB;
            float WaveAmp;


            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normals : NORMAL;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;


            };


            Interpolators vert(MeshData v)
            {
                Interpolators o;

                float offset = cos(v.uv0.x * TAU * 8) * 0.01f;
                float waves = cos((v.uv0.y + offset - _Time.y * 0.1f) * TAU * 5) * 0.5f + 0.5f;

                o.vertex.y = waves * 0.1f;


                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;

                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {

                float offset = cos(i.uv.x * TAU * 8) * 0.01f;
                float4 gradient = lerp(ColorA, ColorB, i.uv.y);
                float waves = cos((i.uv.y + offset - _Time.y * 0.1f) * TAU * 5) * 0.5f + 0.5f;
                waves *= (abs(i.normal.y) < 0.999);


                return gradient * waves;
            }
            ENDCG
        }
    }
}

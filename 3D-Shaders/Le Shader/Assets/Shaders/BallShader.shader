Shader "Unlit/BallShader"
{
    Properties
    {
        ColorA("Color A", Color) = (1, 1, 1, 1)
        ColorB("Color B", Color) = (0, 0, 0, 1)
    }
        SubShader
    {
        Tags 
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"

        }


        Pass
        {


            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            #define TAU 6.28318530718

            float4 ColorA;
            float4 ColorB;


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

           

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;

                return o;
            }

            

            float4 frag(Interpolators i) : SV_Target
            {

                float pattern = abs(frac(i.uv.x + i.uv.y * TAU * 3) * 2 - 1);
                float4 gradient = lerp(ColorA, ColorB, i.uv.y);
                
                float4 u = gradient / pattern;

                return u;
            }
            ENDCG
        }
    }
}

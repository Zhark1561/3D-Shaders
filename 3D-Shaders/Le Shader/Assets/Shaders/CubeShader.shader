Shader "Unlit/CubeShader"
{
    Properties
    {
        ColorA("ColorA", Color) = (1,1,1,1)
        ColorA("ColorB", Color) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float4 tangent : TANGENT;
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

                v.vertex.xyz += v.normals * cos(v.uv0.x * v.uv0.y * 8 + _Time.y) * 0.1f;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;

                return o;
            }



            float4 frag(Interpolators i) : SV_Target
            {
                float2 uvsCentered = i.uv * 2 - 1;
                float radialDistance = length(uvsCentered);
                

                return ColorA * radialDistance;
            }
            ENDCG
        }
    }
}

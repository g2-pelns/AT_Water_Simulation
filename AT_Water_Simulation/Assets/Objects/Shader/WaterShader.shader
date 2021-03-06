﻿Shader "Custom/WaterShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,0.5)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		_WScale ("WScale", float) = 1
		_WSpeed("WSpeed", float) = 1
		_WFrequency("WFrequency", float) = 1
		_WAmplitude("WAmplitude", float) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		float _WScale, _WSpeed, _WFrequency, _WAmplitude;

		struct Input {
			float2 uv_MainTex;
			float3 customValue;
		};

		half _Glossiness;
		half _Metallic;
		half4 _Color;
		//fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_CBUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_CBUFFER_END

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
					//SinWaves
			////half offsetvert = v.vertex.x; //Horizontal
			////half offsetvert2 = v.vertex.z; //Vertical
			//half offsetvert = v.vertex.z + v.vertex.x; //Diagonal
			////half offsetvert2 = v.vertex.z - v.vertex.x;
			////half offsetvert2 = (v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z); //From Middle (Ripple Effect)

			//half value = _WScale * sin(_Time.w * _WSpeed + offsetvert * _WFrequency);
			////half value2 = _WScale/2 * sin(_Time.w * _WSpeed + offsetvert2 * _WFrequency);

			//v.vertex.y += value;
			////v.vertex.y += value2;
			//v.normal.y += value;
			////v.normal.y += value2;

					//CrazyGerstnerTest
			//UNITY_INITIALIZE_OUTPUT(Input, o);
			
			//half offsetvert = sin(_Time.w * ((v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z)));
			//half value = _WScale * _WAmplitude * offsetvert * cos(_Time.w * (_WSpeed + offsetvert) * _WFrequency);
			//
			//v.vertex.y += value;
			//o.customValue = value;

					//KindaRandomCoolLokin
			//half offsetvert = cos((v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z));
			////half value = _WScale * cos(_Time.w * _WSpeed + offsetvert * _WFrequency);
			//half value = _WScale * _WAmplitude * offsetvert * cos(_Time.w * (_WSpeed + offsetvert) * _WFrequency);
			//
			//v.vertex.y += value;
			//o.customValue = value;

					//MoreImprovedButStillRippling (WSc_0.02, WSp_0.15, WFr_2, WAm_10)
			//half offsetvert = cos((v.vertex.x * v.vertex.x) + (v.vertex.z * v.vertex.z)) * cos((v.vertex.z * v.vertex.z) + (v.vertex.x * v.vertex.x));
			//half moveOffset = _WScale * cos(_Time.w * _WSpeed + offsetvert * _WFrequency);
			//half value = _WScale * _WAmplitude * moveOffset * cos(_Time.w * (_WSpeed + offsetvert) * _WFrequency);
			//
			//v.vertex.y += value;
			//o.customValue = value;

					//EvenBetterLookin
			//half offsetvert = sin(v.vertex.z + v.vertex.x);
			//half moveOffsetC = sin(v.vertex.z - v.vertex.x);
			////half moveOffsetS = _WScale * sin(_Time.w * -_WSpeed + (2/ moveOffsetC) * _WFrequency);
			//half value = _WScale * cos(_Time.w * _WSpeed *(offsetvert * moveOffsetC) * _WFrequency) / _WAmplitude;
			//
			//v.vertex.y += value;
			//o.customValue = value;

					//WithADiagnolWaveButNoWork
			//half diagSin = v.vertex.z + v.vertex.x; //Diagonal
			//half diagVal = _WScale * sin(_Time.w * _WSpeed + diagSin * _WFrequency);
			//
			//half offsetvert = sin(v.vertex.z + v.vertex.x);
			//half moveOffsetC = sin(v.vertex.z - v.vertex.x);
			//half value = _WScale * cos(_Time.w * _WSpeed *(offsetvert * moveOffsetC) * _WFrequency) / _WAmplitude;
			//
			//v.vertex.y += value + diagVal;
			//o.customValue = value + diagVal;

					//BrokeThePlaneLol
			//half diagSin = v.vertex.z + v.vertex.x; //Diagonal
			//half diagVal = _WScale * sin(_Time.w * _WSpeed + diagSin * _WFrequency);
			//
			//half offsetvert = sin(v.vertex.z + v.vertex.x);
			//half moveOffsetC = sin(v.vertex.z - v.vertex.x);
			//half value = 2 * _WScale * cos(_Time.w * _WSpeed *(offsetvert / moveOffsetC) * _WFrequency) * _WAmplitude;
			//
			//v.vertex.y += value + diagVal;
			//o.customValue = value + diagVal;

					//Best Lookin' Waves atm (WSc_0.01, WSp_1, WFr_2, WAm_10)
			half diagSin = v.vertex.z + v.vertex.x; //Diagonal
			half diagVal = _WScale * sin(_Time.w * _WSpeed + diagSin * _WFrequency);
			
			half offsetvert = sin(v.vertex.z + v.vertex.x);
			half moveOffsetC = sin(v.vertex.z - v.vertex.x);
			half value = 2 * diagVal * cos(_Time.w * _WSpeed * (offsetvert * moveOffsetC) * _WFrequency) * _WAmplitude;
			
			v.vertex.y += value + diagVal;
			o.customValue = value + diagVal;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
			o.Normal.y += IN.customValue;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

					//SomeGoodShit! Buuut looks bad Still no water Texture
			//half diagSin = v.vertex.z + v.vertex.x; //Diagonal
			//half diagVal = _WScale * sin(_Time.w * _WSpeed + diagSin * _WFrequency);
			//
			//half offsetvert = sin(v.vertex.z + v.vertex.x);
			//half moveOffsetC = sin(v.vertex.z - v.vertex.x);
			//half value = 2 * diagVal * cos(_Time.w * _WSpeed * (offsetvert * moveOffsetC) * _WFrequency) * _WAmplitude;
			//
			//v.vertex.y += value + diagVal;
			//o.customValue = value + diagVal;
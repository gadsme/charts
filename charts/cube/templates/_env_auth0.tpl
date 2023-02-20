{{- define "cube.env.oauth0" -}}
{{- if .Values.config.oAuth0.jwkUrl }}
- name: CUBEJS_JWK_URL
  value: {{ .Values.config.oAuth0.jwkUrl | quote }}
{{- end }}
{{- if .Values.config.oAuth0.jwtAudience }}
- name: CUBEJS_JWT_AUDIENCE
  value: {{ .Values.config.oAuth0.jwtAudience | quote }}
{{- end }}
{{- if .Values.config.oAuth0.jwtIssuer }}
- name: CUBEJS_JWT_ISSUER
  value: {{ .Values.config.oAuth0.jwtIssuer | quote }}
{{- end }}
{{- if .Values.config.oAuth0.jwtAlgs }}
- name: CUBEJS_JWT_ALGS
  value: {{ .Values.config.oAuth0.jwtAlgs | quote }}
{{- end }}
{{- if .Values.config.oAuth0.jwtClaimsNamespace }}
- name: CUBEJS_JWT_CLAIMS_NAMESPACE
  value: {{ .Values.config.oAuth0.jwtClaimsNamespace | quote }}
{{- end }}
{{- end }}
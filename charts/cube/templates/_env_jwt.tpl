{{- define "cube.env.jwt" -}}
{{- if .Values.jwt.jwkUrl }}
- name: CUBEJS_JWK_URL
  value: {{ .Values.jwt.jwkUrl | quote }}
{{- end }}
{{- if .Values.jwt.key }}
- name: CUBEJS_JWT_KEY
  value: {{ .Values.jwt.key | quote }}
{{- else if .Values.jwt.keyFromSecret }}
- name: CUBEJS_JWT_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.jwt.keyFromSecret.name | required "jwt.keyFromSecret.name is required" }}
      key: {{ .Values.jwt.keyFromSecret.key | required "jwt.keyFromSecret.key is required" }}
{{- end }}
{{- if .Values.jwt.audience }}
- name: CUBEJS_JWT_AUDIENCE
  value: {{ .Values.jwt.audience | quote }}
{{- end }}
{{- if .Values.jwt.issuer }}
- name: CUBEJS_JWT_ISSUER
  value: {{ .Values.jwt.issuer | quote }}
{{- end }}
{{- if .Values.jwt.subject }}
- name: CUBEJS_JWT_SUBJECT
  value: {{ .Values.jwt.subject | quote }}
{{- end }}
{{- if .Values.jwt.algs }}
- name: CUBEJS_JWT_ALGS
  value: {{ .Values.jwt.algs | quote }}
{{- end }}
{{- if .Values.jwt.claimsNamespace }}
- name: CUBEJS_JWT_CLAIMS_NAMESPACE
  value: {{ .Values.jwt.claimsNamespace | quote }}
{{- end }}
{{- end }}
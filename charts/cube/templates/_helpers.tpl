{{/*
Expand the name of the chart.
*/}}
{{- define "cube.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cube.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cube.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cube.labels" -}}
helm.sh/chart: {{ include "cube.chart" . }}
{{ include "cube.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cube.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cube.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "cube.ingress.apiVersion" -}}
{{- if semverCompare "<1.14-0" .Capabilities.KubeVersion.Version -}}
{{- print "extensions/v1beta1" -}}
{{- else if semverCompare "<1.19-0" .Capabilities.KubeVersion.Version -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- else -}}
{{- print "networking.k8s.io/v1" -}}
{{- end -}}
{{- end -}}

{{/*
Return "true" if the API pathType field is supported
*/}}
{{- define "cube.ingress.supportsPathType" -}}
{{- if semverCompare "<1.18-0" .Capabilities.KubeVersion.Version -}}
{{- print "false" -}}
{{- else -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}

{{/*
Return "true" if the API ingressClassName field is supported
*/}}
{{- define "cube.ingress.supportsIngressClassname" -}}
{{- if semverCompare "<1.18-0" .Capabilities.KubeVersion.Version -}}
{{- print "false" -}}
{{- else -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of cube api service account to use
*/}}
{{- define "cube.api.serviceAccountName" -}}
{{- if .Values.api.serviceAccount.create -}}
  {{ default (printf "%s-api" (include "cube.fullname" .)) .Values.api.serviceAccount.name }}
{{- else -}}
  {{ default "default" .Values.api.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of cube worker service account to use
*/}}
{{- define "cube.worker.serviceAccountName" -}}
{{- if .Values.worker.serviceAccount.create -}}
  {{ default (printf "%s-worker" (include "cube.fullname" .)) .Values.worker.serviceAccount.name }}
{{- else -}}
  {{ default "default" .Values.worker.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a decorated env var using datasource name
https://cube.dev/docs/config/multiple-data-sources#configuring-data-sources-with-environment-variables-decorated-environment-variables
*/}}
{{- define "cube.env.decorated" -}}
{{- $parts := split "CUBEJS_" .key -}}
{{- if eq .datasource "default" -}}
{{- .key }}
{{- else -}}
{{- printf "CUBEJS_DS_%s_%s" (upper .datasource) $parts._1 }}
{{- end -}}
{{- end}}

{{/*
Renders a value that contains template.
Usage:
{{ include "cube.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "cube.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

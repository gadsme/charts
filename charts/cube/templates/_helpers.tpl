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


{{/*
Set the default value for container securityContext
If no value is passed for <node>.securityContexts.container or <node>.securityContext, defaults to UID in the local node.

    +-----------------------------------+      +------------------------+      +-------------+
    | <node>.securityContexts.container |  ->  | <node>.securityContext |  ->  | <node>.uid  |
    +-----------------------------------+      +------------------------+      +-------------+

The template can be called like so:
  include "localContainerSecurityContext" .Values.statsd

It is important to pass the local variables scope to this template as it is used to determine the local node value for uid.
*/}}
{{- define "localContainerSecurityContext" -}}
  {{- if .securityContexts.container -}}
    {{ toYaml .securityContexts.container | print }}
  {{- else if .securityContext -}}
    {{ toYaml .securityContext | print }}
  {{- else -}}
runAsUser: {{ .uid }}
  {{- end -}}
{{- end -}}

{{/* User defined gitSync container environment from */}}
{{- define "custom_git_sync_environment_from" }}
  {{- $Global := . }}
  {{- with .Values.config.gitSync.envFrom }}
    {{- tpl . $Global | nindent 2 }}
  {{- end }}
{{- end }}

{{/*  Git sync container */}}
{{- define "git_sync_container" }}
- name: {{ .Values.config.gitSync.containerName }}{{ if .is_init }}-init{{ end }}
  image: {{ printf "%s:%s" .Values.config.gitSync.image.repository .Values.config.gitSync.image.tag }}
  imagePullPolicy: {{ .Values.config.gitSync.image.pullPolicy }}
  securityContext: {{- include "localContainerSecurityContext" .Values.config.gitSync | nindent 4 }}
  envFrom: {{- include "custom_git_sync_environment_from" . | default "\n  []" | indent 2 }}
  env:
    {{- if or .Values.config.gitSync.sshKeySecret .Values.config.gitSync.sshKey }}
    - name: GIT_SSH_KEY_FILE
      value: "/etc/git-secret/ssh"
    - name: GITSYNC_SSH_KEY_FILE
      value: "/etc/git-secret/ssh"
    - name: GIT_SYNC_SSH
      value: "true"
    - name: GITSYNC_SSH
      value: "true"
    {{- if .Values.config.gitSync.knownHosts }}
    - name: GIT_KNOWN_HOSTS
      value: "true"
    - name: GITSYNC_SSH_KNOWN_HOSTS
      value: "true"
    - name: GIT_SSH_KNOWN_HOSTS_FILE
      value: "/etc/git-secret/known_hosts"
    - name: GITSYNC_SSH_KNOWN_HOSTS_FILE
      value: "/etc/git-secret/known_hosts"
    {{- else }}
    - name: GIT_KNOWN_HOSTS
      value: "false"
    - name: GITSYNC_SSH_KNOWN_HOSTS
      value: "false"
    {{- end }}
    {{ else if .Values.config.gitSync.credentialsSecret }}
    - name: GIT_SYNC_USERNAME
      valueFrom:
        secretKeyRef:
          name: {{ .Values.config.gitSync.credentialsSecret | quote }}
          key: GIT_SYNC_USERNAME
    - name: GITSYNC_USERNAME
      valueFrom:
        secretKeyRef:
          name: {{ .Values.config.gitSync.credentialsSecret | quote }}
          key: GITSYNC_USERNAME
    - name: GIT_SYNC_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ .Values.config.gitSync.credentialsSecret | quote }}
          key: GIT_SYNC_PASSWORD
    - name: GITSYNC_PASSWORD
      valueFrom:
        secretKeyRef:
          name: {{ .Values.config.gitSync.credentialsSecret | quote }}
          key: GITSYNC_PASSWORD
    {{- end }}
    - name: GIT_SYNC_REV
      value: {{ .Values.config.gitSync.rev | quote }}
    - name: GITSYNC_REF
      value: {{ .Values.config.gitSync.ref | quote }}
    - name: GIT_SYNC_BRANCH
      value: {{ .Values.config.gitSync.branch | quote }}
    - name: GIT_SYNC_REPO
      value: {{ .Values.config.gitSync.repo | quote }}
    - name: GITSYNC_REPO
      value: {{ .Values.config.gitSync.repo | quote }}
    - name: GIT_SYNC_DEPTH
      value: {{ .Values.config.gitSync.depth | quote }}
    - name: GITSYNC_DEPTH
      value: {{ .Values.config.gitSync.depth | quote }}
    - name: GIT_SYNC_ROOT
      value: "/git"
    - name: GITSYNC_ROOT
      value: "/git"
    - name: GIT_SYNC_DEST
      value: "repo"
    - name: GITSYNC_LINK
      value: "repo"
    - name: GIT_SYNC_ADD_USER
      value: "true"
    - name: GITSYNC_ADD_USER
      value: "true"
    {{- if .Values.config.gitSync.wait }}
    - name: GIT_SYNC_WAIT
      value: {{ .Values.config.gitSync.wait | quote }}
    {{- end }}
    - name: GITSYNC_PERIOD
      value: {{ .Values.config.gitSync.period | quote }}
    - name: GIT_SYNC_MAX_SYNC_FAILURES
      value: {{ .Values.config.gitSync.maxFailures | quote }}
    - name: GITSYNC_MAX_FAILURES
      value: {{ .Values.config.gitSync.maxFailures | quote }}
    {{- if .is_init }}
    - name: GIT_SYNC_ONE_TIME
      value: "true"
    - name: GITSYNC_ONE_TIME
      value: "true"
    {{- end }}
    {{- with .Values.config.gitSync.env }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  resources: {{ toYaml .Values.config.gitSync.resources | nindent 4 }}
  volumeMounts:
  - name: schemas
    mountPath: /git
  {{- if or .Values.config.gitSync.sshKeySecret .Values.config.gitSync.sshKey }}
  - name: git-sync-ssh-key
    mountPath: /etc/git-secret/ssh
    readOnly: true
    subPath: gitSshKey
  {{- if .Values.config.gitSync.knownHosts }}
  - name: git-sync-ssh-known-hosts
    mountPath: /etc/git-secret/known_hosts
    readOnly: true
    subPath: known_hosts
  {{- end }}
  {{- end }}
  {{- if .Values.config.gitSync.extraVolumeMounts }}
    {{- tpl (toYaml .Values.config.gitSync.extraVolumeMounts) . | nindent 2 }}
  {{- end }}
  {{- if and .Values.config.gitSync.containerLifecycleHooks (not .is_init) }}
  lifecycle: {{- tpl (toYaml .Values.config.gitSync.containerLifecycleHooks) . | nindent 4 }}
  {{- end }}
{{- end }}

{{- define "git_sync_mount" -}}
- name: schemas
  {{- if .Values.config.schemaPath }}
  mountPath: {{ .Values.config.schemaPath }}
  {{- end }}
  readOnly: True
{{- end }}

{{/* Create the name of the git sync ssh secret to use */}}
{{- define "git_sync_ssh_key" -}}
  {{- default (printf "%s-ssh-secret" (include "cube.fullname" .)) .Values.config.gitSync.sshKeySecret }}
{{- end }}

{{/* Create the name of the git sync known hosts configmap to use */}}
{{- define "git_sync_known_hosts" -}}
  {{- default (printf "%s-ssh-known-hosts" (include "cube.fullname" .)) .Values.config.gitSync.sshKeySecret }}
{{- end }}

{{/*  Git ssh key volume */}}
{{- define "git_sync_ssh_key_volume" }}
- name: git-sync-ssh-key
  secret:
    secretName: {{ template "git_sync_ssh_key" . }}
    defaultMode: 288
{{- end }}

{{/*  Git ssh known hosts volume */}}
{{- define "git_sync_known_hosts_volume" }}
- name: git-sync-ssh-known-hosts
  configMap:
    name: {{ template "git_sync_known_hosts" . }}
    defaultMode: 288
{{- end }}


{{- define "schema_path" -}}
  {{- if .Values.config.gitSync.enabled }}
    {{- printf "%s/repo/%s" .Values.config.schemaPath .Values.config.gitSync.subPath }}
  {{- else }}
    {{- printf "%s" .Values.config.schemaPath }}
  {{- end }}
{{- end }}

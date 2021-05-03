{{- define "common.kubernetes.microservice" -}}
{{/* Check required top level variables */}}
{{- $globalError := "\nYou must define team and severity labels at the global level\nglobal:\n  labels:\n    team: ops\n    severity: noncritical\n"}}
{{- $global := required $globalError .Values.global}}
{{- $labels := required $globalError $global.labels}}
{{- $team := required $globalError $labels.team }}
{{- $severity := required $globalError $labels.severity }}
{{- if not (regexMatch "^critical$|^noncritical$" $severity) }}{{ fail (printf "\n\nInvalid severity: %s\nMust specify noncritical or critical for severity level" $severity) }}{{ end }}
{{- include "common.kubernetes.deployment" . }}
{{- end }}

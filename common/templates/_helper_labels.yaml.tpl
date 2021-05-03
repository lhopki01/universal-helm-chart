{{- define "common.helper.labels" -}}
{{- if and (kindIs "map" .override) (kindIs "map" .global) }}
{{- toYaml (merge .override .global) }}
{{- else if (kindIs "map" .override) }}
{{- toYaml .override }}
{{- else if (kindIs "map" .global ) }}
{{- toYaml .global }}
{{- end }}
{{- end }}

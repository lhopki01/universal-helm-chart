{{- define "common.annotations" -}}
{{- if and (kindIs "map" .override) (kindIs "map" .global) }}
annotations:
{{ toYaml (merge .override .global) | indent 2 }}
{{ else if (kindIs "map" .override) }}
annotations:
{{ toYaml .override | indent 2 }}
{{ else if (kindIs "map" .global ) }}
annotations:
{{ toYaml .global | indent 2 }}
{{- end }}
{{- end }}

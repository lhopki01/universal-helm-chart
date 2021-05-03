{{- define "common.helper.mergeGlobalMap" -}}
{{- if and (kindIs "map" .override) (kindIs "map" .global) }}
{{- toYaml (mergeOverwrite .global .override ) }}
{{- else if (kindIs "map" .override) }}
{{- toYaml .override }}
{{- else if (kindIs "map" .global ) }}
{{- toYaml .global }}
{{- end }}
{{- end }}


{{- define "common.helper.env" -}}
{{- range $k, $v := . }}
{{- if kindIs "map" $v }}
- name: {{ $k }}
{{ toYaml $v | indent 2 }}
{{- else }}
- name: {{ $k }}
  value: {{ $v }}
{{- end }}
{{- end }}
{{- end }}

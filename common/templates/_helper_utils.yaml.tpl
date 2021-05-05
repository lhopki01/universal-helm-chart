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
  value: {{ quote $v }}
{{- end }}
{{- end }}
{{- end }}

{{- define "common.helper.labels" -}}
{{- $labels := dict }}
{{- if and (kindIs "map" .override) (kindIs "map" .global) }}
{{- $labels = (mergeOverwrite .global .override ) }}
{{- else if (kindIs "map" .override) }}
{{- $labels = .override }}
{{- else if (kindIs "map" .global ) }}
{{- $labels = .global }}
{{- end }}
{{- $_ := set $labels "app" .name }}
{{- $_ := set $labels "chart" .chart.Name }}
{{- $_ := set $labels "chartVersion" .chart.Version }}
{{- toYaml $labels }}
{{- end }}

{{- define "common.helper.annotations" -}}
{{- $annotations := dict }}
{{- if and (kindIs "map" .override) (kindIs "map" .global) }}
{{- $annotations = (mergeOverwrite .global .override ) }}
{{- else if (kindIs "map" .override) }}
{{- $annotations = .override }}
{{- else if (kindIs "map" .global ) }}
{{- $annotations = .global }}
{{- end }}
{{- $_ := set $annotations "figment.io/sourceTemplate" "https://github.com/figment-networks/helm/common" }}
{{- toYaml $annotations }}
{{- end }}

{{- define "common.kubernetes.deployment" -}}
{{- $chart := .Chart }}
{{- $global := .Values.global }}
{{- with .Values.deployments }}
{{- range $k, $v := . }}
{{ $selector := printf "deployment-%v-%v" $chart.Name $k }}
{{ $annotations := include "common.helper.mergeGlobalMap" (dict "override" $v.annotations "global" $global.annotations ) }}
{{ $labels := include "common.helper.mergeGlobalMap" (dict "override" $v.labels "global" $global.labels ) }}
{{- with $v.service }}
{{ include "common.kubernetes.service" (dict "name" $k "selector" $selector "service" .) }}
{{- end }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $k }}
  annotations:
    figment.io/sourceTemplate: "https://url"
{{ $annotations | indent 4 }}
  labels:
    Chart: {{ $chart.Name }}
    app: {{ $k }}
{{ $labels | indent 4 }}
spec:
  replicas: {{ required (printf "You must set a replicas count for deployment [%s]" $k ) $v.replicas }}
  selector:
    matchLabels:
      selector: {{ $selector }}
  template:
{{- include "common.kubernetes.podtemplatespec" (dict "name" $k "global" $global "selector" $selector "pod" $v ) | indent 4 }}
{{- end }}
{{- end }}
{{- end }}

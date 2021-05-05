{{- define "common.kubernetes.deployment" -}}
{{- $chart := .Chart }}
{{- $global := .Values.global }}
{{- with .Values.deployments }}
{{- range $k, $v := . }}
{{ $selector := printf "deployment-%v-%v" $chart.Name $k }}
{{ $annotations := include "common.helper.annotations" (dict "global" $global.annotations "override" $v.annotations ) }}
{{ $labels := include "common.helper.labels" (dict "global" $global.labels "override" $v.labels "chart" $chart "name" $k ) }}
{{- with $v.service }}
{{ include "common.kubernetes.service" (dict "name" $k "labels" $labels "annotations" $annotations "selector" $selector "service" .) }}
{{- end }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $k }}
  annotations:
{{ $annotations | indent 4 }}
  labels:
{{ $labels | indent 4 }}
spec:
  replicas: {{ required (printf "You must set a replicas count for deployment [%s]" $k ) $v.replicas }}
  selector:
    matchLabels:
      selector: {{ $selector }}
  template:
{{- include "common.kubernetes.podtemplatespec" (dict "labels" $labels "annotations" $annotations "global" $global "selector" $selector "pod" $v ) | indent 4 }}
{{- end }}
{{- end }}
{{- end }}

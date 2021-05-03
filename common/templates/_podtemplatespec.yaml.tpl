{{ define "common.kubernetes.podtemplatespec" }}
{{- $name := .global.name }}
metadata:
  labels:
    selector: {{ .selector }}
spec:
{{- include "common.kubernetes.podspec" .  | indent 2 }}
{{- end }}

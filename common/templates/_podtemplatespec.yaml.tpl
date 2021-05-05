{{- define "common.kubernetes.podtemplatespec" }}
metadata:
  annotations:
{{ .annotations | indent 4 }}
  labels:
    selector: {{ .selector }}
{{ .labels | indent 4 }}
spec:
{{- include "common.kubernetes.podspec" .  | indent 2 }}
{{- end }}

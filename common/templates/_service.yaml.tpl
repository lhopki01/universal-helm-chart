{{- define "common.kubernetes.service" -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .name }}
  annotations:
{{ .annotations | indent 4 }}
  labels:
{{ .labels | indent 4 }}
spec:
  selector:
    selector: {{ .selector }}
{{- with .service.type }}
  type: {{ . }}{{- end }}
  ports:
{{- range $k, $v := .service.ports }}
  - name: {{ $k }}
{{ toYaml $v | indent 4 }}
{{- end }}
{{- end }}

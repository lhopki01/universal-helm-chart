{{- define "common.kubernetes.service" -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .name }}
  labels:
    app: {{ .name }}
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

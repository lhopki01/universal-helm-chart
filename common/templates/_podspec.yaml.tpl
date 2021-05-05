{{- define "common.kubernetes.podspec" }}
{{- $global := .global }}
imagePullSecrets:
  - name: {{ default "foobar" .pod.imagePullSecretsName }}
{{- if .pod.serviceAccountEnabled }}
serviceAccountName: {{ .selector }}{{ end }}
automountServiceAccountToken: {{ default false .pod.serviceAccountEnabled }}
affinity:
{{- with .affinity }}
{{ toYaml . | indent 2 }}{{- end }}
{{- if not (default false .pod.disableZonalAntiAffinity) }}
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: selector
            operator: In
            values:
            - {{ .selector }}
        topologyKey: failure-domain.beta.kubernetes.io/zone
{{- end }}
{{- with .pod.tolerations }}
tolerations:
{{- toYaml . | indent 2 }}{{- end }}
restartPolicy: {{ default "Always" .pod.restartPolicy }}
{{- with .pod.initContainers }}
initContainers:
{{ toYaml . }}{{- end }}
containers:
{{- range $k, $v := .pod.containers }}
- name: {{ $k }}
  image: {{ required (printf "You must define an image for container [%s]" $k) $v.image }}
  imagePullPolicy: {{ default "Always" $v.imagePullPolicy }}
{{- with $v.command }}
  command:
{{ toYaml . | indent 2 }}{{- end }}
{{- with $v.args }}
  args:
{{ toYaml . | indent 2 }}{{- end }}
  securityContext:
{{ toYaml (mergeOverwrite (dict "runAsNonRoot" true) (default dict $v.securityContext)) | indent 4 }}
  env:
{{- include "common.helper.env" ( fromYaml (include "common.helper.mergeGlobalMap" (dict "override" $v.env "global" $global.env ))) | indent 2 }}
{{- /* required "You must define a livenessProbe" $v.livenessProbe */}}
{{- $probe := required "You must define a livenessProbe" $v.livenessProbe }}
{{- if not $probe.disabled }}
{{- if (or (hasKey $probe "tcpSocket") (or (hasKey $probe "exec") (hasKey $probe "httpGet")))}}
{{- with $probe }}
  livenessProbe:
    initialDelaySeconds: {{ default 0 .initialDelaySeconds }}
    periodSeconds: {{ default 5 .periodSeconds }}
    timeoutSeconds: {{ default 1 .timeoutSeconds }}
    failureThreshold: {{ default 5 .failureThreshold }}
    successThreshold: {{ default 1 .successThreshold }}
{{- with .tcpSocket }}
    tcpSocket:
{{ toYaml . | indent 6 }}{{- end }}
{{- with .exec }}
    exec:
{{ toYaml . | indent 6 }}{{- end }}
{{- with .httpGet }}
    httpGet:
{{ toYaml . | indent 6 }}{{- end }}
{{- end -}}
{{- else }}{{- fail "\n\nERROR: You must define a livenessProbe. To disabled set:\n\n        livenessProbe:\n          disabled: true" }}
{{- end -}}
{{- end -}}
{{- $probe := required "You must define a readinessProbe" $v.readinessProbe }}
{{- if not $probe.disabled }}
{{- if (or (hasKey $probe "tcpSocket") (or (hasKey $probe "exec") (hasKey $probe "httpGet")))}}
{{- with $v.readinessProbe }}
  readinessProbe:
    initialDelaySeconds: {{ default 0 .initialDelaySeconds }}
    periodSeconds: {{ default 5 .periodSeconds }}
    timeoutSeconds: {{ default 1 .timeoutSeconds }}
    failureThreshold: {{ default 1 .failureThreshold }}
    successThreshold: {{ default 5 .successThreshold }}
{{- with .tcpSocket }}
    tcpSocket:
{{ toYaml . | indent 6 }}{{- end }}
{{- with .exec }}
    exec:
{{ toYaml . | indent 6 }}{{- end }}
{{- with .httpGet }}
    httpGet:
{{ toYaml . | indent 6 }}{{- end }}
{{- end -}}
{{- else }}{{- fail "\n\nERROR: You must define a readinessProbe. To disabled set:\n\n        readinessProbe:\n          disabled: true" }}
{{- end -}}
{{- end -}}
{{ $resourcesError := printf "\n\nERROR: You must specify resources for container [%v]. e.g.\nresources:\n  limits:\n    memory: 100Mi\n  requests:\n    cpu: 30m\n    memory: 200Mi\n" $k }}
{{- $resources := required $resourcesError $v.resources }}
  resources:
{{- $limits := required $resourcesError $resources.limits }}
    limits:
      memory: {{ required $resourcesError $limits.memory }}
    requests:
      cpu: {{ required $resourcesError $resources.requests.cpu }}
      memory: {{ required $resourcesError $resources.requests.memory }}
{{- with $v.volumeMounts }}
  volumeMounts:
{{ toYaml . | indent 4 }}{{- end }}
{{- end }}
{{- end }}

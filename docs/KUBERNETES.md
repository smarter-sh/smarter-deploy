# Kubernetes Deployment Instructions

## Smarter Helm Chart

Deploy Smarter API and web console to Kubernetes using the public Helm chart, available at [ghcr.io/smarter-sh/charts/smarter](https://ghcr.io/smarter-sh/charts/smarter) or [Artifact Hub](https://artifacthub.io/packages/helm/project-smarter/smarter).

### Quick Install

```console
helm upgrade --install --force smarter oci://ghcr.io/smarter-sh/charts/smarter \
  --version 0.8.10 \
  --timeout 900s \
  --create-namespace \
  --namespace smarter \
  --set env.OPENAI_API_KEY=<your-openai-api-key> \
  --set env.GOOGLE_MAPS_API_KEY=<your-google-api-key>
  --values values.yaml
```

See [values.yaml](https://github.com/smarter-sh/smarter/blob/main/helm/charts/smarter/values.yaml) for all available configuration options.

**IMPORTANT: Do not commit secrets, passwords, api keys and other sensitive data to GitHub.**

### Configuration

See the [chart values.yaml](./helm/charts/smarter/values.yaml) for all available parameters, or view the [chart README](./helm/charts/smarter/README.md) for detailed configuration examples.

Minimum required configuration in your `values.yaml`:

```yaml
env:
  OPENAI_API_KEY: "YOUR-OPENAI-API-KEY"
  GOOGLE_MAPS_API_KEY: "YOUR-GOOGLE-MAPS-API-KEY"
  GEMINI_API_KEY: "YOUR-GEMINI-API-KEY"
  LLAMA_API_KEY: "LLAMA-API-KEY"
```

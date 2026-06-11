# Deploy Coder on Zeabur

This fork includes a small Zeabur wrapper around the official Coder image.
Zeabur detects the root `Dockerfile`, injects `PORT`, and the entrypoint maps it
to Coder's `CODER_HTTP_ADDRESS`.

## Deploy

1. In Zeabur, create a project and add a PostgreSQL service.
1. Add this repository as a GitHub service.
1. Integrate the PostgreSQL service with the Coder service so Zeabur injects
   its generated `POSTGRES_URI` variable. The entrypoint uses `POSTGRES_URI`
   directly and maps it to `CODER_PG_CONNECTION_URL`.
1. Bind a domain to the Coder service. The entrypoint uses Zeabur's
   `${ZEABUR_WEB_URL}` as `CODER_ACCESS_URL` when you do not set
   `CODER_ACCESS_URL` yourself.
1. Deploy the service and open the bound domain.

## Optional Variables

Set these on the Coder service when you need explicit control:

```env
CODER_ACCESS_URL=https://coder.example.com
CODER_WILDCARD_ACCESS_URL=*.coder.example.com
```

The entrypoint automatically appends `sslmode=disable` when the PostgreSQL URL
does not already include an `sslmode` parameter. This matches Zeabur's internal
PostgreSQL service.

## Notes

- Use an external PostgreSQL service for persistence. Coder can start without
  `CODER_PG_CONNECTION_URL`, but the built-in database is not a good fit for
  stateless container redeploys.
- Zeabur does not deploy this repository's `compose.yaml` directly; it deploys
  the root `Dockerfile`.
- Docker socket based Coder templates are not available unless your Zeabur
  runtime exposes Docker. Cloud, Kubernetes, or external provisioner templates
  are better fits for this deployment style.

1. Start elasticsearch 

Copy `.env.example` to `.env` and set values for `ELASTICSEARCH_PASSWORD`

```bash
docker compose up -d
```

Visit http://localhost:9200 to verify elasticsearch running with sample data.

2. Initialize Hasura Supergraph

Pre-requisites: Hasura DDN CLI.

```bash
ddn auth login
ddn supergraph init .
```

3. Initialize Connector

```bash
ddn connector init -i
```

4. Enter values for environment variables

```yaml
ELASTICSEARCH_URL=http://local.hasura.dev:9200
ELASTICSEARCH_USERNAME=elastic
ELASTICSEARCH_PASSWORD=elasticpwd
```

5. Introspect the connector

```bash
ddn connector introspect elasticsearch --add-all-resources
```

6. Start Supergraph Service

```bash
HASURA_DDN_PAT=$(ddn auth print-pat) docker compose --env-file .env up --build --pull=always --watch
```

7. Build Supergraph locally

```bash
ddn supergraph build local
```

Visit https://console.hasura.io/local/graphql?url=http://localhost:3000
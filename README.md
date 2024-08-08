1. Start elasticsearch and verify if its running with sample data.

```bash
docker compose up -d
```

2. Initialize Supergraph

```bash
ddn supergraph init --dir .
```

3. Start Supergraph

```bash
HASURA_DDN_PAT=$(ddn auth print-pat) docker compose up --build --watch
```

Visit https://console.hasura.io/local/graphql?url=http://localhost:3000

4. Set the Supergraph context

```bash
ddn context set supergraph ./supergraph.local.yaml
```

5. Create a local build

```bash
ddn supergraph build local --output-dir engine
```

6. Create a Subgraph

```bash
ddn subgraph init my_subgraph \
  --dir my_subgraph \
  --target-supergraph supergraph.local.yaml \
  --target-supergraph supergraph.cloud.yaml
```

7. Set Subgraph context

```bash
ddn context set subgraph ./my_subgraph/subgraph.yaml
```

8. Connect a data source (Elasticsearch)

```bash
ddn connector init elasticsearch \
  --hub-connector hasura/elasticsearch \
  --configure-port 8082 \
  --add-to-compose-file compose.yaml
```

9. Setup Environment variables in the connector .env.local file

```bash
OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=http://local.hasura.dev:4317
OTEL_SERVICE_NAME=my_subgraph_elasticsearch
ELASTICSEARCH_URL=http://host.docker.internal:9200
ELASTICSEARCH_USERNAME=elastic
ELASTICSEARCH_PASSWORD=elasticpwd
```

10. Introspect data source

```bash
ddn connector introspect --connector my_subgraph/connector/elasticsearch/connector.local.yaml
```

Restart the build command

TEMP: Copy configuration.json to root directory

11. Verify schema generation

Visit http://localhost:8082/schema

12. Connector Linking

```bash
ddn connector-link add elasticsearch \
  --configure-host http://local.hasura.dev:8082 \
  --target-env-file my_subgraph/.env.my_subgraph.local
```

13. Connector Link Update

```bash
ddn connector-link update elasticsearch \
  --env-file my_subgraph/.env.my_subgraph.local
```

14. Add/Track all models

```bash
ddn connector-link update elasticsearch \
  --env-file my_subgraph/.env.my_subgraph.local \
  --add-all-resources
```

15. Build Supergraph locally

Temporary: Remove scalar type `date_range_query` from connector metadata.

```bash
ddn supergraph build local \
  --output-dir engine \
  --subgraph-env-file my_subgraph:my_subgraph/.env.my_subgraph.local
```



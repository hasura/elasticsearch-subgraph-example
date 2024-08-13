#!/bin/sh

# Wait for Elasticsearch to be up and running
until curl -u "$ELASTIC_USERNAME:$ELASTIC_PASSWORD" -s http://es01:9200 -k; do
  echo "Waiting for Elasticsearch to be available..."
  sleep 5
done

# Check if the products index exists
if curl -u "$ELASTIC_USERNAME:$ELASTIC_PASSWORD" -s http://es01:9200/products -k | grep '"uuid"'; then
  echo "Products index already exists. Skipping data ingestion for products."
else
  echo "Creating and ingesting data into products index."
  curl -X POST "http://es01:9200/_bulk" -k -u "$ELASTIC_USERNAME:$ELASTIC_PASSWORD" -H 'Content-Type: application/json' --data-binary @/products.json
fi

# Check if the users index exists
if curl -u "$ELASTIC_USERNAME:$ELASTIC_PASSWORD" -s http://es01:9200/users -k | grep '"uuid"'; then
  echo "Users index already exists. Skipping data ingestion for users."
else
  echo "Creating and ingesting data into users index."
  curl -X POST "http://es01:9200/_bulk" -k -u "$ELASTIC_USERNAME:$ELASTIC_PASSWORD" -H 'Content-Type: application/json' --data-binary @/users.json
fi


# Check if the logs index exists
if curl -u "$ELASTIC_USERNAME:$ELASTIC_PASSWORD" -s http://es01:9200/logs -k | grep '"uuid"'; then
  echo "Logs index already exists. Skipping data ingestion for logs."
else
  echo "Creating and ingesting data into logs index."
  curl -X POST "http://es01:9200/_bulk" -k -u "$ELASTIC_USERNAME:$ELASTIC_PASSWORD" -H 'Content-Type: application/json' --data-binary @/logs.json
fi

echo "Data ingestion complete."

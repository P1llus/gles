import gleam/dynamic.{type Dynamic}
import gleam/http.{Delete, Get, Put}
import gleam/http/response.{type Response}
import gleam/option.{type Option, None}
import gles/client.{type Client, Client, create_request, send_request}

/// Creates a new Elasticsearch index, with an optional body as a encoded JSON String.
/// 
/// **API Reference:** https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html#indices-create-api-request-body
pub fn create_index(
  client: Client,
  index: String,
  body: Option(String),
) -> Result(Response(String), Dynamic) {
  create_request(client, "/" <> index, Put, body)
  |> send_request(client, _)
}

/// Retrieves the relevant index information from Elasticsearch.
/// 
/// **API Reference:** https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-get-index.html
pub fn get_index(
  client: Client,
  index: String,
) -> Result(Response(String), Dynamic) {
  create_request(client, "/" <> index, Get, None)
  |> send_request(client, _)
}

/// Deletes the relevant index from Elasticsearch.
/// 
/// **API Reference:** https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-delete-index.html#delete-index-api-request
pub fn delete_index(
  client: Client,
  index: String,
) -> Result(Response(String), Dynamic) {
  create_request(client, "/" <> index, Delete, None)
  |> send_request(client, _)
}

import gleam/dynamic.{type Dynamic}
import gleam/http.{Delete, Get, Post, Put}
import gleam/http/response.{type Response}
import gleam/option.{type Option, None, Some}
import gles/client.{type Client, Client, create_request, send_request}

/// Creates the provided document on the relevant index.
/// 
/// Only use the `id` parameter when absolutely necessary, as elasticsearch will automatically generate an id for you.
/// 
/// **API Reference:** https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html#docs-index-api-request-body
pub fn add_document(
  client: Client,
  index: String,
  body: Option(String),
  id: Option(String),
) -> Result(Response(String), Dynamic) {
  case id {
    None -> create_request(client, "/" <> index <> "/_doc", Post, body)
    Some(id) ->
      create_request(client, "/" <> index <> "/_create/" <> id, Post, body)
  }
  |> send_request(client, _)
}

/// Deletes the provided document id from the relevant index.
/// 
/// Only documents stored on a regular index is supported, Data streams are append only and cannot be deleted.
/// 
/// **API Reference:** https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete.html#docs-delete-api-example
pub fn delete_document(
  client: Client,
  index: String,
  id: String,
) -> Result(Response(String), Dynamic) {
  create_request(client, "/" <> index <> "/_doc/" <> id, Delete, None)
  |> send_request(client, _)
}

/// Retrieves the provided document id from the relevant index.
/// 
/// **API Reference:** https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html#docs-get-api-example
pub fn get_document(
  client: Client,
  index: String,
  id: String,
) -> Result(Response(String), Dynamic) {
  create_request(client, "/" <> index <> "/_doc/" <> id, Get, None)
  |> send_request(client, _)
}

/// Bulk multiple document actions into a single request.
/// 
/// This function is recommended when you need to perform multiple actions like creating many documents at the same time.
/// 
/// The API body expects each action to be a NDJSON object with the action type and relevant parameters.
/// Followed by the document body.
/// The last line needs to always end with a newline character.
/// 
/// **API Reference:** https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html#docs-bulk-api
pub fn bulk_action(
  client: Client,
  index: String,
  body: String,
) -> Result(Response(String), Dynamic) {
  create_request(client, "/" <> index <> "/_bulk", Put, Some(body))
  |> send_request(client, _)
}

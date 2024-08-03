import gleam/http.{Https}
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should
import gles
import gles/client
import gles/documents
import gles/index

pub fn main() {
  gleeunit.main()
}

// Tests all the related documents functions.
pub fn documents_test() {
  let test_client =
    gles.new(host: "localhost:9200", scheme: Https, verify_tls: False)

  let new_client =
    client.set_auth(
      client: test_client,
      auth_type: "basic",
      auth_value: "elastic:changeme",
    )

  // Creates a new index used for testing.
  let body =
    Some(
      "{ \"settings\": { \"number_of_shards\": 1, \"number_of_replicas\": 0 } }",
    )
  let assert Ok(resp) = index.create_index(new_client, "test-documents", body)
  resp.status |> should.equal(200)

  // Creates a new document successfully
  let assert Ok(resp) =
    documents.add_document(
      new_client,
      "test-documents",
      Some("{ \"title\": \"Test Document\" }"),
      None,
    )
  resp.status |> should.equal(201)

  // Creates a new document with specific id successfully
  let assert Ok(resp) =
    documents.add_document(
      new_client,
      "test-documents",
      Some("{ \"title\": \"Test Document\" }"),
      Some("2"),
    )
  resp.status |> should.equal(201)

  // Retrieves the document information successfully
  let assert Ok(resp) =
    documents.get_document(new_client, "test-documents", "2")
  resp.status |> should.equal(200)

  // Deletes the document successfully
  let assert Ok(resp) =
    documents.delete_document(new_client, "test-documents", "2")
  resp.status |> should.equal(200)

  // Bulk actions on multiple documents
  let body =
    "{ \"index\": { \"_index\": \"test-documents\" } }
    { \"title\": \"Bulk Document 1\" }
    { \"index\": { \"_index\": \"test-documents\" } }
    { \"title\": \"Bulk Document 2\" }\n"
  let assert Ok(resp) =
    documents.bulk_action(new_client, "test-documents", body)
  resp.status |> should.equal(200)

  // Deletes the index used for testing.
  let assert Ok(resp) = index.delete_index(new_client, "test-documents")
}

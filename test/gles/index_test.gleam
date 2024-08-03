import gleam/http.{Https}
import gleam/option.{Some}
import gleeunit
import gleeunit/should
import gles
import gles/client
import gles/index

pub fn main() {
  gleeunit.main()
}

// Tests all the related index functions.
pub fn index_test() {
  let test_client =
    gles.new(host: "localhost:9200", scheme: Https, verify_tls: False)

  let new_client =
    client.set_auth(
      client: test_client,
      auth_type: "basic",
      auth_value: "elastic:changeme",
    )

  // Creates a new index successfully
  let body =
    Some(
      "{ \"settings\": { \"number_of_shards\": 2, \"number_of_replicas\": 0 } }",
    )
  let assert Ok(resp) = index.create_index(new_client, "test-index", body)
  resp.status |> should.equal(200)

  // Retrieves the index information successfully
  let assert Ok(resp) = index.get_index(new_client, "test-index")
  resp.status |> should.equal(200)

  // Running it again fails because the index already exists
  let assert Ok(resp) = index.create_index(new_client, "test-index", body)
  resp.status |> should.equal(400)

  // Deletes the index successfully
  let assert Ok(resp) = index.delete_index(new_client, "test-index")
  resp.status |> should.equal(200)
}

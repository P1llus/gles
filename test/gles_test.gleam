import gleam/http.{Https}
import gleam/io
import gleeunit
import gleeunit/should
import gles
import gles/client
import gles/index

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn new_test() {
  let test_client =
    gles.new(host: "localhost:9200", scheme: Https, verify_tls: False)
  let new_client =
    client.set_auth(
      client: test_client,
      auth_type: "basic",
      auth_value: "elastic:changeme",
    )
  let assert Ok(resp) = client.ping(new_client)
  resp.status |> should.equal(200)

  let assert Ok(resp) = index.create_index(new_client)
  io.debug(resp)
  resp.status |> should.equal(200)
}

import gleam/http.{Https}
import gleam/option.{None}
import gleeunit
import gleeunit/should
import gles
import gles/client.{Client}

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn new_test() {
  gles.new(host: "localhost:9200", scheme: Https, verify_tls: False)
  |> should.equal(Client(
    host: "localhost:9200",
    scheme: Https,
    verify_tls: False,
    auth_type: None,
    auth_value: None,
  ))
}

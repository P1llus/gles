import gleam/http.{type Scheme}
import gles/client.{type Client, Client, create_client}

pub fn new(
  host host: String,
  scheme scheme: Scheme,
  verify_tls verify_tls: Bool,
) -> Client {
  create_client(host: host, scheme: scheme, verify_tls: verify_tls)
}

import gleam/bit_array.{base64_encode}
import gleam/dynamic.{type Dynamic}
import gleam/http.{type Method, type Scheme, Get}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/httpc
import gleam/option.{type Option, None, Some}

pub type Client {
  Client(
    host: String,
    scheme: Scheme,
    verify_tls: Bool,
    auth_type: Option(String),
    auth_value: Option(String),
  )
}

pub fn create_client(
  host host: String,
  scheme scheme: Scheme,
  verify_tls verify_tls: Bool,
) -> Client {
  Client(
    host: host,
    scheme: scheme,
    verify_tls: verify_tls,
    auth_type: None,
    auth_value: None,
  )
}

pub fn set_auth(
  client client: Client,
  auth_type auth_type: String,
  auth_value auth_value: String,
) -> Client {
  case auth_type {
    "basic" ->
      Client(
        ..client,
        auth_value: Some("Basic " <> create_basic_auth_header(auth_value)),
        auth_type: Some(auth_type),
      )
    "api_key" ->
      Client(
        ..client,
        auth_value: Some("ApiKey " <> auth_value),
        auth_type: Some(auth_type),
      )
    _ -> client
  }
}

pub fn ping(client: Client) -> Result(Response(String), Dynamic) {
  create_request(client, "/", Get)
  |> send_request(client, _)
}

pub fn send_request(
  client: Client,
  req: Request(String),
) -> Result(Response(String), Dynamic) {
  httpc.configure()
  |> httpc.verify_tls(client.verify_tls)
  |> httpc.dispatch(req)
}

pub fn create_request(
  client client: Client,
  endpoint endpoint: String,
  method method: Method,
) -> Request(String) {
  let req =
    request.new()
    |> request.set_method(method)
    |> request.set_scheme(client.scheme)
    |> request.set_host(client.host)
    |> request.set_path(endpoint)
  case client.auth_type {
    Some(_) ->
      request.set_header(
        req,
        "Authorization",
        option.unwrap(client.auth_value, ""),
      )
    None -> req
  }
}

fn create_basic_auth_header(value: String) -> String {
  base64_encode(bit_array.from_string(value), False)
}

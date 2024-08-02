import gleam/dynamic.{type Dynamic}
import gleam/http.{type Method, Put}
import gleam/http/response.{type Response}
import gles/client.{type Client, Client, create_request, send_request}

pub fn create_index(client: Client) -> Result(Response(String), Dynamic) {
  create_request(client, "/my_index", Put)
  |> send_request(client, _)
}

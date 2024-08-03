# GLES - Gleam Elasticsearch Client

**Currently Work in progress**

[![Package Version](https://img.shields.io/hexpm/v/gles)](https://hex.pm/packages/gles)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/gles/)

## Description
GLES is a Gleam client for Elasticsearch. It is designed to be a simple and easy to use client for interacting with Elasticsearch. It is built using the `gleam/http` and `gleam/httpc` library for handling HTTP requests and is therefore currently only compatible with erlang targets, which might change in the future.

## Supported Endpoints
Docs for all endpoints provided by ES can be found [here](https://www.elastic.co/guide/en/elasticsearch/reference/current/rest-apis.html).

There will be a documented way to implement custom endpoints currently not supported yet by the library soon.

More endpoints will be added in the future, but currently the following endpoints are supported:
- Index
  - Create Index
  - Delete Index
  - Get Index
  - Update Index

## Compatibility
Currently tested with 8.13.x, however it should in general work with 8.x versions of Elasticsearch.

Erlang compilation target (due to currently depending on gleam/httpc) is required.

## Examples
For more examples, all functionality has related tests in the `test` directory.

```sh
gleam add gles
```

```gleam
import gleam/http.{Https}
import gleam/option.{Some}
import gles
import gles/client
import gles/index

pub fn main() {
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
}
```

Further documentation can be found at <https://hexdocs.pm/gles>.


## TODO
Currently planned:
- [ ] Adding type/records for API responses: https://github.com/P1llus/gles/issues/2
- [ ] Logging: https://github.com/P1llus/gles/issues/3
- [ ] Implementing more endpoints: https://github.com/P1llus/gles/issues/1

Backlog or still under consideration, anything can be added/removed at any time:
- [ ] Support for long lived connections (keep-alive)
- [ ] Connection pooling
- [ ] Type/Record definition for endpoint request, and handling encoding automatically.

## Contributing
TBD

### Testing

```sh
docker run -d -v --rm --name elasticsearch_container -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e ELASTIC_PASSWORD=changeme -e "xpack.security.enrollment.enabled=false" -e ES_JAVA_OPTS="-Xms750m -Xmx750m" docker.elastic.co/elasticsearch/elasticsearch:8.13.3 # Setup a basic elasticsearch container for running tests.
gleam test  # Run the tests
```

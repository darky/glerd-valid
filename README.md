# glerd_valid

[![Package Version](https://img.shields.io/hexpm/v/glerd_valid)](https://hex.pm/packages/glerd_valid)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glerd_valid/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-a2003e)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

Gleam Record validators using Glerd metadata

```sh
gleam add --dev glerd glerd_valid
```

#### 1. Generate types info

Use [Glerd](https://github.com/darky/glerd)

Example of metadata:

```gleam
pub type User {
  /// valid:age:'gte=18'
  /// valid:age:'lt=150'
  User(age: Int)
}
```

#### 2. Make module for validators generation

###### my_module.gleam

```gleam
import glerd_valid
import glerd_gen

pub fn main() {
  glerd_gen.record_info
  |> glerd_valid.generate("src", _)
}
```

#### 3. Gen validators

```sh
gleam run -m my_module
```

Further documentation can be found at <https://hexdocs.pm/glerd_valid>.

## Supported metadata

- [x] gte
- [x] gt
- [x] lte
- [x] lt
- [x] eq
- [x] ne

## Development

```sh
gleam test # and then commit generated file
```

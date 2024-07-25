# glerd_valid

[![Package Version](https://img.shields.io/hexpm/v/glerd_valid)](https://hex.pm/packages/glerd_valid)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glerd_valid/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-a2003e)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

Gleam Record validators using Glerd metadata

```sh
gleam add --dev glerd glerd_valid
```

#### 1. Describe your records with validation metadata

Example:

```gleam
pub type User {
  /// valid:age:'gte=18, lt=150'
  /// valid:name:'gte=3, lt=100'
  User(age: Int, name: String)
}
```

#### 2. Generate Records info

Use [Glerd](https://github.com/darky/glerd)

#### 3. Make module for validators generation

###### my_module.gleam

```gleam
import glerd_valid
import glerd_gen

pub fn main() {
  glerd_gen.record_info
  |> glerd_valid.generate("src", _)
}
```

#### 4. Gen validators

```sh
gleam run -m my_module
```

Further documentation can be found at <https://hexdocs.pm/glerd_valid>.

## Supported metadata

#### Int, Float, String

- _gte_, _min_ - Number/Float/String length should greater or equal than
- _gt_ - Number/Float/String length should greater than
- _lte_, _max_ - Number/Float/String length should less or equal than
- _lt_ - Number/Float/String length should less than
- _eq_ - should be equal to
- _ne_ - should not be equal to

## Development

```sh
gleam test # and then commit generated file
```

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
pub type Cat {
  /// valid:name:length:'gte=3, lt=50'
  /// valid:lives_count:self:'min=1, max=9'
  Cat(name: String, lives_count: Int)
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

#### Operators

| operator | description                        |
|----------|------------------------------------|
| gte, min | should be greater than or equal to |
| gt       |  should be greater than            |
| lte, max |  should be less than or equal to   |
| lt       |  should be less than               |
| eq       |  should be equal to                |
| ne       |  should not be equal to            |

#### Levels

| level  | description                  |
|--------|------------------------------|
| self   | check on Record field itself |
| length | check on Record field length |

#### Compatibility

| operator | level  | type   |
|----------|--------|--------|
| gte, min | self   | Int    |
| gte, min | self   | Float  |
| gte, min | length | String |
| gte, min | length | List   |
|                            |
| gt       | self   | Int    |
| gt       | self   | Float  |
| gt       | length | String |
| gt       | length | List   |
|                            |
| lte, max | self   | Int    |
| lte, max | self   | Float  |
| lte, max | length | String |
| lte, max | length | List   |
|                            |
| lt       | self   | Int    |
| lt       | self   | Float  |
| lt       | length | String |
| lt       | length | List   |
|                            |
| eq       | self   | Int    |
| eq       | self   | Float  |
| eq       | self   | String |
| eq       | self   | List   |
| eq       | self   | Bool   |
| eq       | length | String |
| eq       | length | List   |
|                            |
| ne       | self   | Int    |
| ne       | self   | Float  |
| ne       | self   | String |
| ne       | self   | List   |
| ne       | self   | Bool   |
| ne       | length | String |
| ne       | length | List   |

## Development

```sh
gleam test # and then commit generated file
```

import gleam/dict
import gleam/list
import gleam/option.{Some}
import gleam/regex.{Match}
import gleam/string
import gleamyshell
import glerd/types
import justin
import simplifile

const safe_comma = "zqLFwXhSaN3MtHvpYbE6xA2UfmjW9PRduT7ksrZB5G4c8yQDJe"

pub fn generate(root, record_info) {
  let imports =
    record_info
    |> list.map(fn(ri) {
      let #(_, module_name, _, _) = ri
      "import " <> module_name
    })
    |> list.unique
    |> string.join("\n")

  let gen_content =
    list.fold(record_info, "// this file was generated via glerd_valid

    import gleam/bool
    import gleam/string
    import gleam/list

    " <> imports, fn(acc, rinfo) {
      let #(record_name, module_name, fields, meta) = rinfo
      let assert Ok(re) = "valid:(\\w+):(\\w+):'([^']+)'" |> regex.from_string
      let validations = regex.scan(re, meta)

      let field_type_by_name =
        fields
        |> list.fold(dict.new(), fn(acc, field) {
          let #(field_name, typ) = field
          dict.insert(acc, field_name, typ)
        })

      let validation_body =
        {
          use validation <- list.flat_map(validations)
          let assert Match(
            _,
            [Some(field_name), Some(check_level), Some(rules)],
          ) = validation
          let rules =
            rules |> string.replace(",,", safe_comma) |> string.split(",")
          use rule <- list.flat_map(rules)
          let rule = rule |> string.replace(safe_comma, ",")
          let assert Ok(re) = "(\\w+)=(.+)" |> regex.from_string
          let assert [Match(_, [Some(key), Some(val)])] =
            regex.scan(re, rule |> string.trim)
          case key, dict.get(field_type_by_name, field_name), check_level {
            "gte", Ok(types.IsInt), "self" | "min", Ok(types.IsInt), "self" -> [
              "
              use <- bool.guard({ x." <> field_name <> " >= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be greater or equal than " <> val <> "\"))
            ",
            ]
            "gte", Ok(types.IsFloat), "self" | "min", Ok(types.IsFloat), "self" -> [
              "
              use <- bool.guard({ x." <> field_name <> " >=. " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be greater or equal than " <> val <> "\"))
            ",
            ]
            "gte", Ok(types.IsString), "length"
            | "min", Ok(types.IsString), "length"
            -> ["
              use <- bool.guard({ string.length(x." <> field_name <> ") >= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be greater or equal than " <> val <> "\"))
            "]
            "gte", Ok(types.IsList(_)), "length"
            | "min", Ok(types.IsList(_)), "length"
            -> ["
              use <- bool.guard({ list.length(x." <> field_name <> ") >= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be greater or equal than " <> val <> "\"))
            "]
            "gt", Ok(types.IsInt), "self" -> ["
              use <- bool.guard({ x." <> field_name <> " > " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be greater than " <> val <> "\"))
            "]
            "gt", Ok(types.IsFloat), "self" -> ["
              use <- bool.guard({ x." <> field_name <> " >. " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be greater than " <> val <> "\"))
            "]
            "gt", Ok(types.IsString), "length" -> ["
              use <- bool.guard({ string.length(x." <> field_name <> ") > " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be greater than " <> val <> "\"))
            "]
            "gt", Ok(types.IsList(_)), "length" -> ["
              use <- bool.guard({ list.length(x." <> field_name <> ") > " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be greater than " <> val <> "\"))
            "]
            "lte", Ok(types.IsInt), "self" | "max", Ok(types.IsInt), "self" -> [
              "
              use <- bool.guard({ x." <> field_name <> " <= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be less or equal than " <> val <> "\"))
            ",
            ]
            "lte", Ok(types.IsFloat), "self" | "max", Ok(types.IsFloat), "self" -> [
              "
              use <- bool.guard({ x." <> field_name <> " <=. " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be less or equal than " <> val <> "\"))
            ",
            ]
            "lte", Ok(types.IsString), "length"
            | "max", Ok(types.IsString), "length"
            -> ["
              use <- bool.guard({ string.length(x." <> field_name <> ") <= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be less or equal than " <> val <> "\"))
            "]
            "lte", Ok(types.IsList(_)), "length"
            | "max", Ok(types.IsList(_)), "length"
            -> ["
              use <- bool.guard({ list.length(x." <> field_name <> ") <= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be less or equal than " <> val <> "\"))
            "]
            "lt", Ok(types.IsInt), "self" -> ["
              use <- bool.guard({ x." <> field_name <> " < " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be less than " <> val <> "\"))
            "]
            "lt", Ok(types.IsFloat), "self" -> ["
              use <- bool.guard({ x." <> field_name <> " <. " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be less than " <> val <> "\"))
            "]
            "lt", Ok(types.IsString), "length" -> ["
              use <- bool.guard({ string.length(x." <> field_name <> ") < " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be less than " <> val <> "\"))
            "]
            "lt", Ok(types.IsList(_)), "length" -> ["
              use <- bool.guard({ list.length(x." <> field_name <> ") < " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be less than " <> val <> "\"))
            "]
            "eq", Ok(types.IsInt), "self"
            | "eq", Ok(types.IsFloat), "self"
            | "eq", Ok(types.IsBool), "self"
            -> ["
              use <- bool.guard({ x." <> field_name <> " == " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be equal to " <> val <> "\"))
            "]
            "eq", Ok(types.IsString), "self" -> ["
              use <- bool.guard({ x." <> field_name <> " == \"" <> val <> "\" } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be equal to \\\"" <> val <> "\\\"\"))
            "]
            "eq", Ok(types.IsString), "length" -> ["
              use <- bool.guard({ string.length(x." <> field_name <> ") == " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be equal to " <> val <> "\"))
            "]
            "eq", Ok(types.IsList(_)), "self" -> ["
              use <- bool.guard({ x." <> field_name <> " == " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be equal to " <> val
              |> string.replace("\"", "\\\"") <> "\"))
            "]
            "eq", Ok(types.IsList(_)), "length" -> ["
              use <- bool.guard({ list.length(x." <> field_name <> ") == " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be equal to " <> val <> "\"))
            "]
            "ne", Ok(types.IsInt), "self"
            | "ne", Ok(types.IsFloat), "self"
            | "ne", Ok(types.IsBool), "self"
            -> ["
              use <- bool.guard({ x." <> field_name <> " != " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should not be equal to " <> val <> "\"))
            "]
            "ne", Ok(types.IsString), "self" -> ["
              use <- bool.guard({ x." <> field_name <> " != \"" <> val <> "\" } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should not be equal to \\\"" <> val <> "\\\"\"))
            "]
            "ne", Ok(types.IsString), "length" -> ["
              use <- bool.guard({ string.length(x." <> field_name <> ") != " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should not be equal to " <> val <> "\"))
            "]
            "ne", Ok(types.IsList(_)), "self" -> ["
              use <- bool.guard({ x." <> field_name <> " != " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should not be equal to " <> val
              |> string.replace("\"", "\\\"") <> "\"))
            "]
            "ne", Ok(types.IsList(_)), "length" -> ["
              use <- bool.guard({ list.length(x." <> field_name <> ") != " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should not be equal to " <> val <> "\"))
            "]
            key, typ, check_level ->
              panic as {
                "Unknown rule for key: "
                <> key
                <> " , type: "
                <> string.inspect(typ)
                <> " , nested check: "
                <> check_level
              }
          }
        }
        |> string.join("\n")
        <> "\n Ok(Nil)"

      acc <> "
        pub fn " <> justin.snake_case(record_name) <> "_valid(x: " <> module_name <> "." <> record_name <> ") {
          " <> validation_body <> "
        }
      "
    })

  let gen_file_path = "./" <> root <> "/glerd_valid_gen.gleam"

  let assert Ok(_) = simplifile.write(gen_file_path, gen_content)

  let assert Ok(_) =
    gleamyshell.execute("gleam", ".", ["format", gen_file_path])

  Nil
}

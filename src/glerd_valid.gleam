import gleam/dict
import gleam/list
import gleam/option.{Some}
import gleam/regex.{Match}
import gleam/string
import gleamyshell
import glerd/types
import justin
import simplifile

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

    " <> imports, fn(acc, rinfo) {
      let #(record_name, module_name, fields, meta) = rinfo
      let assert Ok(re) = "valid:(\\w+):'([\\w=,\\. ]+)'" |> regex.from_string
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
          let assert Match(_, [Some(field_name), Some(rules)]) = validation
          let rules = rules |> string.split(",")
          use rule <- list.flat_map(rules)
          let assert Ok(re) = "(\\w+)=([\\w\\.]+)" |> regex.from_string
          let assert [Match(_, [Some(key), Some(val)])] =
            regex.scan(re, rule |> string.trim)
          case key, dict.get(field_type_by_name, field_name) {
            "gte", Ok(types.IsInt) | "min", Ok(types.IsInt) -> ["
              use <- bool.guard({ x." <> field_name <> " >= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be greater or equal than " <> val <> "\"))
            "]
            "gte", Ok(types.IsFloat) | "min", Ok(types.IsFloat) -> ["
              use <- bool.guard({ x." <> field_name <> " >=. " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be greater or equal than " <> val <> "\"))
            "]
            "gte", Ok(types.IsString) | "min", Ok(types.IsString) -> ["
              use <- bool.guard({ string.length(x." <> field_name <> ") >= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be greater or equal than " <> val <> "\"))
            "]
            "gt", Ok(types.IsInt) -> ["
              use <- bool.guard({ x." <> field_name <> " > " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be greater than " <> val <> "\"))
            "]
            "gt", Ok(types.IsFloat) -> ["
              use <- bool.guard({ x." <> field_name <> " >. " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be greater than " <> val <> "\"))
            "]
            "gt", Ok(types.IsString) -> ["
              use <- bool.guard({ string.length(x." <> field_name <> ") > " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be greater than " <> val <> "\"))
            "]
            "lte", Ok(types.IsInt) | "max", Ok(types.IsInt) -> ["
              use <- bool.guard({ x." <> field_name <> " <= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be less or equal than " <> val <> "\"))
            "]
            "lte", Ok(types.IsFloat) | "max", Ok(types.IsFloat) -> ["
              use <- bool.guard({ x." <> field_name <> " <=. " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be less or equal than " <> val <> "\"))
            "]
            "lte", Ok(types.IsString) | "max", Ok(types.IsString) -> ["
              use <- bool.guard({ string.length(x." <> field_name <> ") <= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be less or equal than " <> val <> "\"))
            "]
            "lt", Ok(types.IsInt) -> ["
              use <- bool.guard({ x." <> field_name <> " < " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be less than " <> val <> "\"))
            "]
            "lt", Ok(types.IsFloat) -> ["
              use <- bool.guard({ x." <> field_name <> " <. " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be less than " <> val <> "\"))
            "]
            "lt", Ok(types.IsString) -> ["
              use <- bool.guard({ string.length(x." <> field_name <> ") < " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " length should be less than " <> val <> "\"))
            "]
            "eq", Ok(types.IsInt)
            | "eq", Ok(types.IsFloat)
            | "eq", Ok(types.IsBool)
            -> ["
              use <- bool.guard({ x." <> field_name <> " == " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be equal to " <> val <> "\"))
            "]
            "eq", Ok(types.IsString) -> ["
              use <- bool.guard({ x." <> field_name <> " == \"" <> val <> "\" } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be equal to \\\"" <> val <> "\\\"\"))
            "]
            "ne", Ok(types.IsInt)
            | "ne", Ok(types.IsFloat)
            | "ne", Ok(types.IsBool)
            -> ["
              use <- bool.guard({ x." <> field_name <> " != " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should not be equal to " <> val <> "\"))
            "]
            "ne", Ok(types.IsString) -> ["
              use <- bool.guard({ x." <> field_name <> " != \"" <> val <> "\" } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should not be equal to \\\"" <> val <> "\\\"\"))
            "]
            key, typ ->
              panic as {
                "Unknown rule for key: "
                <> key
                <> " , type: "
                <> string.inspect(typ)
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

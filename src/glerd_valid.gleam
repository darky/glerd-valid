import gleam/list
import gleam/option.{Some}
import gleam/regex.{Match}
import gleam/string
import gleamyshell
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

    " <> imports, fn(acc, rinfo) {
      let #(record_name, module_name, _, meta) = rinfo
      let assert Ok(re) = "valid:(\\w+):'([\\w=]+)'" |> regex.from_string
      let validations = regex.scan(re, meta)

      let validation_body =
        {
          use validation <- list.flat_map(validations)
          let assert Match(_, [Some(field_name), Some(rules)]) = validation
          let rules = rules |> string.split(",")
          use rule <- list.flat_map(rules)
          let assert Ok(re) = "(\\w+)=(\\w+)" |> regex.from_string
          let assert [Match(_, [Some(key), Some(val)])] =
            regex.scan(re, rule |> string.trim)
          case key {
            "gte" -> ["
              use <- bool.guard({ x." <> field_name <> " >= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be greater or equal than " <> val <> "\"))
            "]
            "gt" -> ["
              use <- bool.guard({ x." <> field_name <> " > " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be greater than " <> val <> "\"))
            "]
            "lte" -> ["
              use <- bool.guard({ x." <> field_name <> " <= " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be less or equal than " <> val <> "\"))
            "]
            "lt" -> ["
              use <- bool.guard({ x." <> field_name <> " < " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be less than " <> val <> "\"))
            "]
            "eq" -> ["
              use <- bool.guard({ x." <> field_name <> " == " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should be equal to " <> val <> "\"))
            "]
            "ne" -> ["
              use <- bool.guard({ x." <> field_name <> " != " <> val <> " } |> bool.negate,
                Error(\"" <> module_name <> "." <> record_name <> "." <> field_name <> " should not be equal to " <> val <> "\"))
            "]
            _ -> panic as { "Unknown rule key: " <> key }
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

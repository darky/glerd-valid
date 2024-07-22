import gleeunit
import glerd/types
import glerd_valid

pub fn main() {
  gleeunit.main()
}

pub fn generate_test() {
  glerd_valid.generate("test", [
    #(
      "TestInt",
      "fixture_test",
      [#("age", types.IsInt)],
      "valid:age:'gte=0, lte=1000, gt=1, lt=999, eq=35, ne=555'",
    ),
    #("TestString", "fixture_test", [#("name", types.IsString)], ""),
    #("TestFloat", "fixture_test", [#("distance", types.IsFloat)], ""),
    #("TestBool", "fixture_test", [#("is_exists", types.IsBool)], ""),
    #(
      "TestMultiple",
      "fixture_test",
      [#("name", types.IsString), #("age", types.IsInt)],
      "",
    ),
    #(
      "TestList",
      "fixture_test",
      [#("names", types.IsList(types.IsString))],
      "",
    ),
    #(
      "TestOption",
      "fixture_test",
      [#("some_int", types.IsOption(types.IsInt))],
      "",
    ),
    #(
      "TestTuple2",
      "fixture_test",
      [#("str_or_int", types.IsTuple2(types.IsString, types.IsInt))],
      "",
    ),
    #(
      "TestTuple3",
      "fixture_test",
      [
        #(
          "str_or_int",
          types.IsTuple3(types.IsString, types.IsInt, types.IsString),
        ),
      ],
      "",
    ),
    #(
      "TestTuple4",
      "fixture_test",
      [
        #(
          "str_or_int",
          types.IsTuple4(
            types.IsString,
            types.IsInt,
            types.IsString,
            types.IsInt,
          ),
        ),
      ],
      "",
    ),
    #(
      "TestTuple5",
      "fixture_test",
      [
        #(
          "str_or_int",
          types.IsTuple5(
            types.IsString,
            types.IsInt,
            types.IsString,
            types.IsInt,
            types.IsString,
          ),
        ),
      ],
      "",
    ),
    #(
      "TestTuple6",
      "fixture_test",
      [
        #(
          "str_or_int",
          types.IsTuple6(
            types.IsString,
            types.IsInt,
            types.IsString,
            types.IsInt,
            types.IsString,
            types.IsInt,
          ),
        ),
      ],
      "",
    ),
    #(
      "TestRecord",
      "fixture_test",
      [#("nested", types.IsRecord("NestedRecord"))],
      "",
    ),
    #("NestedRecord", "fixture_test", [#("name", types.IsString)], ""),
    #(
      "TestDict",
      "fixture_test",
      [#("dict", types.IsDict(types.IsString, types.IsInt))],
      "",
    ),
  ])
}

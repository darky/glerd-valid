// this file was generated via glerd_valid

import gleam/bool
import gleam/string

import fixture_test

pub fn test_int_valid(x: fixture_test.TestInt) {
  use <- bool.guard(
    { x.age >= 0 } |> bool.negate,
    Error("fixture_test.TestInt.age should be greater or equal than 0"),
  )

  use <- bool.guard(
    { x.age >= 0 } |> bool.negate,
    Error("fixture_test.TestInt.age should be greater or equal than 0"),
  )

  use <- bool.guard(
    { x.age <= 1000 } |> bool.negate,
    Error("fixture_test.TestInt.age should be less or equal than 1000"),
  )

  use <- bool.guard(
    { x.age <= 1000 } |> bool.negate,
    Error("fixture_test.TestInt.age should be less or equal than 1000"),
  )

  use <- bool.guard(
    { x.age > 1 } |> bool.negate,
    Error("fixture_test.TestInt.age should be greater than 1"),
  )

  use <- bool.guard(
    { x.age < 999 } |> bool.negate,
    Error("fixture_test.TestInt.age should be less than 999"),
  )

  use <- bool.guard(
    { x.age == 35 } |> bool.negate,
    Error("fixture_test.TestInt.age should be equal to 35"),
  )

  use <- bool.guard(
    { x.age != 555 } |> bool.negate,
    Error("fixture_test.TestInt.age should not be equal to 555"),
  )

  Ok(Nil)
}

pub fn test_string_valid(x: fixture_test.TestString) {
  use <- bool.guard(
    { string.length(x.name) >= 0 } |> bool.negate,
    Error(
      "fixture_test.TestString.name length should be greater or equal than 0",
    ),
  )

  use <- bool.guard(
    { string.length(x.name) >= 0 } |> bool.negate,
    Error(
      "fixture_test.TestString.name length should be greater or equal than 0",
    ),
  )

  use <- bool.guard(
    { string.length(x.name) <= 100 } |> bool.negate,
    Error(
      "fixture_test.TestString.name length should be less or equal than 100",
    ),
  )

  use <- bool.guard(
    { string.length(x.name) <= 100 } |> bool.negate,
    Error(
      "fixture_test.TestString.name length should be less or equal than 100",
    ),
  )

  use <- bool.guard(
    { string.length(x.name) > 1 } |> bool.negate,
    Error("fixture_test.TestString.name length should be greater than 1"),
  )

  use <- bool.guard(
    { string.length(x.name) < 99 } |> bool.negate,
    Error("fixture_test.TestString.name length should be less than 99"),
  )

  use <- bool.guard(
    { x.name == "Barsik" } |> bool.negate,
    Error("fixture_test.TestString.name should be equal to \"Barsik\""),
  )

  use <- bool.guard(
    { x.name != "Mosya" } |> bool.negate,
    Error("fixture_test.TestString.name should not be equal to \"Mosya\""),
  )

  Ok(Nil)
}

pub fn test_float_valid(x: fixture_test.TestFloat) {
  use <- bool.guard(
    { x.distance >=. 0.0 } |> bool.negate,
    Error("fixture_test.TestFloat.distance should be greater or equal than 0.0"),
  )

  use <- bool.guard(
    { x.distance >=. 0.0 } |> bool.negate,
    Error("fixture_test.TestFloat.distance should be greater or equal than 0.0"),
  )

  use <- bool.guard(
    { x.distance <=. 1000.0 } |> bool.negate,
    Error("fixture_test.TestFloat.distance should be less or equal than 1000.0"),
  )

  use <- bool.guard(
    { x.distance <=. 1000.0 } |> bool.negate,
    Error("fixture_test.TestFloat.distance should be less or equal than 1000.0"),
  )

  use <- bool.guard(
    { x.distance >. 1.0 } |> bool.negate,
    Error("fixture_test.TestFloat.distance should be greater than 1.0"),
  )

  use <- bool.guard(
    { x.distance <. 999.0 } |> bool.negate,
    Error("fixture_test.TestFloat.distance should be less than 999.0"),
  )

  use <- bool.guard(
    { x.distance == 35.0 } |> bool.negate,
    Error("fixture_test.TestFloat.distance should be equal to 35.0"),
  )

  use <- bool.guard(
    { x.distance != 555.0 } |> bool.negate,
    Error("fixture_test.TestFloat.distance should not be equal to 555.0"),
  )

  Ok(Nil)
}

pub fn test_bool_valid(x: fixture_test.TestBool) {
  use <- bool.guard(
    { x.is_exists == True } |> bool.negate,
    Error("fixture_test.TestBool.is_exists should be equal to True"),
  )

  use <- bool.guard(
    { x.is_exists != False } |> bool.negate,
    Error("fixture_test.TestBool.is_exists should not be equal to False"),
  )

  Ok(Nil)
}

pub fn test_multiple_valid(x: fixture_test.TestMultiple) {
  Ok(Nil)
}

pub fn test_list_valid(x: fixture_test.TestList) {
  Ok(Nil)
}

pub fn test_option_valid(x: fixture_test.TestOption) {
  Ok(Nil)
}

pub fn test_tuple2_valid(x: fixture_test.TestTuple2) {
  Ok(Nil)
}

pub fn test_tuple3_valid(x: fixture_test.TestTuple3) {
  Ok(Nil)
}

pub fn test_tuple4_valid(x: fixture_test.TestTuple4) {
  Ok(Nil)
}

pub fn test_tuple5_valid(x: fixture_test.TestTuple5) {
  Ok(Nil)
}

pub fn test_tuple6_valid(x: fixture_test.TestTuple6) {
  Ok(Nil)
}

pub fn test_record_valid(x: fixture_test.TestRecord) {
  Ok(Nil)
}

pub fn nested_record_valid(x: fixture_test.NestedRecord) {
  Ok(Nil)
}

pub fn test_dict_valid(x: fixture_test.TestDict) {
  Ok(Nil)
}

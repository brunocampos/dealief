defmodule Dealief.Agreement.ContractDateTest do
  use ExUnit.Case
  
  alias Dealief.Agreement.ContractDate

  test "it can cast the DD-MM-YYYY string format to a valid date" do
    assert ContractDate.cast("25-12-2017") == NaiveDateTime.new(2017,12,25,0,0,0,{0,6})
  end

end
defmodule Dealief.Agreement.ContractDate do
  @moduledoc """
  Implementation of a custom Ecto.Type that accepts dates in DD-MM-YYYY format
  """
  @behaviour Ecto.Type

  def type, do: :naive_datetime
  
  def cast(<<day::2-bytes, ?-, month::2-bytes, ?-, year::4-bytes>>) do
    NaiveDateTime.new(
      String.to_integer(year), String.to_integer(month),
      String.to_integer(day), 0, 0, 0,{0,6}
    )  
  end

  def cast(value), do: Ecto.Type.cast(:naive_datetime, value)

  def dump(value), do: Ecto.Type.dump(:naive_datetime, value)

  def load(value), do: Ecto.Type.load(:naive_datetime, value) 
  
end
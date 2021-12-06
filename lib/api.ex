defmodule Api do
  use Tesla
  use Memoize

  plug(Tesla.Middleware.BaseUrl, "https://adventofcode.com/2021/day/")

  plug(Tesla.Middleware.Headers, [
    {"cookie",
     "session=53616c7465645f5f03cf34a2c900241f39b2287ae54580f5222aa6a2b5e32fdad9644b842db02a259353e5257bdcad27"}
  ])

  defmemo get_input(day) do
    {:ok, response} = get("#{day}/input")
    response.body
  end
end

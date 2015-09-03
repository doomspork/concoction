defmodule Concoction.Plug.VerifyRequestTest do
  use ExUnit.Case
  use Plug.Test

  alias Concoction.Plug.VerifyRequest
  alias Plug.Conn

  @opts VerifyRequest.init(fields: ["content", "mimetype"], paths: ["/verify"])

  def parse(conn, opts \\ []) do
    opts = Keyword.put_new(opts, :parsers, [Plug.Parsers.URLENCODED, Plug.Parsers.MULTIPART])
    Plug.Parsers.call(conn, Plug.Parsers.init(opts))
  end

  test "returns accepted on successful requests" do
    conn = conn(:post, "/verify", "content=test&mimetype=text/plain")
           |> put_req_header("content-type", "application/x-www-form-urlencoded")
           |> parse
           |> VerifyRequest.call(@opts)

    assert %Conn{} = conn
  end

  test "returns incomplete request for missing fields" do
    exception = assert_raise Concoction.Plug.VerifyRequest.IncompleteRequestError, fn ->
      conn(:post, "/verify", "content=test")
           |> put_req_header("content-type", "application/x-www-form-urlencoded")
           |> parse
           |> VerifyRequest.call(@opts)
    end

    assert Plug.Exception.status(exception) == 400
  end

  test "ignores requests not includes in :paths" do
    conn = conn(:get, "/")
           |> VerifyRequest.call(@opts)

    assert %Conn{} = conn
  end
end

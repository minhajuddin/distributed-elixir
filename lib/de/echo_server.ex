defmodule DE.EchoServer do

  require Logger

  def start_link(opts) do
    {:ok, spawn_link(__MODULE__, :init, [opts])}
  end

  def init(opts) do
    port = Keyword.get(opts, :port, 4050)
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    acceptor_loop(socket)
  end

  def acceptor_loop(socket) do
    {:ok, conn} = :gen_tcp.accept(socket)
    spawn(fn -> echo_loop(conn) end)
    acceptor_loop(socket)
  end

  def echo_loop(conn) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, packet} ->
        Logger.debug recv: packet
        :gen_tcp.send(conn, packet)
        echo_loop(conn)
      {:error, error} ->
        Logger.error error: error
    end
  end

end


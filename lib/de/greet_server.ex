defmodule DE.GreetServer do
  use GenServer

  defmodule State do
    defstruct [:port, :socket]
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    port = Keyword.get(opts, :port, 4050)
    send(self(), :init)
    {:ok, %State{port: port}}
  end

  @impl true
  def handle_info(:init, state) do
    {:ok, socket} = :gen_tcp.listen(state.port, [:binary, active: false])
    acceptor_loop(socket)
  end

  def acceptor_loop(socket) do
    {:ok, conn} = :gen_tcp.accept(socket)
    :gen_tcp.send(conn, "Hello, World TCP!")
    :gen_tcp.close(conn)
    acceptor_loop(socket)
  end


end

defmodule Contracts do
  defmacro __using__(_opts) do
    quote do
      # Un-Import the builtin `@` function, so we can redefine it
      import Kernel, except: [@: 1]
      import Contracts, only: [@: 1]

      # Register a module attribute to store contracts in
      Module.register_attribute(__MODULE__, :contracts, accumulate: true)

      # Tells the `using` module to call the below callback before compilation
      # finishes
      @before_compile Contracts
    end
  end

  defmacro __before_compile__(env) do
    contracts = Module.get_attribute(env.module, :contracts)

    for {name, arity, arg_types, result_type} <- contracts do
      wrap_fn({env.module, name, arity}, arg_types, result_type)
    end
  end

  defmacro @{:contract, _, expr} do
    {name, arg_types, arity, result_type} = parse_contract(expr)

    quote do
      @contracts {
        unquote(name),
        unquote(arity),
        unquote(arg_types),
        unquote(result_type)
      }
    end
  end

  defmacro @other do
    # Fallback to the builtin `@` function if we're not handling a contract
    quote do
      Kernel.@(unquote(other))
    end
  end

  def parse_contract([{:"::", _, [{name, _, args}, {result_type, _, _}]}]) do
    arity = length(args)
    arg_types = Enum.map(args, &parse_contract_argument/1)

    {name, arg_types, arity, result_type}
  end

  def parse_contract_argument({:"::", _, [{name, _, _}, {type, _, _}]}) do
    {name, type}
  end

  def wrap_fn({_, function, arity} = mfa, arg_types, result_type) do
    mfa = Macro.escape(mfa)
    args = Macro.generate_arguments(arity, nil)

    quote do
      defoverridable [{unquote(function), unquote(arity)}]

      def unquote(function)(unquote_splicing(args)) do
        Contracts.assert_arguments!(
          unquote(mfa),
          unquote(arg_types),
          unquote(args)
        )

        result = super(unquote_splicing(args))

        Contracts.assert_type!(
          unquote(mfa),
          unquote(result_type),
          result
        )

        result
      end
    end
  end

  def assert_arguments!(mfa, arg_types, args) do
    for {value, {name, type}} <- Enum.zip(args, arg_types) do
      assert_type!(mfa, type, value, name)
    end
  end

  def assert_type!(mfa, type, value, where \\ :return) do
    guard = :"is_#{type}"

    unless apply(Kernel, guard, [value]) do
      raise Contracts.Error,
        mfa: mfa,
        where: where,
        type: type,
        value: value
    end
  end
end

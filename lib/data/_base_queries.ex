defmodule Data.BaseQueries do
  defmacro __using__(opts) do
    quote do
      import Ecto.Query

      alias Donna.Repo

      # Apply all filters and return all entities.
      def all(args \\ []) when is_list(args), do: query(args) |> Repo.all()

      # Apply filters and return the count of found entities
      def count(args \\ []), do: query(args) |> Repo.aggregate(:count)

      # Does at least 1 entity exist with passes filters applied?
      def exists?(args) when is_list(args), do: query(args) |> Repo.exists?()

      # Retrieve a single entity by id
      def get(id), do: get_by(id: id)

      # Apply filters and retrieve a single entity
      def get_by(args) when is_list(args), do: query(args) |> limit(1) |> Repo.one()

      # Apply filters and retrieve first entity by id
      def first(args \\ []), do: query(args) |> order_by(asc: :id) |> limit(1) |> Repo.one()

      # Apply filters and retrieve last entity by id
      def last(args \\ []), do: query(args) |> order_by(desc: :id) |> limit(1) |> Repo.one()

      # This should be called at the end of each `Data.Entity.Queries#query/1`
      # It decomposes the keyword list into subsequent calls to `#apply_filter/2
      def apply_filters(query, args) do
        Enum.reduce(args, query, &apply_filter/2)
      end

      defp apply_filter({:order, direction}, query), do: order_by(query, ^direction)
      defp apply_filter({:limit, limit}, query), do: limit(query, ^limit)

      # next 2 filters are here because multiple graphql queries by native apps filter by those args
      # {:ids, ids} is equivalent to just passing an {:id, ids}, where ids is an array
      defp apply_filter({:ids, ids}, query), do: apply_filter({:id, ids}, query)

      defp apply_filter({:updated_since, datetime}, query) do
        where(query, [m], m.updated_at > ^datetime)
      end

      # next 4 introdice basic equality comparison against fields in the model
      # Example:
      # Data.User.Queries.all(email: nil)
      defp apply_filter({key, nil}, query) do
        where(query, [entry: entry], is_nil(field(entry, ^key)))
      end

      # Example:
      # Data.TeamMember.Queries.all(photo_file: {:not, nil})
      defp apply_filter({key, {:not, nil}}, query) do
        where(query, [entry: entry], not is_nil(field(entry, ^key)))
      end

      # Example
      # Data.Organization.Queries.all(id: [524, 562])
      defp apply_filter({key, value}, query) when is_list(value) do
        where(query, [entry: entry], field(entry, ^key) in ^value)
      end

      # Example
      # Data.Team.Queries.all(type: {:not, 3})
      defp apply_filter({key, {:not, value}}, query) when not is_nil(value) do
        where(query, [entry: entry], field(entry, ^key) != ^value)
      end

      # our server gets scanned all the time by chinese hackers, and they try to open
      # our pages with strings as ids
      # this gets translated to queries, which try to filter by non-integer-like id
      # So we need to perform a check in here, if the passed id can actually be expressed as int
      # and return nothing, if it can't
      defp apply_filter({:id, id}, query) when is_number(id) do
        where(query, [entry: entry], entry.id == ^id)
      end

      defp apply_filter({:id, id}, query) when not is_nil(id) do
        case Integer.parse(id) do
          {int, ""} -> where(query, [entry: entry], entry.id == ^id)
          _ -> where(query, false)
        end
      end

      # Example:
      # Data.Queries.Team.get_by(name: "University of Denver")
      defp apply_filter({key, value}, query) when not is_nil(value) do
        where(query, [entry: entry], field(entry, ^key) == ^value)
      end

      defoverridable apply_filter: 2
    end
  end
end

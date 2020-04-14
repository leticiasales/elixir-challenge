defmodule App.Items do
  @moduledoc """
  The Items context.
  """

  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Items.Book
  alias App.Relations.Author
  alias App.Relations.Category

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book) |> Repo.preload([:authors, :categories])
  end

  @doc """
  Gets a single book.

  Raises `Ecto.NoResultsError` if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

      iex> get_book!(456)
      ** (Ecto.NoResultsError)

  """
  def get_book!(id), do: Repo.get!(Book, id) |> Repo.preload([:authors, :categories])

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_book(%{"authors" => authors, "categories" => categories} = attrs) do
    authors = Repo.all(from a in Author, where: a.name in ^attrs["authors"])
    categories = Repo.all(from c in Category, where: c.name in ^attrs["categories"])
    attrs = Map.drop(attrs, ["authors", "categories"])
    
    %Book{}
    |> Book.changeset(attrs)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:authors, authors)
    |> Ecto.Changeset.put_assoc(:categories, categories)
    |> Repo.insert()
  end

  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_book(%Book{} = book, %{"authors" => authors, "categories" => categories} = attrs) do
    authors = Repo.all(from a in Author, where: a.name in ^attrs["authors"])
    categories = Repo.all(from c in Category, where: c.name in ^attrs["categories"])
    attrs = Map.drop(attrs, ["authors", "categories"])

    book
    |> Book.changeset(attrs)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:categories, categories)
    |> Ecto.Changeset.put_assoc(:authors, authors)
    |> Repo.update()
  end

  def update_book(%Book{} = book, attrs) do
    book
    |> Book.changeset(attrs)
    |> Repo.update()
  end

#  defp link_user_and_company(user = %User{}, company = %Company{}) do
#    user = Repo.preload(user, :companies)
#    companies = user.companies ++ [company]
#                |> Enum.map(&Ecto.Changeset.change/1)
#
#    user
#    |> Ecto.Changeset.change
#    |> Ecto.Changeset.put_assoc(:companies, companies)
#    |> Repo.update
#  end

  @doc """
  Deletes a Book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, %Ecto.Changeset{}}

  """
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Ecto.Changeset{source: %Book{}}

  """
  def change_book(%Book{} = book) do
    Book.changeset(book, %{})
  end
end

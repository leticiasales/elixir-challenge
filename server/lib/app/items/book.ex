defmodule App.Items.Book do
  use Ecto.Schema
  import Ecto.Changeset
  alias App.Relations.Author
  alias App.Relations.Category

  schema "books" do
    field :cover_url, :string
    field :name, :string
    field :price, :decimal
    field :summary, :string
    has_many :authors, Author
    many_to_many :categories, Category, join_through: "books_categories"

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:name, :summary, :price, :cover_url])
    |> validate_required([:name, :summary, :price, :cover_url])
    |> unique_constraint(:name)
  end
end
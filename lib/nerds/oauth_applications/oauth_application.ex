defmodule Nerds.OauthApplications.OauthApplication do
  use Ecto.Schema
  use ExOauth2Provider.Applications.Application, otp_app: :nerds

  schema "oauth_applications" do
    field :name, :string, null: false
    field :uid, :string, null: false
    field :secret, :string, null: false, default: ""
    field :redirect_uri, :string, null: false
    field :scopes, :string, null: false, default: ""

    belongs_to :owner, Nerds.Users.User
    has_many :access_tokens, Nerds.OauthAccessTokens.OauthAccessToken, foreign_key: :application_id

    timestamps()
  end

  def changeset(application, params, config \\ []) do
    application
    |> maybe_new_application_changeset(params, config)
    |> Changeset.cast(params, [:name, :secret, :redirect_uri, :scopes])
    |> Changeset.validate_required([:name, :uid, :redirect_uri])
    |> validate_secret_not_nil()
    |> Scopes.validate_scopes(nil, config)
    |> validate_redirect_uri(config)
    |> Changeset.unique_constraint(:uid)
  end

  defp validate_secret_not_nil(changeset) do
    case Changeset.get_field(changeset, :secret) do
      nil -> Changeset.add_error(changeset, :secret, "can't be blank")
      _   -> changeset
    end
  end

  defp maybe_new_application_changeset(application, params, config) do
    case Ecto.get_meta(application, :state) do
      :built  -> new_application_changeset(application, params, config)
      :loaded -> application
    end
  end

  defp new_application_changeset(application, params, config) do
    application
    |> Changeset.cast(params, [:uid, :secret])
    |> put_uid()
    |> put_secret()
    |> Scopes.put_scopes(nil, config)
    |> Changeset.assoc_constraint(:owner)
  end

  defp validate_redirect_uri(changeset, config) do
    changeset
    |> Changeset.get_field(:redirect_uri)
    |> Kernel.||("")
    |> String.split()
    |> Enum.reduce(changeset, fn url, changeset ->
      url
      |> RedirectURI.validate(config)
      |> case do
           {:error, error} -> Changeset.add_error(changeset, :redirect_uri, error)
           {:ok, _}        -> changeset
         end
    end)
  end

  defp put_uid(%{changes: %{uid: _}} = changeset), do: changeset
  defp put_uid(%{} = changeset) do
    Changeset.change(changeset, %{uid: Utils.generate_token()})
  end

  defp put_secret(%{changes: %{secret: _}} = changeset), do: changeset
  defp put_secret(%{} = changeset) do
    Changeset.change(changeset, %{secret: Utils.generate_token()})
  end
end

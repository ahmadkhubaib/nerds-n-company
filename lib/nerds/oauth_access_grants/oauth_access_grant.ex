defmodule Nerds.OauthAccessGrants.OauthAccessGrant do
  use Ecto.Schema
  use ExOauth2Provider.AccessGrants.AccessGrant, otp_app: :nerds

  schema "oauth_access_grants" do
    field :token, :string, null: false
    field :expires_in, :integer, null: false
    field :redirect_uri, :string, null: false
    field :revoked_at, :utc_datetime
    field :scopes, :string

    belongs_to :resource_owner, Nerds.Users.User
    belongs_to :application, Nerds.OauthApplications.OauthApplication

    timestamps()
  end

  def changeset(grant, params, config) do
    grant
    |> Changeset.cast(params, [:redirect_uri, :expires_in, :scopes])
    |> Changeset.assoc_constraint(:application)
    |> Changeset.assoc_constraint(:resource_owner)
    |> put_token()
    |> Scopes.put_scopes(grant.application.scopes, config)
    |> Scopes.validate_scopes(grant.application.scopes, config)
    |> Changeset.validate_required([:redirect_uri, :expires_in, :token, :resource_owner, :application])
    |> Changeset.unique_constraint(:token)
  end

  def put_token(changeset) do
    Changeset.put_change(changeset, :token, Utils.generate_token())
  end
end

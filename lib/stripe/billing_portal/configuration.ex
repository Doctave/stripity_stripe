defmodule Stripe.BillingPortal.Configuration do
  @moduledoc """
  Work with Stripe Billing (aka Self-serve) Portal Session Configuration objects.

  You can:

  - Create a session
  - Update a session
  - Retrieve a session

  Stripe API reference: https://stripe.com/docs/api/customer_portal/configuration
  """

  use Stripe.Entity
  import Stripe.Request

  @type t :: %__MODULE__{
          :id => Stripe.id(),
          :object => String.t(),
          :active => boolean(),
          :application => String.t(),
          :business_profile => business_profile,
          :created => Stripe.timestamp(),
          :default_return_url => String.t(),
          :features => features,
          :is_default => boolean(),
          :livemode => boolean(),
          :updated => Stripe.timestamp()
        }

  @type business_profile :: %{
          :headline => String.t(),
          :privacy_policy_url => String.t(),
          :terms_of_service_url => String.t()
        }

  @type features :: %{
          :customer_update => customer_update,
          :invoice_history => enabled_hash,
          :payment_method_update => enabled_hash,
          :subscription_cancel => subscription_cancel,
          :subscription_pause => enabled_hash,
          :subscription_update => subscription_update,
          :proration_behavior => proration_behavior
        }

  @type customer_update :: %{
          :enabled => boolean(),
          :allowed_updates => [customer_update_types]
        }

  @type customer_update_types :: :email | :address | :shipping | :phone | :tax_id

  @type enabled_hash :: %{
          :enabled => boolean()
        }

  @type subscription_cancel :: %{
          :enabled => boolean(),
          :mode => subscription_cancel_mode,
          :proration_behavior => proration_behavior
        }

  @type subscription_cancel_mode :: :immediately | :at_period_end

  @type cancel_proration_behavior :: :none | :create_proration

  @type subscription_update :: %{
          :default_allowed_updates => [subscription_allowed_updates],
          :enabled => boolean(),
          :products => [product]
        }

  @type subscription_allowed_updates :: :price | :quantity | :promotion_code

  @type product :: %{
          :prices => [String.t()],
          :product => String.t()
        }

  @type proration_behavior :: :none | :create_proration | :always_invoice

  @type create_params :: %{
          :business_profile => business_profile,
          :features => features,
          optional(:default_return_url) => String.t()
        }

  @type update_params :: %{
          optional(:active) => boolean(),
          optional(:business_profile) => business_profile,
          optional(:features) => features,
          optional(:default_return_url) => String.t()
        }

  defstruct [
    :id,
    :object,
    :active,
    :application,
    :business_profile,
    :created,
    :default_return_url,
    :features,
    :is_default,
    :livemode,
    :updated
  ]

  @plural_endpoint "billing_portal/configurations"

  @doc """
  Create a new portal session object
  """
  @spec create(create_params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  @doc """
  Update an existing portal session object
  """
  @spec update(Stripe.id(), update_params, Stripe.options()) ::
          {:ok, t} | {:error, Stripe.Error.t()}
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_params(params)
    |> put_method(:put)
    |> make_request()
  end

  @doc """
  Retrieve an existing portal session object
  """
  @spec retrieve(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end
end

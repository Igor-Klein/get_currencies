# frozen_string_literal: true

class WebApi::V1::CurrenciesController < WebApi::V1::ApplicationController
  skip_before_action :authenticate_user!
  skip_after_action :verify_authorized

  def index
    currencies = Currency.all.paginate(pagination_params(3))

    data = {
      currencies: currencies,
      meta: build_meta(currencies)
    }

    respond_with data
  end

  def show
    currency = Currency.find(params[:id])

    respond_with currency
  end
end

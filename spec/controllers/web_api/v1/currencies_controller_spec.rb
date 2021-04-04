# frozen_string_literal: true

describe WebApi::V1::CurrenciesController do
  before do
    @currency_usd = Currency.create({ name: 'USD', rate: 72.333 })
    @currency_eur = Currency.create({ name: 'EUR', rate: 89.433 })
  end

  example '#index' do
    get :index, format: :json

    assert response.successful?
    data = JSON.parse(response.body)
    assert data.present?
    assert(data['currencies'].pluck('id').uniq.sort == [@currency_usd.id, @currency_eur.id])
  end

  example '#show' do
    get :show, params: { id: @currency_eur.id }, format: :json

    assert response.successful?
    data = JSON.parse(response.body)
    assert data.present?
    assert @currency_eur.id == data['id']
  end
end

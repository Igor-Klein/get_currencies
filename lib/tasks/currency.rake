# frozen_string_literal: true

namespace :currency do
  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'

  desc 'import currencies from cbr.ru'
  task import: :environment do
    uri = URI.parse('http://www.cbr.ru/scripts/XML_daily.asp')
    xml_with_currencies = uri.read
    currencies_from_cbr = Hash.from_xml(xml_with_currencies)['ValCurs']['Valute']
    currencies = []
    errors = []

    currencies_from_cbr.each do |entry|
      id = entry['ID']
      if id.blank?
        message = "ID is empty, row: #{entry}"
        errors << message
        next
      end

      name = entry['Name']
      if name.blank?
        message = "Name is empty, row: #{entry}"
        errors << message
        next
      end

      nominal = entry['Nominal'].gsub(',', '.').to_f
      if nominal.zero?
        message = "Nominal is wrong, row: #{entry}"
        errors << message
        next
      end

      value = entry['Value'].gsub(',', '.').to_f
      if value.zero?
        message = "Value is wrong, row: #{entry}"
        errors << message
        next
      end

      rate = value / nominal

      params = {
        id: id.chars.map(&:ord).join('').to_i,
        name: name,
        rate: rate
      }

      currency = Currency.new(params)
      currencies << currency
    end

    result = Currency.import(currencies, on_duplicate_key_update: { conflict_target:
      [:id], columns: %i[name rate updated_at] })
    puts('result:', result)
    { errors: errors }
  end
end

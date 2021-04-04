# frozen_string_literal: true

class CreateCurrencies < ActiveRecord::Migration[5.2]
  def change
    create_table :currencies do |t|
      t.string 'name', null: false
      t.decimal 'rate', precision: 12, scale: 6, null: false

      t.timestamps
    end
  end
end

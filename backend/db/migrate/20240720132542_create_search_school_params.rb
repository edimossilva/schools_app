# frozen_string_literal: true

class CreateSearchSchoolParams < ActiveRecord::Migration[7.1]
  def change
    create_table :search_school_params do |t|
      t.string :params_as_key, null: false
      t.jsonb :params
      t.datetime :deleted_at

      t.timestamps
    end
  end
end

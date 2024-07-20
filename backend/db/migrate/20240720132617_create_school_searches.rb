# frozen_string_literal: true

class CreateSchoolSearches < ActiveRecord::Migration[7.1]
  def change
    create_table :school_searches do |t|
      t.references :search_school_param, null: false, foreign_key: true
      t.references :school, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end

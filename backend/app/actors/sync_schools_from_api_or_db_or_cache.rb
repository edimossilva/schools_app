# frozen_string_literal: true

class SyncSchoolsFromApiOrDbOrCache < Actor
  input :school_index_contract

  output :data

  def call
    self.data = Rails.cache.fetch(school_index_contract.to_json) do
      SyncSchoolsFromApiOrDb.result(school_index_contract:).data
    end
  end
end

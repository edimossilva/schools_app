# frozen_string_literal: true

class SyncSchoolsJob
  include Sidekiq::Job

  def perform(schools_data_json, school_index_contract_json)
    SyncSchoolsData.result(schools_data_json:, school_index_contract_json:)
  end
end

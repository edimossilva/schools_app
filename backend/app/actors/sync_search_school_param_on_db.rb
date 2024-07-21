# frozen_string_literal: true

class SyncSearchSchoolParamOnDb < Actor
  input :school_index_contract

  output :data

  def call
    self.data = sync_search_school_param_on_db(school_index_contract)
  end

  private

  def sync_search_school_param_on_db(school_index_contract)
    params_as_key = school_index_contract.to_json
    SearchSchoolParam.find_or_create_by(params_as_key:) do |ssp|
      ssp.params = school_index_contract
    end
  end
end

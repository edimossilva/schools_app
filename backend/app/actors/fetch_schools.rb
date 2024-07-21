# frozen_string_literal: true

class FetchSchools < Actor
  FETCH_SCHOOLS_URL = "https://api.data.gov/ed/collegescorecard/v1/schools"

  input :school_index_contract

  output :data
  output :schools_data

  def call
    fail!(error: :missing_college_score_card_api_key) if api_key.blank?
    self.schools_data = fetch_schools_data
    self.data = fetch_schools
  end

  private

  def fetch_schools_data
    response = Faraday.get(FETCH_SCHOOLS_URL, params)
    json_response = JSON.parse(response.body)
    json_response["results"]
  end

  def fetch_schools
    schools_data.map { School.from_hash(_1) }
  end

  def params
    {
      api_key:,
      fields: "id,school.name,location",
      page: school_index_contract[:page],
      per_page: school_index_contract[:per_page],
      "school.name" => school_index_contract[:school_name_like]
    }
  end

  def api_key
    ENV.fetch("COLLEGE_SCORE_CARD_API_KEY", nil)
  end
end

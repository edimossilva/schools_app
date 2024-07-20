# frozen_string_literal: true

class SyncSchoolsOnDb < Actor
  input :schools_data
  input :search_school_param

  output :data

  def call
    self.data = sync_schools(schools_data, search_school_param)
  end

  private

  def sync_schools(schools_data, search_school_param)
    schools_data.map do |school_data|
      school = School.find_by(external_id: school_data["id"])

      if school
        school.search_school_params.push(search_school_param)
      else
        school = School.from_hash(school_data)
        school.search_school_params.push(search_school_param)
        school.save!
      end
      school
    end
  end
end

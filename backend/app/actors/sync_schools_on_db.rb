# frozen_string_literal: true

class SyncSchoolsOnDb < Actor
  input :schools
  input :search_school_param

  output :data

  def call
    self.data = sync_schools(schools, search_school_param)
  end

  private

  def sync_schools(schools, search_school_param)
    schools.map do |temp_school|
      school = School.find_by(external_id: temp_school.external_id)

      if school
        school.search_school_params.push(search_school_param)
      else
        school = temp_school
        school.search_school_params.push(search_school_param)
        school.save!
      end
      school
    end
  end
end

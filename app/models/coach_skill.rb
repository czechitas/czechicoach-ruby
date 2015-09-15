class CoachSkill < ActiveRecord::Base
  self.table_name = :coaches_skills
  belongs_to :coach
  belongs_to :skill
end

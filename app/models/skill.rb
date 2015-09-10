class Skill < ActiveRecord::Base
  has_and_belongs_to_many :coaches
  validates :name, presence: true, uniqueness: true
end

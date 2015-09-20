class Coach < ActiveRecord::Base
  has_and_belongs_to_many :skills
  validates :email, presence: true, uniqueness: true

  scope :praha, -> { where(city: "Praha") }
  scope :brno, -> { where(city: "Brno") }
  scope :others, -> { where.not(city: ["Praha", "Brno"]) }


  WEB_SKILLS = ["web","js", "jquery","html/css","fe", "frontend", "html", "css", "php", "wordpress"]
  PRG_SKILLS = ["ruby", "java", "c", "c#", "php", "python", "android", "ios", "rails" ,"django", "oop", "c/c++"]
  GRAPHICS_SKILLS = ["grafika", "photoshop", "adobe", "vizualizace", "gimp", "inskcape"]

  FILTERS = [
    [:web, WEB_SKILLS],
    [:programming, PRG_SKILLS],
    [:graphics, GRAPHICS_SKILLS]
  ]

  FILTERS.each do |what|
    define_singleton_method what[0] do |scope|
      ids = Skill.where(name: what[1])
                 .select("id")
                 .map(&:id)

      coach_ids = CoachSkill.where(skill_id: ids)
                            .select("coach_id")
                            .map(&:coach_id)

      Coach.where(id: coach_ids)
    end
  end

  def skill_names
    skills.map(&:name).join(", ")
  end

  def self.import_from_csv(file)
    CSV.foreach(file.path, headers: true) do |row|
      name = row.field(0).try(:strip)
      email = row.field(1).try(:strip)
      city = row.field(2).try(:strip)
      company = row.field(3).try(:strip)

      if row.field(4)
        skills = row.field(4).split(",").map(&:strip)
      end

      # skip the coaches without emails and the header file
      next if email.blank? || email == "Email"

      coach = Coach.find_by(email: email) || Coach.new
      coach.update_attributes(name: name, email: email, city: city, company: company)
      coach.skills = []

      # Save the skills - either find existing one or create new
      skills.each do |skill|
        ar_skill = Skill.find_by(name: skill.downcase) || Skill.create(name: skill.downcase)
        coach.skills << ar_skill
      end if skills

      coach.save!
    end
  end

  def self.export_all
    t = Tempfile.new(["coaches", ".csv"])
    CSV.open(t.path, "w") do |csv|
      Coach.all.each do |coach|
        csv << [coach.name, coach.email, coach.city, coach.company, coach.skill_names]
      end
    end
    t.path
  end
end

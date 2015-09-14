class Coach < ActiveRecord::Base
  has_and_belongs_to_many :skills
  validates :email, presence: true, uniqueness: true

  scope :praha, -> { where(city: "Praha") }
  scope :brno, -> { where(city: "Brno") }
  scope :others, -> { where.not(city: ["Praha", "Brno"]) }

  scope :web, -> { select { |c| !c.skills
                                 .where(name: ["web","js", "jquery","html/css","fe", "frontend", "html", "css", "php", "wordpress"]).blank?}}

  scope :programming, -> { select { |c| !c.skills
                                          .where(name: ["ruby", "java", "c", "c#", "php", "python", "android", "ios", "rails" ,"django", "oop", "c/c++"]).blank?}}

  scope :graphics, -> { select { |c| !c.skills
                                       .where(name: ["grafika", "photoshop", "adobe", "vizualizace", "gimp", "inskcape"]).blank? }}

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
end

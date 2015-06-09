class Subject < ActiveRecord::Base

	has_many :pages

	acts_as_list

	validates_presence_of :name, :message => "Fill out the field"
	validates_length_of :name, :maximum => 255
		# validates_presence_of vs. validates_length_of :minimum => 1
		# different error messages : "cant' be blank", or "is too short"
		# validates_length_of allows strings with only spaces!

	scope :visible, lambda { where(:visible => true)}
	scope :invisible, lambda { where(:visible => false)}

	scope :sorted, lambda { order("subjects.position ASC")}
	scope :newest_first, lambda{ order("subjects.created_at DESC")}

	scope :search, lambda {|query|
		where(["name LIKE ?", "%#{query}%"])
	}

end

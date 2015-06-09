class AdminUser < ActiveRecord::Base

	# To configure a different table name:
	# self.table_name = "admin_users"

	has_secure_password

	has_and_belongs_to_many :pages
	has_many :section_edits
	has_many :sections, :through => :section_edits

	EMAIL_REGEX = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\Z/i
	FORBIDDEN_USERNAMES = ['littlebopeep', 'humptydumpty', 'marymary']

	validates :first_name, 	:presence => true, 
							:length => { :maximum => 25 }
	
	validates :last_name, 	:presence => true, 
							:length => { :maximum => 50 }

	validates :username, 	:presence => true, 
							:length => { :within => 4..25 }, 
							:uniqueness => true
	
	validates :email, 		:presence => true, 
							:length => { :maximum => 50 },
							:format => { :with => EMAIL_REGEX },
							:confirmation => true

	validate :username_is_allowed
	validate :no_new_users_on_saturday, :on => :create
	
	scope :sorted, -> { order("last_name ASC, first_name ASC") }

	def name
		"#{first_name} #{last_name}"
		# Or: first_name + ' ' last_name
		# Or: [first_name, last_name].join(' ')
	end
	
	private

	def username_is_allowed
		if FORBIDDEN_USERNAMES.include?(username)
			errors.add(:username, "Has been restriced from use")
		end
	end

	# Errors not related to a specific attribute
	# can be added to errors[:base]
	def no_new_users_on_saturday
		if Time.now.wday == 6
			errors[:base] << "No new users on Saturday"
		end
	end

	

end

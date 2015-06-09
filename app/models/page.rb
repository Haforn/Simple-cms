class Page < ActiveRecord::Base

	belongs_to :subject
	has_and_belongs_to_many :editors, :class_name => "AdminUser"
	has_many :sections

	acts_as_list :scope => :subject

	before_validation :add_default_permalink

	after_save :touch_subject

	validates_presence_of :name, :message => "Fill out the field"
	validates_length_of :name, :maximum => 255

	validates_presence_of :permalink
	validates_length_of :permalink, :within => 3..255
	# use presence_of width length_of to disallow spaces
	validates_uniqueness_of :permalink
	# for unique values by subject use ":scope => :subject_id"

	scope :visible, -> { where(:visible => true)}
	scope :invisible, -> { where(:visible => false)}

	scope :sorted, -> { order("pages.position ASC")}
	scope :newest_first, -> { order("pages.created_at DESC")}

	private
		# Callbacks before and after
		def add_default_permalink
			if permalink.blank?
				self.permalink = "#{id}-#{name.parameterize}"
			end
		end

		def touch_subject
			# touch is similar to:
			# subjecft.update_attribute(:updated_at, Time.now)
			subject.touch
		end

		def delete_related_sections
			self.sections.each do |section|
				# Or perhaps instead of destroy, you would
				# move them to a other page
				# section.destroy
			end
		end
end

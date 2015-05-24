class Project < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  validates :name, length: {minimum: 5}, uniqueness: true
  validates :description, length: {minimum: 200}
  validates :goal, presence: true
  validates :expiration_date, presence: true
  validates :sector, presence: true
  validates :address, presence: true

  validates_format_of :video_url, with: /(?:https?:\/\/)?(?:www\.)?((?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11,}))|(?:https?:\/\/)(?:vimeo.com\/([0-9\-_]*))(?:\S)?/, allow_blank: true


  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  belongs_to :user
  has_many :donations, dependent: :destroy
  has_many :blogs, dependent: :destroy

  paginates_per 5

  def set_expiration_date(days)
    if (days).to_i > 0
      self.expiration_date = (Time.now + (days).to_i)
    end
  end

  def has_pic?
    !(self.image_file_size.nil?)
  end

  def has_video?
    !(self.video_url.nil?)
  end

  def is_owner?(user)
    self.user == user
  end

  def is_not_owner?(user)
    self.user != user
  end

  def donation_sum
    self.donations.sum(:amount) / 100
  end

  def remaining
    self.goal - self.donation_sum
  end

  def goal_reached?
    self.remaining <= 0
  end

  def remaining_message
    if self.goal_reached?
      "Goal reached! The crowd has pledged a total of £#{self.donation_sum}."
    elsif self.has_expired?
      "Goal not reached."
    else
      "£#{self.remaining} remaining!"
    end
  end

  def has_expired?
    self.expiration_date <= Time.now
  end

  def has_donated?(user)
    self.donations.any? { |donation| donation.user == user }
  end

  def success?
    self.goal_reached? & self.has_expired?
  end

  def is_payable_by(user)
    self.has_expired? && self.has_donated?(user)
  end
end

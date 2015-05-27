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
  has_many :followers,
    -> { extending WithUserAssociationExtension },
      dependent: :restrict_with_exception,
      dependent: :destroy

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
    self.video_url.length != 0
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
      "Goal reached!"
    elsif self.has_expired?
      "Goal not reached."
    else
      "Pending: £ #{self.remaining}"
    end
  end

  def has_expired?
    self.expiration_date <= Time.now
  end

  def has_been_followed?(current_user)
    followed_by(current_user).length > 0
  end

  def followed_by(current_user)
    (followers&current_user.followers)
  end

  def has_donated?(user)
    self.donations.any? { |donation| donation.user == user }
  end

  def success?
    self.goal_reached? & self.has_expired?
  end

  def is_payable_by(user)
    self.has_donated?(user) && self.success? && !self.was_paid?(user)
  end

  def was_paid?(user)
    return false if self.donations.length == 0
    self.donations.all? { |donation| (donation.user == user && donation.paid) }
  end

  def percentage_goal_completed
    (self.donation_sum.to_f / self.goal.to_f) * 100
  end

  def percentage_goal_pending
    (self.remaining.to_f / self.goal.to_f) * 100
  end
end

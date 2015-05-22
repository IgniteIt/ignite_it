class Project < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  validates :name, length: {minimum: 5}, uniqueness: true
  validates :description, length: {minimum: 200}
  validates :goal, presence: true
  validates :expiration_date, presence: true
  validates :sector, presence: true
  validates :address, presence: true

  validates_format_of :video_url, with: /(?:https?:\/\/)?(?:www\.)?((?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11,}))|(?:https?:\/\/)(?:vimeo.com\/([0-9\-_]+))(?:\S+)?/, allow_blank: true


  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  belongs_to :user
  has_many :donations, dependent: :destroy
  has_many :blogs, dependent: :destroy

  def set_expiration_date(days)
    if (days).to_i > 0
      self.expiration_date = (Time.now + (days).to_i)
    end
  end
end

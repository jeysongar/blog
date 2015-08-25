class Article < ActiveRecord::Base
  
  include AASM
  
  belongs_to :user
  has_many :comments
  has_many :has_categories
  has_many :categories, through: :has_categories
  
  validates :title, presence: true, length: {minimum: 5}, uniqueness: true
  validates :body, presence: true, length: {minimum: 20}
  before_save :set_visits_count
  after_create :save_categories
  #after_create :send_mail
  
  #con esto mas la gema paperclip podemos subir imagenes
  has_attached_file :cover,   
  :storage => :dropbox, :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
  :dropbox_options => {       
    :path => proc { |style| "#{style}/#{id}_#{cover.original_filename}"},      
    :unique_filename => true   
  }
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/
  
  scope :publicados, ->{ where(state: "published") }
  scope :ultimos, ->{ order("created_at DESC") }
  
  #custom setter
  def categories=(value)
    @categories = value
  end
  
  def update_visits_count
    self.save if self.visits_count.nil?
    self.update(visits_count: self.visits_count + 1)
  end
  
  aasm column: "state" do
    state :in_draft, initial: true
    state :published
  
    event :publish do
      transitions from: :in_draft, to: :published
    end
    
    event :unpublish do
      transitions from: :published, to: :in_draft
    end
    
  end
  
  
  private
  
  def send_mail
    ArticleMailer.new_article(self).deliver_later
  end
  
  def save_categories
    @categories.each do |category_id|
      HasCategory.create(category_id: category_id,article_id: self.id)
    end
  end
  
  def set_visits_count
    self.visits_count ||= 0
  end
end

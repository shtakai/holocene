class Story < ApplicationRecord
  include RankedModel
  ThinkingSphinx::Callbacks.append(
    self, behaviours: [:sql]
  )
  belongs_to :book
  ranks :position, with_same: :book_id

  has_many :character_stories
  has_many :characters, through: :character_stories
  has_many :chapters, as: :scripted
  has_many :key_points, -> { order(position: :asc) }, as: :scripted
  has_many :scenes, as: :situated
  has_many :signets, as: :sigged
  has_many :tours

  validates :title, presence: true

  def timeline_json(toggle)
    { events: Scene.get_scenes_to_array(self, toggle).collect { |x| x.slide } }
  end

  def publish?
    publish
  end

  def stand_alone?
    stand_alone
  end

  def print_summary?
    print_summary
  end

  def name
    title
  end

  def resync_key_points
    index = 0
    points = key_points.order(:position).collect do |x|
      x.scenes.order(date_string: :asc, selector: :asc, position: :asc).pluck(:id, :abc, :selector)
    end
    kps = points.collect do |kp|
      kp.collect do |y|
        index += 1
        [y[0], "#{scene_character}%0.5d00" % index]
      end
    end
    kps.each do |updates|
      updates.each do |x|
        scene = Scene.find(x[0])
        scene.update({ abc: x[1] })
      end
    end
    results = []
    key_points.each do |kp|
      kp.scenes.each do |scene|
        scene.characters.each do |character|
          results << character unless results.include?(character)
        end
      end
    end
    results.each do |character|
      characters << character unless characters.include?(character)
    end
  end

  def word_count
    count = 0
    key_points.each do |key_point|
      key_point.scenes.each do |scene|
        count += scene.section.word_count unless scene.section.nil?
      end
    end
    count
  end

  def section_count
    count = 0
    key_points.each do |key_point|
      count += key_point.section_count
    end
    count
  end

  def scene_count(_pub = false)
    count = 0
    key_points.each do |key_point|
      count += key_point.scene_count
    end
    count
  end

  def scene_min
    min = 10_000
    key_points.each do |key_point|
      min = key_point.min if min > key_point.min
    end
    min
  end

  def scene_max
    max = 0
    key_points.each do |key_point|
      max = key_point.max if max < key_point.max
    end
    max
  end

  def set_values
    book = self.book
    [book, self, nil, nil, nil]
  end
end

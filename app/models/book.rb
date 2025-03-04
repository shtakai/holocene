class Book < ApplicationRecord
  include RankedModel

  ThinkingSphinx::Callbacks.append(
    self, behaviours: [:sql]
  )

  belongs_to :user
  ranks :position, with_same: :user_id

  has_rich_text :body
  has_rich_text :publisher

  has_many :key_words, dependent: :destroy
  has_many :glossary_terms, dependent: :destroy
  has_many :biblioentries, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :chapters, as: :scripted
  has_many :key_points, as: :scripted
  has_many :scenes, as: :situated
  has_many :artifacts, dependent: :destroy
  has_many :artifact_types, dependent: :destroy

  has_and_belongs_to_many :authors, dependent: :nullify
  has_and_belongs_to_many :characters, dependent: :nullify

  validates :name, presence: true

  has_many :signets, as: :sigged

  def timeline_json(toggle)
    { events: Scene.get_scenes_to_array(self, toggle).collect { |x| x.slide } }
  end

  def show_events?
    show_events
  end

  def is_fiction?
    fiction
  end

  def resync_stories
    index = 48
    stories.order(:position).each do |story|
      story.update({ scene_character: index.chr })
      index += 1
      index = 65 if index == 58
      story.resync_key_points
    end
  end

  def word_count(published = false)
    count = (body.nil? ? 0 : WordsCounted.count(body.to_plain_text).token_count)
    if is_fiction?
      stories = (published ? self.stories.where(publish: true) : self.stories)
      stories.each do |story|
        story.key_points.each do |key_point|
          key_point.scenes.each do |scene|
            count += scene.section.word_count unless scene.section.nil?
          end
        end
      end
    else
      chapters.each do |chap|
        count += chap.word_count
      end
    end
    count
  end

  def scene_count(published = false)
    count = 0
    stories = (published ? self.stories.where(publish: true) : self.stories)
    stories.each do |story|
      count += story.scene_count
    end
    count
  end

  def section_count
    count = 0
    stories.each do |story|
      count += story.section_count
    end
    count
  end

  def set_values
    [self, nil, nil, nil, nil]
  end
end

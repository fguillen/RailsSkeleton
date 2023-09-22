class ArticlesFilter
  include ActiveModel::Model
  include ActiveModel::Attributes
  # include ActiveModel::Validations
  # include ActiveModel::Validations::Callbacks

  # strip_attributes

  attribute :title, :string
  attribute :tags, array: true, default: []
  attribute :tags_mode, :string, default: "any"
  attribute :created_at_from, :datetime
  attribute :created_at_to, :datetime
  attribute :front_user_name, :string

  validate :created_at_from_should_be_before_created_at_to
  validate :validate_tags_mode

  def filter
    result = Article.all
    result = result.where("title like ?", "%#{title}%")                                      if title.present?

    if !tags.empty?
      result = result.tagged_with(tags, :match_all => true)                                    if tags_mode == "all"
      result = result.tagged_with(tags, :any => true)                                          if tags_mode == "any"
      result = result.tagged_with(tags, :exclude => true)                                      if tags_mode == "exclude"
    end

    result = result.where("articles.created_at >= ?", created_at_from.to_fs(:datetimedb))           if created_at_from.present?
    result = result.where("articles.created_at <= ?", created_at_to.end_of_day.to_fs(:datetimedb))  if created_at_to.present?
    result = result.joins(:front_user).where(
      "upper(front_users.name) like :name or upper(front_users.email) like :name",
      name: "%#{front_user_name.upcase}%")                                                                if front_user_name.present?

    result
  end

  private

  def created_at_from_should_be_before_created_at_to
    if created_at_from.present? && created_at_to.present? && created_at_to < created_at_from
      errors.add(:created_at_from, "Created At From should be before Created At To")
    end
  end

  def validate_tags_mode
    if tags_mode != "all" && tags_mode != "any"
      errors.add(:tags_mode, "tags_mode only allows 'all' or 'any'. Actual value: '#{tags_mode}'")
    end
  end
end

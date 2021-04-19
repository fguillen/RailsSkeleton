require 'test_helper'

class UUIDTest < ActiveSupport::TestCase

  # test that all models the have a uuid column included the HasUuid module
  def test_has_uuid_with_database
    Rails.application.eager_load!
    ApplicationRecord.descendants.each do |model|

      table_uuid_column_exists = model.column_names.include?("uuid")
      model_include_has_uuid = model.included_modules.include?(HasUuid)

      assert_equal(table_uuid_column_exists, model_include_has_uuid,
                   "table #{model.table_name} #{table_uuid_column_exists ? "has" : "doesn't have"} uuid column, but model #{model_include_has_uuid ? "includes" : "doesn't include"} HasUuid module")
    end
  end

  def test_on_create_initialize_uuid
    Rails.application.eager_load!
    ApplicationRecord.descendants.select { |c| c.included_modules.include? HasUuid }.map do |model|
      factory_name = model.name.underscore.to_sym
      record = FactoryBot.build(factory_name)
      assert_nil record.uuid
      record.save!
      assert_not_nil record.uuid
    end
  end

end

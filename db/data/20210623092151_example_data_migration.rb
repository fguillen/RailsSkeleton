class ExampleDataMigration < ActiveRecord::Migration[6.1]
  def up
    # This is just an example
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

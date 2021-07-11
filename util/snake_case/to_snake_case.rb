# frozen_string_literal: true

require 'logger'
require 'main'
require 'sequel'
require 'pg'

# monkey patch from ActiveSupport
class String
  def underscore
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr('-', '_').
      downcase
  end
end

# convert tables and columns of the lter_metabase schema to snake_case if it's
# not already
class Snakeify
  def rename_columns(db, table_schema_and_name, table)
    db.alter_table(table_schema_and_name) do
      table.columns.each do |column_name|
        next if column_name.to_s == column_name.to_s.underscore

        rename_column(column_name, column_name.to_s.underscore)
      end
    end
  end

  def rename_table(db, table_schema_and_name, table_name)
    db.rename_table(table_schema_and_name, Sequel.qualify(:lter_metabase, table_name.underscore))
  end

  def to_snake_case(db_name, production)
    pr = Sequel.postgres(database: db_name, loggers: [Logger.new($stdout)])
    pr.transaction do
      query = "select table_name from information_schema.tables where table_schema = 'lter_metabase'"
      tables = pr[query]

      tables.each do |table_hash|
        table_name = table_hash[:table_name]
        table_schema_and_name = Sequel.qualify(:lter_metabase, table_name)
        table = pr[table_schema_and_name]

        rename_columns(pr, table_schema_and_name, table)
        next if table_name == table_name.underscore

        rename_table(pr, table_schema_and_name, table_name)
      end
      raise unless production
    end
  end
end

Main do
  argument 'db_name'
  option 'production'

  def run
    snake = Snakeify.new
    snake.to_snake_case(params['db_name'].value,
                        params['production'].value)
  end
end

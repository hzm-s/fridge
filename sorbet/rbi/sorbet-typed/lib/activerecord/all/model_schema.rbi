# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi sorbet-typed
#
# If you would like to make changes to this file, great! Please upstream any changes you make here:
#
#   https://github.com/sorbet/sorbet-typed/edit/master/lib/activerecord/all/model_schema.rbi
#
# typed: ignore

# https://github.com/rails/rails/blob/5-2-stable/activerecord/lib/active_record/model_schema.rb
module ActiveRecord::ModelSchema::ClassMethods
  sig { returns(String) }
  def table_name
  end

  sig { params(value: String).void }
  def table_name=(value)
  end

  sig { returns(String) }
  def quoted_table_name
  end

  sig { returns(T::Array[String]) }
  def protected_environments
  end

  sig { params(environments: T::Array[String]).void }
  def protected_environments=(environments)
  end

  sig { returns(T.nilable(String)) }
  def inheritance_column
  end

  sig { params(value: T.nilable(String)).void }
  def inheritance_column=(value)
  end

  sig { returns(T::Array[String]) }
  def ignored_columns
  end

  sig { params(columns: T::Array[String]).void }
  def ignored_columns=(columns)
  end

  sig { returns(T.nilable(String)) }
  def sequence_name
  end

  sig { params(value: String).void }
  def sequence_name=(value)
  end

  sig { returns(T::Boolean) }
  def prefetch_primary_key?
  end

  sig { returns(T::Boolean) }
  def table_exists?
  end

  sig { returns(T::Hash[String, ActiveRecord::ConnectionAdapters::Column]) }
  def columns_hash
  end

  sig { returns(T::Array[ActiveRecord::ConnectionAdapters::Column]) }
  def columns
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def column_defaults
  end

  sig { returns(T::Array[ActiveRecord::ConnectionAdapters::Column]) }
  def content_columns
  end
end

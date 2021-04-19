class AdminPasswordValidator < ActiveModel::Validator
  PASSWORD_CHARS = [/[a-z]/, /[A-Z]/, /[0-9]/, /[\W]/]

  def validate(record)
    password_size(record)
    password_does_not_contain_name(record)
    password_complexity(record)
  end

  private

  def password_size(record)
    return true unless record.send(:require_password?)

    validator =
      ActiveModel::Validations::LengthValidator.new(
        :minimum => 8,
        :attributes => :password
      )

    validator.validate(record)
  end

  def password_does_not_contain_name(record)
    return true unless record.send(:require_password?)

    name_parts = record.name.downcase.split(' ').compact

    if name_parts.any? { |name_part| record.password.downcase.include?(name_part) }
      record.errors.add(:password, :contains_name)
      return false
    end
  end

  def password_complexity(record)
    return true unless record.send(:require_password?)

    if PASSWORD_CHARS.map { |r| record.password.match?(r) }.count(true) < 3
      record.errors.add(:password, :weak_password)
      return false
    end
  end
end

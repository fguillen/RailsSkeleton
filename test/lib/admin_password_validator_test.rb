require "test_helper"

class AdminPasswordValidatable
  include ActiveModel::Validations
  validates_with AdminPasswordValidator
  attr_accessor :password, :name, :require_password

  def require_password?
    require_password
  end
end

class AdminPasswordValidatorTest < Minitest::Test
  def test_success_when_require_password_false
    admin_password_validator = AdminPasswordValidatable.new
    admin_password_validator.name = "John Doe"
    admin_password_validator.password = "Johnpasswordnoanyrules"
    admin_password_validator.require_password = false

    assert admin_password_validator.valid?
  end

  def test_password_does_not_contain_name_success
    admin_password_validator = AdminPasswordValidatable.new
    admin_password_validator.name = "John Doe"
    admin_password_validator.password = "ValidPasswordNotName!"
    admin_password_validator.require_password = true

    assert admin_password_validator.valid?
  end

  def test_password_does_not_contain_name_fail
    admin_password_validator = AdminPasswordValidatable.new
    admin_password_validator.name = "John Doe"
    admin_password_validator.password = "PasswordWithJohn!"
    admin_password_validator.require_password = true

    refute admin_password_validator.valid?
    assert_equal ["can’t contain the user name or parts of the user’s full name, such as first name."], admin_password_validator.errors[:password]
  end

  def test_password_complexity_success
    valid_passwords = [
      'Passwd!@',
      'passwd123!',
      'PASSWd!@',
      'a!123456',
      'Passwd123',
      'PASSWD123!',
      'Password123!'
    ]

    valid_passwords.each do |pass|
      admin_password_validator = AdminPasswordValidatable.new
      admin_password_validator.name = "John Doe"
      admin_password_validator.password = pass
      admin_password_validator.require_password = true

      assert admin_password_validator.valid?
    end
  end

  def test_password_complexity_fail
    invalid_passwords = [
      'Password',
      'passwd123',
      'passwd!@$',
      'PASSWORD1',
      'PASSWORD!',
      '!@#$%^&*1',
      'a!@#$%^&*('
    ]

    invalid_passwords.each do |pass|
      admin_password_validator = AdminPasswordValidatable.new
      admin_password_validator.name = "John Doe"
      admin_password_validator.password = pass
      admin_password_validator.require_password = true

      refute admin_password_validator.valid?
      assert_equal ["must use at least three of the four available character types: lowercase letters, uppercase letters, numbers, and symbols."], admin_password_validator.errors[:password]
    end
  end
end

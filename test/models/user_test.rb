require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar" )
  end

  test 'it should be valid' do
      assert @user.valid?
  end

  test 'it is not valid' do
    @user.name = ""
    assert_not @user.valid?
  end

  test 'it requires an email' do
    @user.email = ""
    assert_not @user.valid?
  end

  test 'name cannot exceed max length' do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test 'email cannot exceed max length' do
    @user.email = "a" * 250 + "example.com"
    assert_not @user.valid?
  end

  test 'email validation should accept valid emails' do
    valid_addresses = %w[hi@gmail.com userDSDFH@foo.com HERo@gmail.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'it reject invalid email' do
    invalid_addresses = %w[user@example,com user_atfoo.com user.name@eample.comfoo@afjhlsdfj;sdfadwww]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'password should have a minimum length' do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Me", :email => "me@mine.com" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    noname_user = User.new(@attr.merge(:name => ""))
    noname_user.should_not be_valid
  end

  it "should require an email address" do
    noname_user = User.new(@attr.merge(:email => ""))
    noname_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com X_USER@foo.bar.org first.LAST@foo.JP]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should not accept invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org first.LAST@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    duplicate_email_user = User.new(@attr)
    duplicate_email_user.should_not be_valid
  end

end

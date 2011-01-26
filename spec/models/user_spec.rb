require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Me", :email => "me@mine.com", :password => "foobar", :password_confirmation => "foobar" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  ## :name attribute testing
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

  ## :email attribute testing
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
  
  ## :password attribute testing
  describe "password validations" do
    it "should require a password" do
      user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
      user.should_not be_valid
    end
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
  
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    it "should be true if the passwords match" do
      @user.has_password?(@attr[:password]).should be_true
    end
    
    it "should be false if the passwords don't match" do
      @user.has_password?("invalid").should be_false
    end
    
    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
    
  end


end

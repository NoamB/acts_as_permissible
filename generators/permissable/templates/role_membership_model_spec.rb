require File.dirname(__FILE__) + '/../spec_helper'

describe "<%= role_membership_model_name %>" do
  
  describe "validations" do
    before(:each) do
      @membership = <%= role_membership_model_name %>.new(:roleable_id => 1, :roleable_type => "<%= role_model_name %>", :<%= role_model_file_name %>_id => 2)
    end
    
    it "should be valid" do
      @membership.should be_valid
    end
    
    # roleable_id
    it "should have a roleable_id" do
      @membership.roleable_id = nil
      @membership.should_not be_valid
    end
    
    it "roleable_id should be an integer" do
      @membership.roleable_id = "asd"
      @membership.should_not be_valid
    end
    
    # roleable_type
    it "should have a roleable_type" do
      @membership.roleable_type = nil
      @membership.should_not be_valid
    end
    
    it "roleable_type should be a string" do
      @membership.roleable_type = 123
      @membership.should_not be_valid
    end
    
    it "roleable_type should have a class name format" do
      @membership.roleable_type = "asd"
      @membership.should_not be_valid
      @membership.roleable_type = "User"
      @membership.should be_valid
      @membership.roleable_type = "Some95WierdClassN4m3"
      @membership.should be_valid
    end
    
    # <%= role_model_file_name %>_id
    it "should have a <%= role_model_file_name %>_id" do
      @membership.<%= role_model_file_name %>_id = nil
      @membership.should_not be_valid
    end
    
    it "<%= role_model_file_name %>_id should be an integer" do
      @membership.<%= role_model_file_name %>_id = "asd"
      @membership.should_not be_valid
    end
    
    it "should not allow a <%= role_model_file_name %> to belong to itself" do
      @membership.<%= role_model_file_name %>_id = 1
      @membership.should_not be_valid
    end
    
  end
end
require File.dirname(__FILE__) + '/../spec_helper'

describe <%= class_name %>, "to_hash" do
  before(:each) do
    @permission = <%= class_name %>.new(:permissable_id => 1, :permissable_type => "User", :action => "some_action", :granted => 1)
  end
  
  it "to_hash returns {} if new record" do
    @permission.to_hash.should == {}
  end
  
  it "to_hash returns {action => granted}" do
    @permission.save
    @permission.to_hash.should == {"some_action" => true}
  end

end

describe <%= class_name %>, "validations" do
  before(:each) do
    @permission = <%= class_name %>.new(:permissable_id => 1, :permissable_type => "User", :action => "some_action", :granted => 1)
  end
  
  it "should be valid" do
    @permission.should be_valid
  end

  it "action should be unique to a permissable id and type" do
    @permission.save
    @permission2 = <%= class_name %>.new(:permissable_id => 1, :permissable_type => "User", :action => "some_action", :granted => 0)
    @permission2.should_not be_valid
  end
  
  it "must have a permissable_id" do
    @permission.permissable_id = nil
    @permission.should_not be_valid
  end
  
  it "must have a permissable_type" do
    @permission.permissable_type = nil
    @permission.should_not be_valid
  end
  
  it "must have an action" do
    @permission.action = nil
    @permission.should_not be_valid
    @permission.action = ""
    @permission.should_not be_valid
  end
  
end

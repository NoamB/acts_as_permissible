class <%= role_membership_model_name %> < ActiveRecord::Base
  #belongs_to :user
  belongs_to :<%= role_model_file_name %>
  belongs_to :roleable, :polymorphic => true
  
  validates_uniqueness_of :<%= role_model_file_name %>_id, :scope => [:roleable_id, :roleable_type]
end
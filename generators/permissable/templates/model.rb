class <%= class_name %> < ActiveRecord::Base
  # uncomment any of the following lines which is relevant to your application,
  # or create your own with the name of the model which acts_as_permissable.
  #belongs_to :user
  belongs_to :<%= role_model_file_name %>
  belongs_to :permissable, :polymorphic => true
  
  validates_presence_of :permissable_id, :permissable_type, :action
  validates_format_of :action, :with => /^[a-z_]+$/
  validates_numericality_of :permissable_id
  validates_uniqueness_of :action, :scope => [:permissable_id,:permissable_type]
  
  def to_hash
    self.new_record? ? {} : {self.action => self.granted}
  end
  
end
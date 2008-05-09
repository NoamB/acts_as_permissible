class <%= role_membership_model_name %> < ActiveRecord::Base
  #belongs_to :user
  belongs_to :<%= role_model_file_name %>
  belongs_to :roleable, :polymorphic => true
  
  validates_presence_of :roleable_id, :roleable_type, :<%= role_model_file_name %>_id
  validates_uniqueness_of :<%= role_model_file_name %>_id, :scope => [:roleable_id, :roleable_type]
  validates_numericality_of :roleable_id, :<%= role_model_file_name %>_id
  validates_format_of :roleable_type, :with => /^[A-Z]{1}[a-z0-9]+([A-Z]{1}[a-z0-9]+)*$/
  validate :<%= role_model_file_name %>_does_not_belong_to_itself
  validate :<%= role_model_file_name.pluralize %>_cannot_belong_to_each_other
  
  protected
  def <%= role_model_file_name %>_does_not_belong_to_itself
    if <%= role_model_file_name %>_id == roleable_id && roleable_type == "<%= role_model_name %>"
      errors.add_to_base("A <%= role_model_file_name %> cannot belong to itself.")
    end
  end
  
  def <%= role_model_file_name.pluralize %>_cannot_belong_to_each_other
    if roleable_type == '<%= role_model_name %>'
      if self.class.find(:first, :conditions => ["roleable_type='<%= role_model_name %>' AND <%= role_model_file_name %>_id=? AND roleable_id=?",roleable_id,<%= role_model_file_name %>_id])
        errors.add_to_base("A <%= role_model_file_name %> cannot belong to a <%= role_model_file_name %> which belongs to it.")
      end
    end
  end
end
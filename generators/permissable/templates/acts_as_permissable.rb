# ActsAsPermissable
module NoamBenAri
  module Acts #:nodoc:
    module Permissable #:nodoc:

      def self.included(base)
        base.extend ClassMethods  
      end

      module ClassMethods
        def acts_as_permissable
          has_many :<%= table_name %>, :as => :permissable, :dependent => :destroy
          <% unless options[:skip_roles] %>
          has_many :<%= role_membership_model_file_name.pluralize %>, :as => :roleable, :dependent => :destroy
          has_many :<%= role_model_file_name.pluralize %>, :through => :<%= role_membership_model_file_name.pluralize %>, :source => :<%= role_model_file_name %>
          <% end %>
          include NoamBenAri::Acts::Permissable::InstanceMethods
          extend NoamBenAri::Acts::Permissable::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
        
        # Helper method to lookup for permissions for a given object.
        # This method is equivalent to obj.permissions.
        def find_permissions_for(obj)
          permissable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
         
          <%= class_name %>.find(:all,
            :conditions => ["permissable_id = ? and permissable_type = ?", obj.id, permissable]
          )
        end
      end
      
      # This module contains instance methods
      module InstanceMethods
        
        # returns permissions in hash form
        def permissions_hash
          @permissions_hash ||= <%= table_name %>.inject({}) { |hsh,perm| hsh.merge(perm.to_hash) }.symbolize_keys!
        end
        
        # accepts a permission identifier string or an array of permission identifier strings
        # and return true if the user has all of the permissions given by the parameters
        # false if not.
        def has_permission?(*perms)
          perms.all? {|perm| permissions_hash.include?(perm.to_sym) && (permissions_hash[perm.to_sym] == true) }
        end
        
        # accepts a permission identifier string or an array of permission identifier strings
        # and return true if the user has any of the permissions given by the parameters
        # false if none.
        def has_any_permission?(*perms)
          perms.any? {|perm| permissions_hash.include?(perm.to_sym) && (permissions_hash[perm.to_sym] == true) }
        end
        
        # Merges another permissable object's permissions into this permissable's permissions hash
        # In the case of identical keys, a false value wins over a true value.
        def merge_permissions!(other_permissions_hash)
          permissions_hash.merge!(other_permissions_hash) {|key,oldval,newval| oldval.nil? ? newval : oldval && newval}
        end

        # Resets permissions and then loads them.
        def reload_permissions!
          reset_permissions!
          permissions_hash
        end
        
        <% unless options[:skip_roles] %>
        def <%= role_model_file_name %>s_list
          list = []
          <%= role_model_file_name %>s.inject(list) {|list,<%= role_model_file_name %>| list << <%= role_model_file_name %>.name}
          list.uniq
        end
        
        def in_<%= role_model_file_name %>?(*<%= role_model_file_name %>_names)
          <%= role_model_file_name %>_names.all? {|<%= role_model_file_name %>| <%= role_model_file_name %>s_list.include?(<%= role_model_file_name %>) }
        end
        
        def in_any_<%= role_model_file_name %>?(*<%= role_model_file_name %>_names)
          <%= role_model_file_name %>_names.any? {|<%= role_model_file_name %>| <%= role_model_file_name %>s_list.include?(<%= role_model_file_name %>) }
        end
        <% end %>
        
        private
        # Nilifies permissions_hash instance variable.
        def reset_permissions!
          @permissions_hash = nil
          #permissions.reset #FIXME: is this needed or not? tests say no.
        end
        
        
        # # load associated objects' permissions and merge them into a hash recursively.
        # # in the case of duplicate keys, a 'false' value will win over a 'true' value.
        # def load_permissions_recursively(associated_collection_name = self.class.name.downcase.pluralize.to_sym)
        #   self.load_permissions
        #   self.send(associated_collection_name).each do |associated_obj|
        #     associated_obj_permissions = associated_obj.load_permissions_recursively(associated_collection_name)
        #     self.merge_permissions!(associated_obj_permissions)
        #   end
        #   return @permissions_hash
        # end
        # 
        # def reset_permissions_recursively(associated_collection_name = self.class.name.downcase.pluralize.to_sym)
        #   self.send(associated_collection_name).each { |associated_obj| associated_obj.reset_permissions_recursively(associated_collection_name) }
        #   self.reset_permissions
        #   self.send(associated_collection_name).reset
        # end   
      end
      
    end
  end
end

require 'lib/acts_as_permissable'
ActiveRecord::Base.send(:include, NoamBenAri::Acts::Permissable)
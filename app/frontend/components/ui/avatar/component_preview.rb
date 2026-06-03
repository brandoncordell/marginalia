# frozen_string_literal: true

module Ui
  module Avatar
    # @display bg_color "#f7f3ee"
    class ComponentPreview < ApplicationViewComponentPreview
      # Default avatar (medium).
      def default
        render Ui::Avatar::Component.new(user: sample_user)
      end

      # @param size select { choices: [sm, md, lg] }
      def sizes(size: :md)
        render Ui::Avatar::Component.new(user: sample_user, size: size.to_sym)
      end

      # @param first_name text
      # @param last_name text
      def playground(first_name: 'Ada', last_name: 'Lovelace')
        render Ui::Avatar::Component.new(user: User.new(first_name:, last_name:))
      end

      private

      def sample_user
        User.new(first_name: 'Ada', last_name: 'Lovelace')
      end
    end
  end
end

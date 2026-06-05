# frozen_string_literal: true

module Ui
  module Avatar
    # @display bg_color "#f7f3ee"
    class ComponentPreview < ApplicationViewComponentPreview
      # Default avatar (medium)
      def default
        render Ui::Avatar::Component.new(user: sample_user)
      end

      # @!group Sizes
      def sm
        render Ui::Avatar::Component.new(user: sample_user, size: :sm)
      end

      def md
        render Ui::Avatar::Component.new(user: sample_user, size: :md)
      end

      def lg
        render Ui::Avatar::Component.new(user: sample_user, size: :lg)
      end
      # @!endgroup

      # @param first_name text
      # @param last_name text
      # @param size select { choices: [sm, md, lg] }
      def playground(first_name: 'Ada', last_name: 'Lovelace', size: :md)
        render Ui::Avatar::Component.new(user: User.new(first_name:, last_name:), size: size.to_sym)
      end

      private

      def sample_user
        User.new(first_name: 'Ada', last_name: 'Lovelace')
      end
    end
  end
end

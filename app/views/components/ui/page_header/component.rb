# frozen_string_literal: true

module Ui
  module PageHeader
    # Page title component
    class Component < ApplicationViewComponent
      erb_template <<-ERB
        <h1 class="font-display text-5xl tracking-tight leading-[1.05] wrap-balance">
          <%= content %>
        </h1>
      ERB
    end
  end
end

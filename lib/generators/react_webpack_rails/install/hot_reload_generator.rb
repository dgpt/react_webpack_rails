module ReactWebpackRails
  module Install
    require 'generators/react_webpack_rails/merge_helpers'

    class HotReloadGenerator < Rails::Generators::Base
      include MergeHelpers
      desc 'Add hot reload setup'
      source_root File.expand_path('../../templates', __FILE__)

      class_option :tmp_package,
                   type: :boolean,
                   default: false,
                   desc: 'Force update tmp/package.json instead package.json'

      def package
        merge_options = options.tmp_package ? { package_file: 'tmp/package.json', force: true } : {}
        merge_into_package 'packages/hot-reload.json', merge_options
      end

      def hot_dev_config
        copy_file 'webpack/hot-dev.config.js', 'webpack/hot-dev.config.js'
      end

      def partial
        copy_file 'partial/_react_hot_assets.html.erb', 'app/views/layouts/_react_hot_assets.html.erb'

        inject_into_file 'app/views/layouts/application.html.erb', after: "<body>\n" do <<-'HTML'.strip_heredoc
          <%= render 'layouts/react_hot_assets' %>
        HTML
        end
      end
    end
  end
end

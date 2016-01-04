require 'erb'
require 'fileutils'
require 'securerandom'
require_relative '../../../version.rb'

module Pakyow
  module Generators
    class AppGenerator
      class << self
        def start
          case ARGV.first
          when '--help', '-h', nil
            puts File.open(File.join(PAK_PATH, 'commands/USAGE-NEW')).read
          else
            generator = self.new(ARGV.first)
            generator.build
          end
        end
      end

      FILENAME_TRANSLATIONS = {
        'rspec' => '.rspec',
        'gitignore' => '.gitignore',
        'env' => '.env',
        'env.example' => '.env.example'
      }

      def initialize(dest)
        @src = "#{File.expand_path('../', __FILE__)}/templates/."
        @dest = dest
      end

      def build
        puts "Generating project: #{@dest}"

        if !File.directory?(@dest) || (Dir.entries(@dest) - ['.', '..']).empty?
          copy
        else
          ARGV.clear
          print "The folder '#{@dest}' is in use. Would you like to populate it anyway? [Yn] "

          if gets.chomp! == 'Y'
            copy
          else
            puts "Aborted!"
            exit
          end
        end

        add_pakyow_to_gemfile
        exec
        puts "Done! Run `cd #{@dest}; pakyow server` to get started!"
      end

      protected

      def copy
        FileUtils.mkdir(@dest) unless File.exists?(@dest)

        Dir.glob(File.join(@src, '**', '*')).each do |path|
          relative_path = path[@src.length..-1]
          generated_path = File.join(@dest, File.dirname(relative_path), translated_filename(File.basename(relative_path)))

          if File.directory?(path)
            FileUtils.mkdir(generated_path)
            next
          end

          erb = ERB.new(File.read(path))
          File.open(generated_path, 'w') { |f| f.write(erb.result(binding)) }
        end
      end

      def add_pakyow_to_gemfile
        File.open("#{@dest}/Gemfile", 'a') { |f|
          if Gem::Version.create(Pakyow::VERSION) > Gem.latest_version_for('pakyow')
            f.puts "gem 'pakyow', github: 'pakyow/pakyow'"
            pakyow_version = 'master'
          else 
            f.puts "gem 'pakyow', '~> 0.10'"
            pakyow_version = '~> 0.10'
          end
          puts "Adding Pakyow #{pakyow_version} to Gemfile"
        }
      end

      def exec
        FileUtils.cd(@dest) do
          puts "Running `bundle install` in #{Dir.pwd}"
          system("bundle install --binstubs")
        end
      end

      def translated_filename(filename)
        FILENAME_TRANSLATIONS.fetch(filename, filename)
      end

      def generate_session_secret
        SecureRandom.hex(64)
      end

      def app_name
        File.basename(@dest)
      end
    end
  end
end

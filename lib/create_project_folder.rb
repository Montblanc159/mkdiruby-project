# frozen_string_literal: true

require 'tty-prompt'
require 'colorize'
require 'pry'

def check_if_user_gave_input
  abort("mkrubydir: missing input") if ARGV.empty?
end


def ruby_file_names
  puts "\nList your ruby files separated by a space :"
  print "> "
  file_name = gets.chomp.split(" ")
end

def create_main_dir
  main_dir = ARGV.join
  Dir.mkdir(main_dir)
  puts "Directory: #{main_dir} directory created".colorize(:green)
  Dir.chdir(main_dir)
  ARGV.clear
end

def create_folders
  Dir.mkdir("./lib")
  Dir.mkdir("./lib/app")
  Dir.mkdir("./lib/views")
  Dir.mkdir("./spec")
  Dir.mkdir("./db")
  puts "Directory: subdirectories created".colorize(:green)
end

def create_files
  system("touch app.rb")
  file = File.open("app.rb", "w")
  file.puts("# frozen_string_literal: true")
  file.puts("")
  file.puts('$:.unshift File.expand_path("./../lib", __FILE__)')
  file.puts("require 'views/index'")
  file.puts("require 'views/done'")
  file.close
  puts "File: app.rb created".colorize(:green)

  system("touch ./lib/views/index.rb")
  file = File.open("./lib/views/index.rb", "w")
  file.puts("# frozen_string_literal: true")
  file.close
  puts "File: index.rb created".colorize(:green)

  system("touch ./lib/views/done.rb")
  file = File.open("./lib/views/done.rb", "w")
  file.puts("# frozen_string_literal: true")
  file.close
  puts "File: done.rb created".colorize(:green)

  ruby_file_names.each do |ruby_file|
    system("touch lib/app/#{ruby_file}.rb")
    file = File.open("./lib/app/#{ruby_file}.rb", "w")
    file.puts("# frozen_string_literal: true")
    file.puts("")
    file.close
    puts "File: #{ruby_file}.rb created".colorize(:green)

    system("touch spec/#{ruby_file}_spec.rb")
    file = File.open("./spec/#{ruby_file}_spec.rb", "w")
    file.puts("# frozen_string_literal : true")
    file.puts("")
    file.puts("require_relative '../lib/#{ruby_file}.rb'")
    file.close
    puts "File: #{ruby_file}_spec.rb created".colorize(:green)

    app = File.open("app.rb", "a")
    app.puts("require 'app/#{ruby_file}'")
    app.close
    puts "File: #{ruby_file} requirement added to app.rb".colorize(:green)
  end

  file = File.open("app.rb", "a")
  file.puts("require 'bundler'")
  file.puts("")
  file.puts("Bundler.require")
  file.puts("Dotenv.load")
  file.close
  puts "File: requirements added to app.rb".colorize(:green)

  system("touch .env")

  system("touch .gitignore")
  file = File.open(".gitignore", "w")
  file.puts(".env")
  file.close
  puts "File: .gitignore added and updated with .env".colorize(:green)

  system("touch README.md")
  file = File.open("README.md", "w")
  file.puts("#")
  file.puts("")
  file.puts("**This is a Ruby project**")
  file.puts("")
  file.puts("Created by")
  file.close
  puts "File: README.md created".colorize(:green)
end

def create_gem_file
  system("touch Gemfile")
  puts "File: Gemfile created".colorize(:green)
  file = File.open("Gemfile", "w")
  file.puts('source "https://rubygems.org"')
  file.puts("ruby '2.5.1'")
  file.puts("gem 'rubocop', '~> 0.57.2'")
  file.puts("gem 'rspec'")
  file.puts("gem 'rb-readline'")
  file.puts("gem 'pry'")
  file.puts("gem 'dotenv'")
  puts "File: base Gemfile requirements added".colorize(:green)
  file.close
end

def add_gem_requirements
  puts "\nList all gems required separated by a space :"
  print "> "
  gems_required = gets.chomp.split(" ")
  unless gems_required == ""
    gems_required.each do |gem_required|
      file = File.open("Gemfile", "a")
      file.puts("gem '#{gem_required}'")
      file.close
      puts "File: #{gem_required} added to Gemfile".colorize(:green)
    end
  end
end

def term_inits
  system("rspec --init")
  puts "Rspec: rspec initialized".colorize(:green)
  system("git init")
  system("bundle install")
  system("git add .")
  puts "Git: files added".colorize(:green)

  prompt = TTY::Prompt.new
  if prompt.yes?('Would you like to create a github repo ?')
    system("hub create")
    puts "Git: Remote github repo created".colorize(:green)
  else
    puts "Git: No remote github repo created".colorize(:yellow)
  end

  puts "\nCopy the adress of the main remote git :".colorize("blue")
  print "> "
  git_adress = gets.chomp

  unless git_adress == ""
    system("git remote add origin #{git_adress}")
    puts "Git: #{git_adress} git remote added".colorize(:green)
  else
    puts "Git: No git remote added".colorize(:yellow)
  end
  puts "Launching Atom".colorize(:blue)
  system("atom .")
end

def perform
  check_if_user_gave_input
  create_main_dir
  create_folders
  create_gem_file
  add_gem_requirements
  create_files
  term_inits
end

perform

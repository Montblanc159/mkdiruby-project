# frozen_string_literal : true

require 'colorize'

def check_if_user_gave_input
  abort("mkdir: missing input") if ARGV.empty?
end


def ruby_file_names
  puts "Entrez le nom de vos fichiers séparés d'un espace :"
  print "> "
  file_name = gets.chomp.split(" ")
end

def create_main_dir
  main_dir = ARGV.join
  Dir.mkdir(main_dir)
  Dir.chdir(main_dir)
  ARGV.clear
end

def create_folders
  Dir.mkdir("./lib")
  Dir.mkdir("./spec")
end

def create_files
  ruby_file_names.each do |ruby_file|
    system("touch lib/#{ruby_file}.rb")
    file = File.open("./lib/#{ruby_file}.rb", "w")
    file.puts("# frozen_string_literal : true")
    file.puts("")
    file.puts("require 'pry'")
    file.puts("require 'dotenv'")
    file.puts("")
    file.puts("Dotenv.load")
    file.close

    system("touch spec/#{ruby_file}_spec.rb")
    file = File.open("./spec/#{ruby_file}_spec.rb", "w")
    file.puts("# frozen_string_literal : true")
    file.puts("")
    file.puts("require_relative '../lib/#{ruby_file}.rb'")
    file.close
  end
  system("touch .env")
  file = File.open(".env")
  file.close

  system("touch .gitignore")
  file = File.open(".gitignore", "w")
  file.puts(".env")
  file.close

  system("touch README.md")
  file = File.open("README.md", "w")
  file.puts("#")
  file.puts("")
  file.puts("**Ceci est un projet ruby**")
  file.puts("")
  file.puts("Réalisé par")
  file.close
end

def create_gem_file
  system("touch Gemfile")
  file = File.open("Gemfile", "w")
  file.puts('source "https://rubygems.org"')
  file.puts("ruby '2.5.1'")
  file.puts("gem 'rubocop', '~> 0.57.2'")
  file.puts("gem 'rspec'")
  file.puts("gem 'pry'")
  file.close
end

def term_inits
  system("rspec --init")
  system("git init")
  system("bundle install")
  system("git add .")

  puts "Copy the adress of the main remote git :".colorize("blue")
  print "> "
  git_adress = gets.chomp

  system("git remote add origin #{git_adress}")
  system("atom .")
end

def perform
  check_if_user_gave_input
  create_main_dir
  create_folders
  create_gem_file
  create_files
  term_inits
end

perform

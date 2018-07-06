#!/usr/bin/ruby
#######################################################################################################################
require 'yaml'
require 'deep_merge'
require 'pp'
######################################################################################################################
hiera_yaml_file    = './hiera.yaml'
hieradata_root_dir = './data'
hr                 = "-------------------------------------------------"
######################################################################################################################
puts "\nFACTS USED IN HIERARCHY:\n#{hr}"    # extend if there are more facts used
print "NODETYPE: "
nodetype = gets.chomp
######################################################################################################################
hiera_yaml = YAML.load(File.read(hiera_yaml_file))
levels = hiera_yaml['hierarchy']
yaml_files = Array.new
levels.each do |level|
  yaml_files << level['path']
end
yaml_files.map! { |item| item.gsub("%{nodetype}", "#{nodetype}") }    # extend if there are more facts used
######################################################################################################################
i = 0
declared_files_size = yaml_files.size
matched_yaml_files = Array.new
while i < declared_files_size do
  file = yaml_files[i]
  if File.exist?("#{hieradata_root_dir}/#{file}")    # makes sure file exists
    matched_yaml_files << file
  end
  i = i + 1
end
######################################################################################################################
existing_files_size = matched_yaml_files.size
if existing_files_size > 0
  puts "\nYAML FILES TO BE MERGED:\n#{hr}"
  matched_yaml_files.each { |file| puts "#{hieradata_root_dir}/#{file}" }
  i = 0
  output = ''
  if existing_files_size == 1    # just print out that one file
    output = YAML::load(File.read("#{hieradata_root_dir}/#{matched_yaml_files[0]}"))
  else    # merge multiple files
    while i < existing_files_size-1 do
      if i == 0
        file1 = matched_yaml_files[i]
        f1 = File.read("#{hieradata_root_dir}/#{file1}")
        yaml1 = YAML::load(f1)
      else
        yaml1 = output
      end
      file2 = matched_yaml_files[i+1]
      f2 = File.read("#{hieradata_root_dir}/#{file2}")
      yaml2 = YAML::load(f2)
      output = yaml1.deep_merge(yaml2)
      i = i + 1
    end
  end
  puts "\nDEEP-MERGING OUTPUT:\n#{hr}"
  pp output
  puts "\n"
else
  puts "\n[ERROR] No .yaml files found!\n"
end

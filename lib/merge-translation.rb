#!/usr/bin/ruby

require 'yaml'
require 'json'

# Avoids previous translation to be overwritten by English translation.
# This function iterates through the new_translation, and restore the previous
# translations from prev_translation to new_translation.
# If a translation in new_translation is already in prev_translation, and
# the new translation is the same in en_translation, but different from the
# previous translation, update the new_translation with the prev_translation.

def merge_translation_tree(en_translation, new_translation, prev_translation)
  if !new_translation.is_a?(Hash)
    # Leaf node, a translation.
    # New translation equals to English, and old translation already exists
    if !prev_translation.nil? && new_translation == en_translation &&
       new_translation != prev_translation
      new_translation = prev_translation
    end
  else
    # Recursive merge for subtree.
    new_translation.each_key do |key|
      if en_translation.has_key?(key) && prev_translation.has_key?(key)
        new_translation[key] =
          merge_translation_tree(en_translation[key],
                                 new_translation[key],
                                 prev_translation[key])
      end
    end
  end
  new_translation
end

# Translation begins
if ARGV[0] == "yml"
  en_translation = YAML.load_file("#{ARGV[1]}")
  new_translation = YAML.load_file("#{ARGV[2]}")
  prev_translation = YAML.load_file("#{ARGV[3]}")

  # Get new translation
  new_translation[new_translation.keys[0]] =
    merge_translation_tree(en_translation.values[0],
                           new_translation.values[0],
                           prev_translation.values[0])

  File.open("#{ARGV[3]}", 'w+') do |f|
    f.write(new_translation.to_yaml)
  end
else
  en_translation = JSON.parse(File.read("#{ARGV[1]}"))
  new_translation = JSON.parse(File.read("#{ARGV[2]}"))
  prev_translation = JSON.parse(File.read("#{ARGV[3]}"))

  # Get new translation
  new_translation = merge_translation_tree(en_translation,
                                           new_translation,
                                           prev_translation)

  File.open("#{ARGV[3]}", 'w+') do |f|
    f.write(JSON.pretty_generate(new_translation))
  end
end

puts "#{ARGV[2]} + #{ARGV[1]} => #{ARGV[3]}"

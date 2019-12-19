#!/usr/bin/env ruby

$LOAD_PATH << File.dirname( __FILE__ )

require 'optparse'
require 'levenshtein'
require 'parallel'
require 'yaml'
require 'time'

$options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{__FILE__} [options]"

  $options[:recordingdir] = nil
  opts.on( '-r', '--recording-dir DIR', 'Directory of recordings.' ) do |dir|
    $options[:recordingdir] = dir
  end

  $options[:traindir] = nil
  opts.on( '-t', '--train-dir DIR', 'Training directory.') do |dir|
    $options[:traindir] = dir
  end

  $options[:truncate] = 1_000_000
  opts.on( '-m', '--max-length LEN', 'Truncate strings to this length before computing distance.' ) do |len|
    $options[:truncate] = len.to_i
  end

  $options[:outputfile] = nil
  opts.on( '-o', '--output-file FILE', 'Save computed distances to this YAML file.' ) do |path|
    $options[:outputfile] = path
  end
end

def exit_with_message(optparse, msg)
  STDERR.puts "[!] #{msg}"
  STDERR.puts optparse
  exit(false)
end

begin
  optparse.parse!
rescue OptionParser::InvalidOption
  exit_with_message(optparse, "Invalid option.")
rescue OptionParser::MissingArgument
  exit_with_message(optparse, "Missing argument.")
end

if $options[:traindir].nil?
  exit_with_message(optparse, "Missing --train-dir")
end
unless Dir.exist?($options[:traindir])
  exit_with_message(optparse, "Training directory does not exist.")
end

if $options[:recordingdir].nil?
  exit_with_message(optparse, "Missing --recording-dir")
end
unless Dir.exist?($options[:recordingdir])
  exit_with_message(optparse, "Recording directory does not exist.")
end


metadata_path = File.join($options[:traindir], "METADATA")
metadata = File.readlines(metadata_path)

hash_to_url = {}

metadata.each do |line|
  line = line.chomp
  s = line.split(": ")
  hash_to_url[s[0]] = s[1]
end

output_yaml = {}

Dir.foreach( $options[:recordingdir] ) do |filename|
  next if [".", ".."].include? filename

  rec_path = File.join($options[:recordingdir], filename)
  recording = File.read(rec_path)

  # Remove missed slot counts
  recording.gsub!(/\{\d+\}/, '')
  if(recording.length<5)
    puts "deteced, but sequence too short"
    exit
  end


  train_files = Dir.entries( $options[:traindir] ) - [".", "..", "METADATA"]

  distances = Parallel.map( train_files ) do |train_file|
    train_path = File.join($options[:traindir], train_file)
    training = File.read(train_path)
    # Removed missed slot counts
    training.gsub!(/\{\d+\}/, '')
    {
      distance: Levenshtein.distance(recording[0,$options[:truncate]], training[0,$options[:truncate]]),
      file: train_file
    }
  end

  closest_distance = 1_000_000_000
  closest_file = nil

  distances.each do |hash|
    if hash[:distance] < closest_distance
      closest_distance = hash[:distance]
      closest_file = hash[:file]
    end
  end

  url_hash = closest_file.split("_")[0]
  if closest_distance>=recording.length
    puts "deteced, but no confidence"
    exit
  end
  value = (1 - closest_distance/recording.length).round(3)
  puts "#{Time.now.utc.iso8601} detected page: #{hash_to_url[url_hash]}, with confidence value: #{100*value}%"

  output_yaml[filename] = distances
end

if $options[:outputfile]
  File.open( $options[:outputfile], "w" ) do |f|
    f.write(YAML.dump(output_yaml))
  end
end

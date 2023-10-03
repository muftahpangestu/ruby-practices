# frozen_string_literal: true

require 'optparse'

COLUMN_WIDTH = 10

def get_wc_detail(file_text, path = '')
  { 'rows' => file_text.lines.length, 'words' => file_text.split.size, 'size' => file_text.bytesize, 'path' => path }
end

def print_all?(wc_options)
  wc_options['l'] || wc_options['w'] || wc_options['c'] ? false : true
end

def formatted_print(wc_detail, wc_options)
  print_all = print_all?(wc_options)

  print wc_detail['rows'].to_s.center(COLUMN_WIDTH) if wc_options['l'] || print_all
  print wc_detail['words'].to_s.center(COLUMN_WIDTH) if wc_options['w'] || print_all
  print wc_detail['size'].to_s.center(COLUMN_WIDTH) if wc_options['c'] || print_all
  puts wc_detail['path']
end

wc_detail = []
wc_options = ARGV.getopts('lwc')

ls_output = $stdin.stat.size.positive? ? $stdin.read : false

input_contents = []

if ls_output
  input_contents << [ls_output, '']
else
  ARGV.each do |path|
    File.open(path, 'r') do |file|
      input_contents << [file.read, path]
    end
  end
end

total_row = 0
total_word = 0
total_size = 0

input_contents.each do |wc_line|
  wc_detail = get_wc_detail(*wc_line)
  formatted_print(wc_detail, wc_options)
  next unless input_contents.length > 1

  total_row += wc_detail['rows']
  total_word += wc_detail['words']
  total_size += wc_detail['size']
end

formatted_print({ 'rows' => total_row, 'words' => total_word, 'size' => total_size, 'path' => '' }, wc_options) if input_contents.length > 1

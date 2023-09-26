# frozen_string_literal: true

require 'optparse'
require 'debug'

COLUMN_WIDTH = 8

def get_wc_detail(file_text, path)
  { 'rows' => file_text.lines.length, 'words' => file_text.split.size, 'size' => File.size(path), 'path' => path }
end

def check_print_all(wc_options)
  wc_options['l'] || wc_options['w'] || wc_options['c'] ? false : true
end

def formatted_print(row_count, word_count, size, path, wc_options)
  print_all = check_print_all(wc_options)
  print row_count.center(COLUMN_WIDTH) if wc_options['l'] || print_all
  print word_count.center(COLUMN_WIDTH) if wc_options['w'] || print_all
  print size.center(COLUMN_WIDTH) if wc_options['c'] || print_all
  puts path
end

wc_detail = []
wc_options = ARGV.getopts('lwc')

ls_output = $stdin.stat.size.positive? ? $stdin.read : false

total_row = 0
total_word = 0
total_size = 0

if ls_output
  formatted_print(ls_output.lines.length.to_s, ls_output.split.size.to_s, ls_output.bytesize.to_s, '', wc_options)
else
  ARGV.each do |path|
    File.open(path, 'r') do |file|
      wc_detail << get_wc_detail(file.read, path)
    end
  end
  wc_detail.each do |wc_line|
    row_count = wc_line['rows']
    word_count = wc_line['words']
    file_size = wc_line['size']
    file_path = wc_line['path']

    total_row += row_count
    total_word += word_count
    total_size += file_size

    formatted_print(row_count.to_s, word_count.to_s, file_size.to_s, file_path, wc_options)
  end

  formatted_print(total_row.to_s, total_word.to_s, total_size.to_s, 'total', wc_options)
end

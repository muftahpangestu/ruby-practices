# frozen_string_literal: true

strike = 10
total_score = 0
current_position = 0

scoreboard = ARGV[0].split(',').collect { |score| score == 'X' ? strike : score.to_i }

1.upto(10) do
  if scoreboard[current_position] == strike
    total_score += strike + scoreboard[current_position + 1] + scoreboard[current_position + 2]
    current_position += 1
  else
    frame_score = scoreboard[current_position].to_i + scoreboard[current_position + 1].to_i
    total_score += frame_score < strike ? frame_score : frame_score + scoreboard[current_position + 2]
    current_position += 2
  end
end

puts total_score
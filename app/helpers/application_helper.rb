module ApplicationHelper
  def dnd_modifier(score)
    mod = ((score.to_i - 10) / 2.0).floor
    mod >= 0 ? "+#{mod}" : mod.to_s
  end

  def hp_percentage(current, max)
    return 0 if max.to_i.zero?
    [ (current.to_f / max.to_f * 100).round, 100 ].min
  end
end

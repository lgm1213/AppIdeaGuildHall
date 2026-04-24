GameSystem.find_or_create_by!(slug: "dnd5e") do |gs|
  gs.name        = "Dungeons & Dragons 5e"
  gs.description = "The world's greatest roleplaying game. Fifth edition rules."
  gs.stat_template = {
    "stats" => [
      { "key" => "strength",     "label" => "STR" },
      { "key" => "dexterity",    "label" => "DEX" },
      { "key" => "constitution", "label" => "CON" },
      { "key" => "intelligence", "label" => "INT" },
      { "key" => "wisdom",       "label" => "WIS" },
      { "key" => "charisma",     "label" => "CHA" }
    ],
    "classes" => %w[
      Barbarian Bard Cleric Druid Fighter Monk
      Paladin Ranger Rogue Sorcerer Warlock Wizard
    ],
    "alignments" => [
      "Lawful Good", "Neutral Good", "Chaotic Good",
      "Lawful Neutral", "True Neutral", "Chaotic Neutral",
      "Lawful Evil", "Neutral Evil", "Chaotic Evil"
    ]
  }
end

puts "Seeded: #{GameSystem.count} game system(s)"

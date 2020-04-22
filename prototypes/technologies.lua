-- Common Technology with some of Optera's simple combinator mods and with justarandomgeek's Utility Combinators
local unlocks = {
  {type = "unlock-recipe", recipe = "large-combinator"},
  {type = "unlock-recipe", recipe = "alphabet-combinator"},
  {type = "unlock-recipe", recipe = "stacksizep-combinator"},
  {type = "unlock-recipe", recipe = "stacksizem-combinator"},
}

if data.raw["technology"]["circuit-network-2"] then
  for _,unlock in pairs(unlocks) do
    table.insert( data.raw["technology"]["circuit-network-2"].effects, unlock)
  end
else
  data:extend({
    {
      type = "technology",
      name = "circuit-network-2",
      icon = "__base__/graphics/technology/circuit-network.png",
      icon_size = 128,
      prerequisites = {"circuit-network", "advanced-electronics"},
      effects = unlocks,
      unit =
      {
        count = 150,
        ingredients = {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
        },
        time = 30
      },
      order = "a-d-d"
    }
  })
end

for _,force in pairs(game.forces) do
  force.recipes["large-combinator"].enabled = force.technologies["circuit-network-2"].researched
  force.recipes["alphabet-combinator"].enabled = force.technologies["circuit-network-2"].researched
  force.recipes["stacksizep-combinator"].enabled = force.technologies["circuit-network-2"].researched
  force.recipes["stacksizem-combinator"].enabled = force.technologies["circuit-network-2"].researched
end

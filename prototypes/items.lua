data:extend{
  {
    type = "item",
    name = "large-combinator",
    icons = {
      { icon = "__base__/graphics/icons/constant-combinator.png", icon_size = 32, },
      { icon = "__base__/graphics/icons/signal/signal_L.png", icon_size = 32, scale = 0.6, },
    },
    subgroup = "circuit-network",
    place_result="large-combinator",
    order = "b[combinators]-d[large-combinator]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "alphabet-combinator",
    icons = {
      { icon = "__base__/graphics/icons/constant-combinator.png", icon_size = 32, },
      { icon = "__base__/graphics/icons/signal/signal_A.png", icon_size = 32, scale = 0.6, },
    },
    subgroup = "circuit-network",
    place_result="alphabet-combinator",
    order = "b[combinators]-d[alphabet-combinator]",
    stack_size = 50,
  },
  {
    type = "item",
    name = "stacksizep-combinator",
    icons = {
      { icon = "__base__/graphics/icons/constant-combinator.png", icon_size = 32, },
      { icon = "__base__/graphics/icons/signal/signal_S.png", icon_size = 32, scale = 0.5, shift = {-8,0} },
      { icon = "__base__/graphics/icons/signal/signal_P.png", icon_size = 32, scale = 0.5, shift = {8,0} },
    },
    subgroup = "circuit-network",
    place_result="stacksizep-combinator",
    order = "b[combinators]-d[stacksizep-combinator]",
    stack_size = 50,
  },
    {
    type = "item",
    name = "stacksizem-combinator",
    icons = {
      { icon = "__base__/graphics/icons/constant-combinator.png", icon_size = 32, },
      { icon = "__base__/graphics/icons/signal/signal_S.png", icon_size = 32, scale = 0.5, shift = {-8,0} },
      { icon = "__base__/graphics/icons/signal/signal_M.png", icon_size = 32, scale = 0.5, shift = {8,0} },
    },
    subgroup = "circuit-network",
    place_result="stacksizem-combinator",
    order = "b[combinators]-d[stacksizem-combinator]",
    stack_size = 50,
  },
  }

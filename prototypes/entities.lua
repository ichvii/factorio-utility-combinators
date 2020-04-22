local entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
entity.name = "large-combinator"
entity.minable.result = "large-combinator"
entity.item_slot_count = 10000
data:extend{entity}

local entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
entity.name = "alphabet-combinator"
entity.minable.result = "alphabet-combinator"
entity.item_slot_count = 10000
data:extend{entity}

local entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
entity.name = "stacksizep-combinator"
entity.minable.result = "stacksizep-combinator"
entity.item_slot_count = 10000
data:extend{entity}

local entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
entity.name = "stacksizem-combinator"
entity.minable.result = "stacksizem-combinator"
entity.item_slot_count = 10000
data:extend{entity}



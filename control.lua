function get_signal_from_set(signal,set)
  for _,sig in pairs(set) do
    if sig.signal.type == signal.type and sig.signal.name == signal.name then
      return sig.count
    end
  end
  return nil
end




function onBuilt(event)
  local entity=event.created_entity
  if entity.name == "alphabet-combinator" then
    entity.operable = false
    local control = entity.get_or_create_control_behavior()
    control.parameters={enabled=true,parameters=global.alphabetframe or {}}
  elseif entity.name == "stacksizep-combinator" then
    entity.operable = false
    local control = entity.get_or_create_control_behavior()
    control.parameters={enabled=true,parameters=global.stackpframe or {}}
  elseif entity.name == "stacksizem-combinator" then
    entity.operable = false
    local control = entity.get_or_create_control_behavior()
    control.parameters={enabled=true,parameters=global.stackmframe or {}}
  end  
end

local function onInit()
  global = {
    alphabetframe={ 
    },
    stackpframe={ 
    },
    stackmframe={ 
    },
  }

  --alphabet-combinator
    
    for _, sig in pairs(game.virtual_signal_prototypes) do
      if (sig.name~="signal-everything" and sig.name~="signal-anything" and sig.name~="signal-each") then
        global.alphabetframe[#global.alphabetframe+1 or 1]= {index = #global.alphabetframe+1, count= #global.alphabetframe+1, signal = {name=sig.name, type="virtual"}}
      end
    end
    for _, i in pairs(game.item_prototypes) do
      global.alphabetframe[#global.alphabetframe+1 or 1]= {index = #global.alphabetframe+1, count= #global.alphabetframe+1, signal = {name=i.name, type="item"}}
    end
    for _, f in pairs(game.fluid_prototypes) do
      global.alphabetframe[#global.alphabetframe+1 or 1]= {index = #global.alphabetframe+1, count= #global.alphabetframe+1, signal = {name=f.name, type="fluid"}}
    end
  

    
    --stacksizep-combinator
  
    for _, i in pairs(game.item_prototypes) do
      global.stackpframe[#global.stackpframe+1 or 1]= {index = #global.stackpframe+1, count= i.stack_size, signal = {name=i.name, type="item"}}
    end

    --stacksizem-combinator

    for _, i in pairs(game.item_prototypes) do
      global.stackmframe[#global.stackmframe+1 or 1]= {index = #global.stackmframe+1, count= 100000 / i.stack_size, signal = {name=i.name, type="item"}}
    end


  -- index existing combinators (init and config changed to capture from deprecated mods as well)
  -- and re-index the world
  for _,surf in pairs(game.surfaces) do
    for _,ent in pairs(
      surf.find_entities_filtered{name =
      {"alphabet-combinator", "stacksizep-combinator", "stacksizem-combinator" }}
    ) do
      onBuilt({created_entity=ent})
    end
  end
end


script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, onBuilt)
script.on_init(onInit)
script.on_configuration_changed(onInit)

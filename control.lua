function get_signal_from_set(signal,set)
  for _,sig in pairs(set) do
    if sig.signal.type == signal.type and sig.signal.name == signal.name then
      return sig.count
    end
  end
  return nil
end

function UpdateBonuses()
  for forcename,force in pairs(game.forces) do
    global.bonusframe[forcename] = {
      --{index=1,count=0,signal={name="signal-grey",type="virtual"}}

      {index=1,count=force.worker_robots_storage_bonus           ,signal={name="signal-R",type="virtual"}},
      {index=2,count=force.inserter_stack_size_bonus             ,signal={name="signal-I",type="virtual"}},
      {index=3,count=force.stack_inserter_capacity_bonus         ,signal={name="signal-J",type="virtual"}},
      {index=4,count=force.character_logistic_slot_count         ,signal={name="signal-L",type="virtual"}},
      {index=5,count=force.character_trash_slot_count            ,signal={name="signal-T",type="virtual"}},
      {index=6,count=force.maximum_following_robot_count         ,signal={name="signal-F",type="virtual"}},
      {index=7,count=force.mining_drill_productivity_bonus * 100 ,signal={name="signal-P",type="virtual"}},
    }
  end
end

function UpdateResearch()
  local newframes = {}
  for forcename,force in pairs(game.forces) do

    if force.current_research then
      local extras = {
        {index=1,
        count=math.floor(game.forces[forcename].research_progress * 100),
        signal={name="signal-grey",type="virtual"}},
        {index=2,
        count=force.current_research.research_unit_count,
        signal={name="signal-white",type="virtual"}},

      }

      for i,item in pairs(force.current_research.research_unit_ingredients) do
        extras[#extras+1] = {
          index  = #extras+1,
          count  = item.amount,
          signal = {name=item.name,type=item.type},
        }
      end

      if remote.interfaces['signalstrings'] then
        newframes[forcename] = remote.call('signalstrings','string_to_signals',force.current_research.name, extras)
      else
        newframes[forcename] = extras
      end

    else
      newframes[forcename] = {
        {index=1,count=0,signal={name="signal-grey",type="virtual"}}
      }
    end
  end
  global.researchframe = newframes
end

function playerFrame(player)
  local extras = {
    {index=1,count=player.connected and 1 or 0 ,signal={name="signal-green",type="virtual"}},
    {index=2,count=player.admin and 1 or 0 ,signal={name="signal-red",type="virtual"}},
  }
  if remote.interfaces['signalstrings'] then
    return remote.call('signalstrings','string_to_signals',player.name, extras)
  else
    return extras
  end
end

function onForceResearchChange(event)
  UpdateBonuses()
  UpdateResearch()

  for n,rcc in pairs(global.researchcc) do
    if rcc.entity.valid and rcc.control.valid then
      rcc.control.parameters={enabled=true,parameters=global.researchframe[rcc.entity.force.name] or {}}
    else
      global.researchcc[n] = nil
    end
  end
  for n,bcc in pairs(global.bonuscc) do
    if bcc.entity.valid and bcc.control.valid then
      bcc.control.parameters={enabled=true,parameters=global.bonusframe[bcc.entity.force.name] or {}}
    else
      global.bonuscc[n] = nil
    end
  end
end

function onBuilt(event)
  local entity=event.created_entity
  if entity.name == "bonus-combinator" then
    entity.operable = false

    local control = entity.get_or_create_control_behavior()
    control.parameters={enabled=true,parameters=global.bonusframe[entity.force.name] or {}}
    global.bonuscc[entity.unit_number] = {entity=entity,control=control}

  elseif entity.name == "location-combinator" then
    local control = entity.get_or_create_control_behavior()
    control.enabled=true
    control.parameters={parameters={
      {index=1,count=math.floor(entity.position.x),signal={name="signal-X",type="virtual"}},
      {index=2,count=math.floor(entity.position.y),signal={name="signal-Y",type="virtual"}},
      {index=3,count=entity.surface.index,signal={name="signal-Z",type="virtual"}}
    }}
    entity.operable=false
  elseif entity.name == "player-combinator" then

    local control = entity.get_or_create_control_behavior()
    global.playercc[entity.unit_number] = {entity=entity,control=control}
  elseif entity.name == "research-combinator" then
    entity.operable = false
    local control = entity.get_or_create_control_behavior()
    global.researchcc[entity.unit_number] = {entity=entity,control=control}
    control.parameters={enabled=true,parameters=global.researchframe[entity.force.name] or {}}
  elseif entity.name == "alphabet-combinator" then
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
    control.parameters={enabled=true,parameters=global.stackmframe}
  end  
end

local function onInit()
  global = {
    bonuscc = {
      --[unit_number] = {entity, control},
    },
    bonusframe = {
      --[force.name] = ccdata,
    },

    playercc = {
      --[unit_number] = {entity, control},
    },
    playerframes = {
      --[player.index] = ccdata,
    },

    researchcc = {
      --[unit_number] = {entity, control},
    },
    researchframe = {
      --[force.name] = ccdata,
    },
    alphabetframe={ 
      {index=1,count=0,signal={name="signal-grey",type="virtual"}}
    },
    stackpframe={ 
      {index=1,count=0,signal={name="signal-grey",type="virtual"}}
    },
    stackmframe={ 
      {index=1,count=0,signal={name="signal-grey",type="virtual"}}
    },
  }

  -- bonus combinator
  UpdateBonuses()

  -- player combinator
  for i,p in pairs(game.players) do
    global.playerframes[i]=playerFrame(p)
  end
  global.globalplayerframe={
    {index=1,count=#game.connected_players,signal={name="signal-green",type="virtual"}},
    {index=2,count=#game.players,signal={name="signal-blue",type="virtual"}},
  }

  -- research combinator
  UpdateResearch()

  --alphabet-combinator

  for _, s in pairs(game.virtual_signal_prototypes) do
    alphabetframe[#alphabetframe+1]= {index = #alphabetframe+1, count= #alphabetframe+1, signal = {name=s.name, type="virtual"}}
  end
  for _, i in pairs(game.item_prototypes) do
    alphabetframe[#alphabetframe+1]= {index = #alphabetframe+1, count= #alphabetframe+1, signal = {name=i.name, type="item"}}
  end
  for _, f in pairs(game.fluid_prototypes) do
    alphabetframe[#alphabetframe+1]= {index = #alphabetframe+1, count= #alphabetframe+1, signal = {name=f.name, type="fuid"}}
  end
  
  --stacksizep-combinator

  for _, i in pairs(game.item_prototypes) do
    stackpframe[#stackpframe+1]= {index = #stackpframe+1, count= i.stack_size, signal = {name=i.name, type="item"}}
  end

  --stacksizem-combinator

  for _, i in pairs(game.item_prototypes) do
    stackmframe[#stackmframe+1]= {index = #stackmframe+1, count= 100000 / i.stack_size, signal = {name=i.name, type="item"}}
  end

  -- index existing combinators (init and config changed to capture from deprecated mods as well)
  -- and re-index the world
  for _,surf in pairs(game.surfaces) do
    -- re-index all nixies. non-nixie lamps will be ignored by onPlaceEntity
    for _,ent in pairs(
      surf.find_entities_filtered{name =
      {"bonus-combinator", "location-combinator", "player-combinator", "research-combinator", "alphabet-combinator", "stacksizep-combinator", "stacksizem-combinator" }}
    ) do
      onBuilt({created_entity=ent})
    end
  end
end

function onConfigChanged(data)
  if data.mod_changes and data.mod_changes["utility-combinators"] then
   --If my data has changed, rebuild all my tables.
   -- OnInit has to rebuild thigns anyway to catch deprecated single-combinator mods
   OnInit()
  end
end

function onPlayerChanged(event)
  local i = event.player_index
  local p = game.players[i]
  global.playerframes[i]=playerFrame(p)

  global.globalplayerframe={
    {index=1,count=#game.connected_players,signal={name="signal-green",type="virtual"}},
    {index=2,count=#game.players,signal={name="signal-blue",type="virtual"}},
  }
end

function onTick()
  --player
  for n,pcc in pairs(global.playercc) do
    if pcc.entity.valid and pcc.control.valid then

      local signals = pcc.entity.get_merged_signals() or {}
      local req = get_signal_from_set({name="signal-grey",type="virtual"},signals) or 0
      if req == 0 then
        pcc.control.parameters={enabled=true,parameters=global.globalplayerframe}
      else
        pcc.control.parameters={enabled=true,parameters=global.playerframes[req] or {}}
      end
    else
      global.playercc[n] = nil
    end
  end

  --research
  --TODO: move to an on_nth_tick
  if game.tick % 60 == 0 then

    UpdateResearch()

    for n,rcc in pairs(global.researchcc) do
      if rcc.entity.valid and rcc.control.valid then
        rcc.control.parameters={enabled=true,parameters=global.researchframe[rcc.entity.force.name] or {}}
      else
        global.researchcc[n] = nil
      end
    end
  end
end

script.on_event({defines.events.on_research_started, defines.events.on_research_finished, defines.events.on_force_created,defines.events.on_forces_merging}, onForceResearchChange)
script.on_event(defines.events.on_tick, onTick)
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, onBuilt)
script.on_event({defines.events.on_player_created, defines.events.on_player_joined_game, defines.events.on_player_left_game, defines.events.on_player_promoted, defines.events.on_player_demoted}, onPlayerChanged)
script.on_init(onInit)

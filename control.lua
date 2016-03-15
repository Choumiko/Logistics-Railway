require "util"
require "defines"

script.on_event(defines.events.on_built_entity, function(event)
	local extradummy = event.created_entity.surface.find_entity("requester-rail-dummy-chest", event.created_entity.position)
	if extradummy then
		extradummy.destroy()
	end
	if event.created_entity.name == "requester-rail" then
		local dummy = event.created_entity.surface.create_entity({name = "requester-rail-dummy-chest", position = event.created_entity.position, force = event.created_entity.force})
		dummy.insert{name="dummy-item", count=1}
	end
end)

script.on_event(defines.events.on_robot_built_entity, function(event)
	local extradummy = event.created_entity.surface.find_entity("requester-rail-dummy-chest", event.created_entity.position)
	if extradummy then
		extradummy.destroy()
	end
	if event.created_entity.name == "requester-rail" then
		local dummy = event.created_entity.surface.create_entity({name = "requester-rail-dummy-chest", position = event.created_entity.position, force = event.created_entity.force})
		dummy.insert{name="dummy-item", count=1}
	end
end)

script.on_event(defines.events.on_preplayer_mined_item, function(event)
	if event.entity.name == "requester-rail-dummy-chest" then
		local dummy = event.entity.surface.find_entity("requester-rail", event.entity.position)
		if dummy then
			dummy.destroy()
		end
		return event.entity.clear_items_inside()
	end
	if event.entity.name == "requester-rail" then
		local dummy = event.entity.surface.find_entity("requester-rail-dummy-chest", event.entity.position)
		if dummy then
			dummy.destroy()
		end
	end
end)

script.on_event(defines.events.on_entity_died, function(event)
	if event.entity.name == "requester-rail-dummy-chest" then
		local dummy = event.entity.surface.find_entity("requester-rail", event.entity.position)
		if dummy then
			dummy.destroy()
		end
		return event.entity.clear_items_inside()
	end
end)

script.on_event(defines.events.on_robot_pre_mined, function(event)
	if event.entity.name == "requester-rail" then
		local dummy = event.entity.surface.find_entity("requester-rail-dummy-chest", event.entity.position)
		if dummy then
			dummy.destroy()
		end
	end
end)

script.on_event(defines.events.on_entity_died, function(event)
	if event.entity.name == "requester-rail-dummy-chest" then
		local dummy = event.entity.surface.find_entity("requester-rail", event.entity.position)
		if dummy then
			dummy.destroy()
		end
	end
end)

script.on_event(defines.events.on_train_changed_state, function(event)
	if event.train.state == defines.trainstate.wait_station and event.train.speed == 0 then -- Wagons only interact with the logistics network when they are waiting at a station in automatic mode
		placeChests(event.train)
	else
		syncChests(event.train)
	end
end)

function copyInventory(from, to)
	local inventory = from.get_inventory(defines.inventory.chest)
	local contents = inventory.get_contents()
	for n, c in pairs(contents) do
		to.insert({name=n, count=c})
	end
end

function placeChests(train)
	for i = 1, #train.cargo_wagons do
		local wagon = train.cargo_wagons[i]
		if wagon.type == "cargo-wagon" then
			local requester = wagon.surface.find_entity("requester-rail", wagon.position)
			local passive_provider = wagon.surface.find_entity("passive-provider-rail", wagon.position)
			local active_provider = wagon.surface.find_entity("active-provider-rail", wagon.position)
			local storage = wagon.surface.find_entity("storage-rail", wagon.position)
			if requester then
				wagon.minable = false
				wagon.operable = false
				local chest = wagon.surface.create_entity({name = "requester-chest-from-wagon", position = wagon.position, force = wagon.force})
				local wagon_inventory = wagon.get_inventory(defines.inventory.chest)
				wagon_inventory.setbar(0)
				local chest_inventory = chest.get_inventory(defines.inventory.chest)
				if #chest_inventory > #wagon_inventory then
					chest_inventory.setbar(#wagon_inventory)
				end
				copyInventory(wagon, chest) -- Wagon to chest
				wagon.clear_items_inside()
				local dummy_requester = wagon.surface.find_entity("requester-rail-dummy-chest", wagon.position)
				for s = 1, 10 do			-- It seems all requester chests are limited to 10 request slots
					local request = dummy_requester.get_request_slot(s)
					if request then
						chest.set_request_slot(request, s)
					end
				end
			end
			if passive_provider then
				wagon.minable = false
				wagon.operable = false
				local chest = wagon.surface.create_entity({name = "passive-provider-chest-from-wagon", position = wagon.position, force = wagon.force})
				local wagon_inventory = wagon.get_inventory(defines.inventory.chest)
				wagon_inventory.setbar(0)
				copyInventory(wagon, chest) -- Wagon to chest
				wagon.clear_items_inside()
			end
			if active_provider then
				wagon.minable = false
				wagon.operable = false
				local chest = wagon.surface.create_entity({name = "active-provider-chest-from-wagon", position = wagon.position, force = wagon.force})
				local wagon_inventory = wagon.get_inventory(defines.inventory.chest)
				wagon_inventory.setbar(0)
				copyInventory(wagon, chest) -- Wagon to chest
				wagon.clear_items_inside()
			end
			if storage then
				wagon.minable = false
				wagon.operable = false
				local chest = wagon.surface.create_entity({name = "storage-chest-from-wagon", position = wagon.position, force = wagon.force})
				local wagon_inventory = wagon.get_inventory(defines.inventory.chest)
				wagon_inventory.setbar(0)
				local chest_inventory = chest.get_inventory(defines.inventory.chest)
				if #chest_inventory > #wagon_inventory then
					chest_inventory.setbar(#wagon_inventory)
				end
				copyInventory(wagon, chest) -- Wagon to chest
				wagon.clear_items_inside()
			end
		end
	end
end

function syncChests(train)
	for i = 1, #train.cargo_wagons do
		local wagon = train.cargo_wagons[i]
		if wagon.type == "cargo-wagon" then
			local requester = wagon.surface.find_entity("requester-chest-from-wagon", wagon.position)
			local passive_provider = wagon.surface.find_entity("passive-provider-chest-from-wagon", wagon.position)
			local active_provider = wagon.surface.find_entity("active-provider-chest-from-wagon", wagon.position)
			local storage = wagon.surface.find_entity("storage-chest-from-wagon", wagon.position)
			if requester then
				local wagon_inventory = wagon.get_inventory(defines.inventory.chest)
				wagon_inventory.setbar()
				copyInventory(requester, wagon) -- Chest to wagon
				requester.destroy()
				wagon.minable = true
				wagon.operable = true
			end
			if passive_provider then
				local wagon_inventory = wagon.get_inventory(defines.inventory.chest)
				wagon_inventory.setbar()
				copyInventory(passive_provider, wagon) -- Chest to wagon
				passive_provider.destroy()
				wagon.minable = true
				wagon.operable = true
			end
			if active_provider then
				local wagon_inventory = wagon.get_inventory(defines.inventory.chest)
				wagon_inventory.setbar()
				copyInventory(active_provider, wagon) -- Chest to wagon
				active_provider.destroy()
				wagon.minable = true
				wagon.operable = true
			end
			if storage then
				local wagon_inventory = wagon.get_inventory(defines.inventory.chest)
				wagon_inventory.setbar()
				copyInventory(storage, wagon) -- Chest to wagon
				storage.destroy()
				wagon.minable = true
				wagon.operable = true
			end
		end
	end
end

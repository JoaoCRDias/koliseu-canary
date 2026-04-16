local blessingsBook = Action()

function blessingsBook.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	Blessings.BuyAllBlesses(player, true)
	return true
end

blessingsBook:id(60143)
blessingsBook:register()

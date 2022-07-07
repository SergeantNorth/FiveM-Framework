if (GetCurrentResourceName() ~= "SNP_Fuel") then
    print("[^1DEBUG^0] Please make sure the resource name is ^3SNP_Fuel^0 or else exports won't work.")
end

if Config.UseMoney then
	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local src = source
		local xPlayer = exports.SNP_Money:getaccount(src)
		local fix =  xPlayer.bank - tonumber(price)
		if tonumber(price) > 0 then
			exports.SNP_Money:updateaccount(src, {cash = xPlayer.amount, bank = fix})
		end
	end)
end

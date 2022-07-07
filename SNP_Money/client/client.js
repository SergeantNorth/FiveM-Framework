let stuff = []
let start = false
let enableHud = true


setTick(() => {
    Delay(0)
    if (start) {
        draw()
    }
})

RegisterNetEvent('SERGEANTNORTH:UPDATECLIENTMONEY')
on('SERGEANTNORTH:UPDATECLIENTMONEY', (coolarray) => {
    stuff = coolarray
    if (stuff) {
        start = true
    }
})


RegisterNetEvent('SERGEANTNORTH:UPDATEPAYCHECK')
on('SERGEANTNORTH:UPDATEPAYCHECK', (id, moneyarray) => {
    stuff = moneyarray
    if (stuff) {
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName("You have received your daily pay check. Amount: $" + stuff.cycle.toLocaleString())
        EndTextCommandThefeedPostMessagetext("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", false, 9, "Bank", "Daily Pay Check")
        EndTextCommandThefeedPostTicker(true, false)
    }

})

RegisterNetEvent('SERGEANTNORTH:UPDATEPAY')
on('SERGEANTNORTH:UPDATEPAY', (id, money) => {
    stuff = money
})


RegisterNetEvent('SERGEANTNORTH:BANKNOTIFY')
on('SERGEANTNORTH:BANKNOTIFY', (msg) => {
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostMessagetext("CHAR_BANK_FLEECA", "CHAR_BANK_FLEECA", false, 9, "Bank", "Account Notification")
    EndTextCommandThefeedPostTicker(true, false)
})


function draw() {
    if (stuff && enableHud) {
        SetTextFont(4)
        SetTextScale(0.44, 0.44)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(`Cash: ~c~${stuff.amount.toLocaleString()} ~s~| Bank: ~c~${stuff.bank.toLocaleString()}`)
        DrawText(0.16, 0.845)
    }
}

function Delay(ms) { //Use this function instead of Wait()
    return new Promise((res) => {
        setTimeout(res, ms)
    })
}

exports('getclientaccount', (id) => {
    if (id) {
        if (stuff) {
            return stuff
        } else {
            return false
        }
    } else {
        return false
    }
})


RegisterCommand('mhud', function(source) {
    if (enableHud) {
        enableHud = false
    } else {
        enableHud = true
    }
    emit('chatMessage', `[^3SYSTEM^7] You have ${enableHud == true ? "Enabled" : "Disabled"} the money hud.`)
})